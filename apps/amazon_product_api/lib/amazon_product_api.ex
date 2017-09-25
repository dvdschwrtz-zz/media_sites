defmodule AmazonProductApi do
  @moduledoc """
  Documentation for AmazonProductApi.
  """

  # TODO fix the logger so it actually works
  #import Logger
  import SweetXml

  alias AmazonProductAdvertisingClient.{ItemLookup, ItemSearch}
  alias AmazonProductApi.{BestSeller, BrowseNodeSearch, Category, Item, Repo, Result}

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: Media.Worker.start_link(arg1, arg2, arg3)
      # worker(Media.Worker, [arg1, arg2, arg3]),
      supervisor(Repo, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AmazonProductApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc """
  will return a csv of all Amazon and scraped results from the database
  Currently, this will return category name, average price, average and max sales rank
  as well as average and relative keyword scores from Google Trends

  """
  @spec results_csv(String.t) :: :ok
  def results_csv(file_name) do
    Result.results_to_csv(file_name)
  end

  @doc """
  will return a csv of all Amazon item related info only
  Currently, this will return category name, average price, average and max sales rank

  """
  @spec items_csv(String.t) :: :ok
  def items_csv(file_name) do
    Item.items_summary_to_csv(file_name)
  end

  @doc """
  gets a list of all categories and their average prices and puts them into a detabase.
  The baby category is the default for first level call.

  """
  @spec get_categories(pos_integer) :: :ok
  def get_categories(category_id \\ 165796011) do
    result = BrowseNodeSearch.execute(%BrowseNodeSearch{
      BrowseNodeId: category_id,
      Availability: "Available",
      Operation: "BrowseNodeLookup"
    })

    case result do
      {:ok, %{body: body}} ->
        new_category_list = xpath(
          body,
          ~x"//Children/BrowseNode"l,
          id: ~x"./BrowseNodeId/text()",
          name: ~x"./Name/text()"
        )

        ecto_category_id_list = case Repo.all(Category) do
          nil -> :noop
          categories -> Enum.reduce(categories, %{}, fn(%{category_id: id}, acc) -> Map.put(acc, id, true) end)
        end

        new_category_list
        |> Stream.reject(fn(%{id: id}) -> Map.has_key?(ecto_category_id_list, id) end)
        |> Enum.map(fn(%{id: id, name: name}) ->
          Category.create(%{
            category_name: to_string(name),
            category_id: to_string(id)
          })

          get_categories(id)
          :timer.sleep(1000)
        end)
      {:error, reason} ->
        # TODO ch101 fix logger so that it it calls itself again if timeout occurs
        IO.inspect("Category id: #{category_id}; error: #{reason}")
    end
  end

  @spec get_bestsellers :: :ok
  def get_bestsellers do
    Enum.each(Category.all(), fn(%{called: called} = category) ->
      case called do
        true -> :noop
        false -> call_amazon_for_bestsellers(category)
      end
    end)
  end

  @spec call_amazon_for_bestsellers(Category.t) :: :ok
  def call_amazon_for_bestsellers(category) do
    %{
      category_id: category_id,
      category_name: category_name,
      id: category_key
    } = category

    result = ItemSearch.execute(%ItemSearch{
      BrowseNodeId: category_id,
      Operation: "BrowseNodeLookup",
      ResponseGroup: "TopSellers",
      Availability: "Available",
      Condition: "New"
    })

    case result do
      {:ok, %{body: body}} ->
        Repo.get(Category, category_key)
        |> Ecto.Changeset.change(called: true)
        |> Repo.update

        items_list = xpath(
          body,
          ~x"//TopSeller"l,
          id: ~x"./ASIN/text()",
          name: ~x"./Title/text()"
        )

        Enum.each(items_list, fn(%{id: item_id, name: item_name}) ->
          BestSeller.create(%{
            category_name: to_string(category_name),
            category_id: to_string(category_id),
            item_name: String.slice(to_string(item_name), 0..100),
            item_id: to_string(item_id),
            cat_item_id: to_string(category_id) <> to_string(item_id)
          })
          :timer.sleep(1000)
        end)

      {:error, reason} ->
        # TODO ch101 fix logger so that it works and have it call itself again if timeout occurs
        IO.inspect("Bestseller name: #{category_name}; id: #{category_id} error: #{reason}")
    end
  end

  @spec get_prices :: :ok
  def get_prices do
    Enum.each(BestSeller.all(), fn(%{called: called} = best_seller) ->
      case called do
        true -> :noop
        false ->
          :timer.sleep(1000)
          call_amazon_for_prices(best_seller)
      end
    end)
  end

  @spec call_amazon_for_prices(BestSeller.t) :: Item.t
  defp call_amazon_for_prices(best_seller) do
    %{
      category_id: category_id,
      category_name: category_name,
      item_name: item_name,
      item_id: item_id,
      id: best_seller_key
    } = best_seller

    result = ItemLookup.execute(%ItemLookup{
      Condition: "New",
      ItemId: item_id,
      Operation: "ItemLookup",
      ResponseGroup: "Offers,SalesRank",
      IdType: "ASIN"
    })

    case result do
      {:ok, %{body: body}} ->
        Repo.get(BestSeller, best_seller_key)
        |> Ecto.Changeset.change(called: true)
        |> Repo.update

        xml_result = xpath(body,
          ~x"//Item"l,
          lowest_price: ~x"./OfferSummary/LowestNewPrice/FormattedPrice/text()",
          sales_rank: ~x"./SalesRank/text()"
        )

        case xml_result do
          [] -> :noop
          [%{lowest_price: lowest_price, sales_rank: sales_rank}] ->
            case lowest_price do
              nil -> :noop
              'Too low to display' -> :noop
              price_response ->
                lowest_price =
                  price_response
                  |> to_string
                  |> String.replace("$", "")
                  |> String.replace(",", "")
                  |> String.to_float

                sales_rank = case is_nil(sales_rank) do
                  true ->
                    IO.puts("notify me when this happends")
                    10000
                  false -> sales_rank
                end

                Item.create(%{
                  category_name: to_string(category_name),
                  category_id: to_string(category_id),
                  sales_rank: String.to_integer(to_string(sales_rank)),
                  item_name: String.slice(to_string(item_name), 0..100),
                  item_id: to_string(item_id),
                  lowest_price: lowest_price,
                  cat_item_id: to_string(category_id) <> to_string(item_id)
                })
            end
        end
      {:error, reason} ->
        # TODO ch101 fix logger so that it works and have it call itself again if timeout occurs
        IO.inspect("Category name: #{category_name}; id: #{category_id}; Item name: #{item_name}; id: #{item_id} error: #{reason}")
    end
  end

  @doc """
  will delete all the tables in the database
  ** warning ** do not run unless necessary

  """
  @spec clear_all_tables :: {integer, nil | [term]} | no_return
  def clear_all_tables do
    Result.delete_all()
    Item.delete_all()
    BestSeller.delete_all()
    Category.delete_all()
  end
end
