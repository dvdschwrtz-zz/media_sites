defmodule Media.Subcategory do
  use Ecto.Schema
  use Media.Aliases

  @type t :: %Subcategory{
    id: pos_integer,
    name: String.t,
    inserted_at: Ecto.DateTime.t,
    updated_at: Ecto.DateTime.t
  }

  schema "subcategories" do
    field :name, :string
    has_many :article, Article
    has_many :review, Review

    timestamps()
  end

  @spec get_all(String.t) :: [list(Article.t) | list(Review.t)]
  def get_all(subcategory) do
    case Repo.get_by(Subcategory, name: subcategory) do
      nil -> {:error, :not_found}
      subcat ->
        articles =
          subcat
          |> Ecto.assoc(:article)
          |> Repo.all

        reviews =
          subcat
          |> Ecto.assoc(:review)
          |> Repo.all
          |> Repo.preload(:product)

        [articles, reviews]
    end
  end
end
