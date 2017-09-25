defmodule AmazonProductApi.Item do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  alias AmazonProductApi.{Item, Repo, BestSeller, Result}

  @type t :: %Item{
    id: pos_integer,
    category_id: String.t,
    category_name: String.t,
    item_id: String.t,
    item_name: String.t,
    lowest_price: float,
    cat_item_id: String.t,
    sales_rank: pos_integer,
    scraped: boolean,
    inserted_at: Ecto.DateTime.t,
    updated_at: Ecto.DateTime.t
  }

  @type item_params :: %{
    category_id: String.t,
    category_name: String.t,
    item_id: String.t,
    item_name: String.t,
    lowest_price: float,
    cat_item_id: String.t,
    sales_rank: pos_integer,
    scraped: boolean,
  }

  schema "items" do
    field :category_name, :string
    field :category_id, :string
    field :item_name, :string
    field :item_id, :string
    field :lowest_price, :float
    field :cat_item_id, :string
    field :sales_rank, :integer
    field :scraped, :boolean, default: false

    timestamps()
  end

  @spec create(item_params) :: Item.t
  def create(item_params) do
    required_create_params = [:category_name, :category_id, :item_name, :sales_rank, :item_id, :lowest_price, :cat_item_id, :scraped]

    %Item{}
    |> cast(item_params, required_create_params)
    |> validate_required(required_create_params)
    |> unique_constraint(:cat_item_id)
    |> Repo.insert!
  end

  @spec all :: list(Item.t)
  def all do
    Repo.all(Item)
  end

  @spec delete_all :: {integer, nil | [term]} | no_return
  def delete_all do
    Repo.delete_all(Item)
  end

  @spec reset_scraped_to_false_all :: {integer, nil | [term]} | no_return
  def reset_scraped_to_false_all do
    Repo.update_all(Item, set: [scraped: false])
  end

  @spec reset_scraped_to_false_category(String.t) :: {integer, nil | [term]} | no_return
  def reset_scraped_to_false_category(category_name) do
    query = from r in Item, where: r.category_name == ^category_name
    Repo.update_all(query, set: [scraped: false])
  end

  @spec get_avg_price_and_rank_from_db :: list({String.t, float, float}) | no_return
  def get_avg_price_and_rank_from_db do
    query = from(r in Item,
              group_by: r.category_name,
              having: count(r.item_id) > 4,
              where: r.scraped == false,
              select: {r.category_name, avg(r.lowest_price), avg(r.sales_rank), min(r.sales_rank)})

    Enum.map(Repo.all(query), fn({cat, avg_price, avg_sales_rank, max_sales_rank}) ->
      [
        cat,
        Float.round(avg_price, 2),
        String.to_float(Decimal.to_string(avg_sales_rank)),
        max_sales_rank
      ]
    end)
  end

  @spec scrape_all_items(String.t) :: :ok
  def scrape_all_items(relative_term) do
    get_avg_price_and_rank_from_db()
    |> Enum.each(fn([cat, avg_price, avg_sales_rank, max_sales_rank]) ->
      query = from r in Item, where: r.category_name == ^cat
      Repo.update_all(query, set: [scraped: true])

      save_scores_to_db([cat, avg_price, avg_sales_rank, max_sales_rank], relative_term)
    end)
  end

  # TODO spec this function correctly
  @spec save_scores_to_db(list(), String.t) :: :ok
  defp save_scores_to_db([cat, avg_price, avg_sales_rank, max_sales_rank], relative_term) do
    trend_score = WebScraper.get_keyword_score(cat, cat)
    relative_trend_score = WebScraper.get_keyword_score(cat, relative_term)

    Result.create(%{
      category_name: cat,
      avg_price: avg_price,
      avg_sales_rank: avg_sales_rank,
      max_sales_rank: max_sales_rank,
      trend_score: trend_score,
      relative_trend_score: relative_trend_score,
    })
  end

  @spec items_summary_to_csv(String.t) :: :ok
  def items_summary_to_csv(file_name) do
    file = File.open!("#{file_name}.csv", [:append, :utf8])

    get_avg_price_and_rank_from_db()
    |> CSV.encode
    |> Enum.each(&IO.write(file, &1))
  end
end
