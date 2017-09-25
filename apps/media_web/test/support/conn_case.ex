defmodule MediaWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build and query models.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  # TODO use Media.Case instead and comment out the setup do and try again
  use ExUnit.CaseTemplate
  use Media.Aliases

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      use Media.Aliases
      use MediaWeb.Aliases

      import MediaWeb.Router.Helpers

      # The default endpoint for testing
      @endpoint MediaWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Media.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Media.Repo, {:shared, self()})
    end

    test_conn = %{Phoenix.ConnTest.build_conn() | host: "10kid.com", assigns: %{site_env: "10kid"}}

    {:ok, conn: test_conn}
  end

  setup do

    cat_params = ["advice", "careers"]
    subcat_params = ["sub-advice", "sub-careers"]

    first_category = Repo.insert!(%Category{owning_domain: "10kid", name: Enum.at(cat_params, 0)})
    second_category = Repo.insert!(%Category{owning_domain: "10kid", name: Enum.at(cat_params, 1)})

    first_subcategory = Repo.insert!(%Subcategory{name: Enum.at(subcat_params, 0)})
    second_subcategory = Repo.insert!(%Subcategory{name: Enum.at(subcat_params, 1)})

    {first_published, last_published} = {~D[2010-10-31], ~D[2016-10-31]}

    article_params = %{
      summary: "This is the summary",
      author: "Author 1",
      sections: [],
      owning_domain: "10kid",
      main_photo: %{
        "image" => "https://upload.wikimedia.org/wikipedia/commons/1/13/Graphics_card_3.jpg",
        "width" => 2272,
        "height" => 1704
      },
      tips: ["stay healthy","be happy"],
      things_needed: ["briefcase","laptop"],
      warnings: ["apple","day"],
      resources: [],
      references: [],
      title: "testing",
      first_published: first_published,
      last_published: last_published,
    }

    second_article_params = %{
      summary: article_params.summary <> "2",
      author: "Author 2",
      sections: [],
      owning_domain: article_params.owning_domain,
      main_photo: article_params.main_photo,
      tips: [Enum.at(article_params.tips, 0) <> "2", Enum.at(article_params.tips, 1) <> "2"],
      things_needed: [Enum.at(article_params.things_needed, 0) <> "2", Enum.at(article_params.things_needed, 1) <> "2"],
      warnings: [Enum.at(article_params.warnings, 0) <> "2", Enum.at(article_params.warnings, 1) <> "2"],
      resources: [],
      references: [],
      title: article_params.title <> "2",
      first_published: first_published,
      last_published: last_published,
    }

    # TODO ch68 revisit preloading in articles
    first_article =
      first_category
      |> Ecto.build_assoc(:article, Map.put(article_params, :subcategory_id, first_subcategory.id))
      |> Repo.insert!
      |> Repo.preload([:category, :subcategory])

    # TODO ch68 revisit preloading in articles
    second_article =
      second_category
      |> Ecto.build_assoc(:article, Map.put(second_article_params, :subcategory_id, second_subcategory.id))
      |> Repo.insert!
      |> Repo.preload([:category, :subcategory])

    content = "Lorem ipsum dolor sit amet"

    conclusion = [
      %{"brand" => "this is brand conclusion 1 " <> content},
      %{"overall" => "this is overall conclusion 2 " <> content},
    ]

    shared_data = %{
      summary: "This is the review summary. " <> content,
      author: "Review Author",
      owning_domain: "10kid",
      main_photo: %{
        "image" => "https://upload.wikimedia.org/wikipedia/commons/1/13/Graphics_card_3.jpg",
        "width" => 2272,
        "height" => 1704
      },
      conclusion: conclusion,
      first_published: first_published,
      last_published: last_published
    }

    first_review =
      first_category
      |> Ecto.build_assoc(:review, Map.put(Map.put(shared_data, :title, "Best Graphics Cards 2017 Buyers Guide and Reviews"), :subcategory_id, first_subcategory.id))
      |> Repo.insert!
      |> Repo.preload([:category, :subcategory])

    second_review =
      second_category
      |> Ecto.build_assoc(:review, Map.put(Map.put(shared_data, :title, "Best Motherboards Feb 2017 Buyers Guide and Reviews"), :subcategory_id, second_subcategory.id))
      |> Repo.insert!
      |> Repo.preload([:category, :subcategory])

    pros = ["a great product with A feature"]
    cons = ["a bad product you shouldn't buy because of F"]
    highlights = ["this is highlight 1 " <> content]

    shared_product_data = %{
      summary: "This is the product summary. " <> content,
      conclusion: "This is the product conclusion. " <> content,
      product_photo: %{
        "image" => "https://c1.staticflickr.com/4/3871/14898396601_c903e4cb7f.jpg",
        "width" => "500",
        "height" => "500"
      },
      pros: pros,
      cons: cons,
      highlights: highlights
    }

    {name, weight, lan_ports, wireless_comm} = {"product name", "5lbs", "6", "x-gb2A"}
    {buttons, user_rating} = {"20", "85"}

    addl_info_a = %{name: name, weight: weight, lan_ports: lan_ports, wireless_comm: wireless_comm}
    addl_info_b = %{name: name, weight: weight, buttons: buttons, user_rating: user_rating}

    Enum.each(1..10, fn(num) ->
      first_review
      |> Ecto.build_assoc(:product, Map.put(Map.put(shared_product_data, :addl_info, addl_info_a), :title, "Product Name " <> to_string(num)))
      |> Repo.insert!
    end)

    Enum.each(1..10, fn(num) ->
      second_review
      |> Ecto.build_assoc(:product, Map.put(Map.put(shared_product_data, :addl_info, addl_info_b), :title, "Product Name " <> to_string(num)))
      |> Repo.insert!
    end)

    first_review = first_review |> Repo.preload(:product)
    second_review = second_review |> Repo.preload(:product)

    test_product = Map.merge(%Product{}, Map.merge(shared_product_data, %{addl_info: addl_info_b, title: "Test Product"}))

    {
      :ok,
      first_article: first_article,
      second_article: second_article,
      first_review: first_review,
      second_review: second_review,
      test_product: test_product,
      first_category: first_category,
      second_category: second_category,
      first_subcategory: first_subcategory,
      second_subcategory: second_subcategory,
    }
  end
end
