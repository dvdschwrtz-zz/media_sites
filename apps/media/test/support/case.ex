defmodule Media.Case do
  use ExUnit.CaseTemplate
  use Media.Aliases

  using(opts) do
    quote do
      use ExUnit.Case, unquote(opts)
      use Media.Aliases
    end
  end

  setup tags do
    unless tags[:async] do
      :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    end
  end

  setup do

    cat_params = ["advice", "careers"]
    subcat_params = ["sub-advice", "sub-careers"]

    first_category = Repo.insert!(%Category{owning_domain: "localhost", name: Enum.at(cat_params, 0)})
    second_category = Repo.insert!(%Category{owning_domain: "localhost", name: Enum.at(cat_params, 1)})

    first_subcategory = Repo.insert!(%Subcategory{name: Enum.at(subcat_params, 0)})
    second_subcategory = Repo.insert!(%Subcategory{name: Enum.at(subcat_params, 1)})

    article_params = %{
      summary: "This is the summary",
      author: "Author 1",
      owning_domain: "localhost",
      main_photo: %{
        "image" => "https://upload.wikimedia.org/wikipedia/commons/1/13/Graphics_card_3.jpg",
        "width" => 2272,
        "height" => 1704
      },
      sections: [],
      tips: ["stay healthy","be happy"],
      things_needed: ["briefcase","laptop"],
      warnings: ["apple","day"],
      resources: [],
      references: [],
      title: "testing",
    }

    second_article_params = %{
      summary: article_params.summary <> "2",
      owning_domain: article_params.owning_domain,
      author: "Author 2",
      main_photo: article_params.main_photo,
      sections: [],
      tips: [Enum.at(article_params.tips, 0) <> "2", Enum.at(article_params.tips, 1) <> "2"],
      things_needed: [Enum.at(article_params.things_needed, 0) <> "2", Enum.at(article_params.things_needed, 1) <> "2"],
      warnings: [Enum.at(article_params.warnings, 0) <> "2", Enum.at(article_params.warnings, 1) <> "2"],
      resources: [],
      references: [],
      title: article_params.title <> "2",
    }

    first_article =
      first_category
      |> Ecto.build_assoc(:article, Map.put(article_params, :subcategory_id, first_subcategory.id))
      |> Repo.insert!

    second_article =
      second_category
      |> Ecto.build_assoc(:article, Map.put(second_article_params, :subcategory_id, second_subcategory.id))
      |> Repo.insert!

    content = "Lorem ipsum dolor sit amet"

    conclusion = [
      %{"brand" => "this is brand conclusion 1 " <> content},
      %{"overall" => "this is overall conclusion 2 " <> content},
    ]

    {first_published, last_published} = {~D[2010-10-31], ~D[2016-10-31]}

    shared_data = %{
      summary: "This is the review summary. " <> content,
      author: "Review Author",
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
      |> Ecto.build_assoc(:review, Map.put(Map.put(shared_data, :title, "Best Graphics Cards [2017] - Buyer's Guide and Reviews"), :subcategory_id, first_subcategory.id))
      |> Repo.insert!

    second_review =
      second_category
      |> Ecto.build_assoc(:review, Map.put(Map.put(shared_data, :title, "Best Motherboards (Fed. 2017) - Buyer's Guide and Reviews"), :subcategory_id, second_subcategory.id))
      |> Repo.insert!

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
