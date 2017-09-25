defmodule Media.Category do
  use Ecto.Schema
  use Media.Aliases

  import Ecto.Query, only: [from: 2]

  @type t :: %Category{
    id: pos_integer,
    name: String.t,
    owning_domain: String.t,
    inserted_at: Ecto.DateTime.t,
    updated_at: Ecto.DateTime.t
  }

  schema "categories" do
    field :name, :string
    field :owning_domain, :string
    has_many :article, Article
    has_many :review, Review

    timestamps()
  end

  @spec all(String.t) :: list(Category.t)
  def all(owning_domain) do
    query = from(c in Category,
      where: c.owning_domain == ^owning_domain)
    Repo.all(query)
  end

  @spec get_subcategories(String.t) :: list(String.t)
  def get_subcategories(category) do
    case Repo.get_by(Category, name: category) do
      nil -> {:error, :not_found}
      cat ->
        part_articles =
          cat
          |> Ecto.assoc(:article)
          |> Repo.all

        articles =
          case part_articles do
            [] -> []
            _ ->
              part_articles
              |> Ecto.assoc(:subcategory)
              |> Repo.all
          end

        part_reviews =
          cat
          |> Ecto.assoc(:review)
          |> Repo.all

        reviews =
          case part_reviews do
            [] -> []
            _ ->
              part_reviews
              |> Ecto.assoc(:subcategory)
              |> Repo.all
          end

        Enum.uniq_by(articles ++ reviews, fn(subcat) -> subcat.name end)
    end
  end

  @spec get_all(String.t, String.t) :: list(Article.t | Review.t)
  def get_all(site_env, category) do
    case Repo.get_by(Category, name: category, owning_domain: site_env) do
      nil -> {:error, :not_found}
      cat ->
        articles =
          cat
          |> Ecto.assoc(:article)
          |> Repo.all

        reviews =
          cat
          |> Ecto.assoc(:review)
          |> Repo.all
          |> Repo.preload(:product)

        [articles, reviews]
    end
  end
end
