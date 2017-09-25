defmodule ArticleSampleData do
  use Media.Aliases

  def create_categories(category) do
    Repo.insert!(%Category{name: category})
  end

  def create_subcategories(subcategory) do
    Repo.insert!(%Subcategory{name: subcategory})
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

ArticleSampleData.clear()

content = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor."

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

{tips, things_needed, warnings, references, resources, first_published, last_published} = {[], [], [], [], [], ~D[2010-10-31], ~D[2016-10-31]}

shared_data = %{
  summary: "This is the summary. " <> content,
  sections: sections,
  owning_domain: System.get_env("MEDIA_ENV"),
  main_photo: %{
    url: "/images/img-md.jpeg",
    height: 300,
    width: 500,
    'hd-url': "/images/img-large.jpeg",
    'hd-height': 600,
    'hd-width': 1000,
    'mb-url': "/images/img-sm.jpeg",
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

first_category = ArticleSampleData.create_categories("legal")
second_category = ArticleSampleData.create_categories("advice")

first_subcategory = ArticleSampleData.create_subcategories("legal-sub1")
second_subcategory = ArticleSampleData.create_subcategories("legal-sub2")
third_subcategory = ArticleSampleData.create_subcategories("advice-sub1")

ArticleSampleData.create_article(first_category, first_subcategory, Map.merge(shared_data, %{title: "first article title here", author: "first author"}))
ArticleSampleData.create_article(first_category, second_subcategory, Map.merge(shared_data, %{title: "second article title here", author: "second author"}))
ArticleSampleData.create_article(second_category, third_subcategory, Map.merge(shared_data, %{title: "third article title here", author: "third author"}))
ArticleSampleData.create_article(second_category, third_subcategory, Map.merge(shared_data, %{title: "fourth article title here", author: "fourth author"}))
