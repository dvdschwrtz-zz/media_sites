# TODO how to run the article seed and review seed file from here with one line each maybe?
defmodule SampleData do
  use Media.Aliases

  def create_categories(category) do
    Repo.insert!(%Category{name: category})
  end

  def create_subcategories(subcategory) do
    Repo.insert!(%Subcategory{name: subcategory})
  end

  def create_review(category, subcategory, params) do
    category
    |> Ecto.build_assoc(:review, Map.put(params, :subcategory_id, subcategory.id))
    |> Repo.insert!
  end

  def create_products(review, product) do
    Enum.each(1..10, fn(num) ->
      review
      |> Ecto.build_assoc(:product, Map.put(product, :title, "Product Name " <> to_string(num)))
      |> Repo.insert!
    end)
  end

  def create_article(category, subcategory, params) do
    category
    |> Ecto.build_assoc(:article, Map.put(params, :subcategory_id, subcategory.id))
    |> Repo.insert!
  end

  def clear() do
    Repo.delete_all(Product)
    Repo.delete_all(Review)
    Repo.delete_all(Article)
    Repo.delete_all(Category)
    Repo.delete_all(Subcategory)
  end
end

SampleData.clear()

first_category = SampleData.create_categories("Wearable Tech")
second_category = SampleData.create_categories("Family")

first_subcategory = SampleData.create_subcategories("Living Room")
second_subcategory = SampleData.create_subcategories("Wearables")
third_subcategory = SampleData.create_subcategories("Kids Products")

content = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor."

conclusion = [
  %{"brand" => "this is brand conclusion 1 " <> content},
  %{"overall" => "this is overall conclusion 2 " <> content}
]

{first_published, last_published} = {~D[2010-10-31], ~D[2016-10-31]}

shared_data = %{
  summary: "This is the summary. " <> content,
  conclusion: conclusion,
  main_photo: %{
    url: "http://www.graphicscardguy.com/wp-content/uploads/2016/11/86ae6be7ee05.jpg",
    height: 300,
    width: 500,
    'hd-url': "http://www.fudzilla.com/images/stories/2015/July/powercolor-devilr9390X-1.jpg",
    'hd-height': 600,
    'hd-width': 1000,
    'mb-url': "http://futuristicpc.com/wp-content/uploads/2017/01/51MGDnaO8SL-250x150.jpg",
    'mb-height': 150,
    'mb-width': 250,
    alt: "this is the alt text for the image"
  },
  first_published: first_published,
  last_published: last_published
}

first_review = SampleData.create_review(first_category, first_subcategory, Map.put(shared_data, :title, "Best Graphics Cards [2017] - Buyer's Guide and Reviews"))
second_review = SampleData.create_review(first_category, second_subcategory, Map.put(shared_data, :title, "Best Motherboards (Feb. 2017) - Buyer's Guide and Reviews"))
third_review = SampleData.create_review(second_category, third_subcategory, Map.put(shared_data, :title, "Best Car Seats [2017] - Buyer's Guide and Reviews"))

pros = [
  "a great product with A feature",
  "a great product with B feature",
  "a great product with C feature",
  "a great product with D feature",
  "a great product with E feature",
]
cons = [
  "a bad product you shouldn't buy because of F",
  "a bad product you shouldn't buy because of G",
  "a bad product you shouldn't buy because of H",
  "a bad product you shouldn't buy because of I",
]

highlights = [
  "this is highlight 1 " <> content,
  "this is highlight 2 " <> content,
]

shared_product_data = %{
  summary: "This is the product summary. " <> content,
  conclusion: "This is the product conclusion. " <> content,
  product_photo: %{
    url: "http://www.graphicscardguy.com/wp-content/uploads/2016/11/86ae6be7ee05.jpg",
    height: 300,
    width: 500,
    'hd-url': "http://www.fudzilla.com/images/stories/2015/July/powercolor-devilr9390X-1.jpg",
    'hd-height': 600,
    'hd-width': 1000,
    'mb-url': "http://futuristicpc.com/wp-content/uploads/2017/01/51MGDnaO8SL-250x150.jpg",
    'mb-height': 150,
    'mb-width': 250,
    alt: "this is the alt text for the image"
  },
  pros: pros,
  cons: cons,
  highlights: highlights,
  first_published: first_published,
  last_published: last_published
}

{name, weight, lan_ports, wireless_comm} = {"product name", "5lbs", "6", "x-gb2A"}
{buttons, user_rating} = {"20", "85"}
{quality_a, quality_b, quality_c} = {"a", "b", "c"}

addl_info_a = %{name: name, weight: weight, lan_ports: lan_ports, wireless_comm: wireless_comm}
addl_info_b = %{name: name, weight: weight, buttons: buttons, user_rating: user_rating}
addl_info_c = %{name: name, quality_a: quality_a, quality_b: quality_b, quality_c: quality_c}

SampleData.create_products(first_review, Map.put(shared_product_data, :addl_info, addl_info_a))
SampleData.create_products(second_review, Map.put(shared_product_data, :addl_info, addl_info_b))
SampleData.create_products(third_review, Map.put(shared_product_data, :addl_info, addl_info_c))

sections = [
  %{
    title: "I am an in-Article Title",
    content: content
  },
  %{
    title: "I am an in-Article Title 2",
    content: content,
  },
  %{
    title: "I am an in-Article Title 3",
    content: content,
  },
  %{
    title: "I am an in-Article Title 4",
    content: content,
  },
]

{tips, things_needed, warnings, references, resources} = {["stay healthy","be happy"], ["briefcase","laptop"], ["apple","day"], [], []}

shared_data = %{
  summary: "This is the summary. " <> content,
  sections: sections,
  owning_domain: "localhost",
  main_photo: %{
    url: "http://www.graphicscardguy.com/wp-content/uploads/2016/11/86ae6be7ee05.jpg",
    height: 300,
    width: 500,
    'hd-url': "http://www.fudzilla.com/images/stories/2015/July/powercolor-devilr9390X-1.jpg",
    'hd-height': 600,
    'hd-width': 1000,
    'mb-url': "http://futuristicpc.com/wp-content/uploads/2017/01/51MGDnaO8SL-250x150.jpg",
    'mb-height': 150,
    'mb-width': 250,
    alt: "this is the alt text for the image"
  },
  tips: tips,
  things_needed: things_needed,
  warnings: warnings,
  resources: resources,
  references: references,
  first_published: first_published,
  last_published: last_published
}

SampleData.create_article(first_category, first_subcategory, Map.merge(shared_data, %{title: "first article on something tech"}))
SampleData.create_article(first_category, second_subcategory, Map.merge(shared_data, %{title: "second article on something else tech"}))
SampleData.create_article(second_category, third_subcategory, Map.merge(shared_data, %{title: "another tech related article here"}))
