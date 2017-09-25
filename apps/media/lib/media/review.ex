defmodule Media.Review do
  use Ecto.Schema
  use Media.Aliases

  @type t :: %Review{
    id: pos_integer,
    title: String.t,
    summary: String.t,
    author: String.t,
    main_photo: Map.t,
    conclusion: list(Map.t),
    category_id: String.t,
    subcategory_id: String.t,
    first_published: Ecto.DateTime.t,
    last_published: Ecto.DateTime.t,
    inserted_at: Ecto.DateTime.t,
    updated_at: Ecto.DateTime.t
  }

  schema "reviews" do
    field :title, :string
    field :summary, :string
    field :author, :string
    field :main_photo, :map
    field :conclusion, {:array, :map}
    field :first_published, :date
    field :last_published, :date
    has_many :product, Product
    belongs_to :category, Category
    belongs_to :subcategory, Subcategory

    timestamps()
  end

  @spec all :: list(Review.t) | nil
  def all do
    Repo.all(Review)
    |> Repo.preload(:product)
  end

  @spec get(String.t) :: {:ok, list(Review.t)} | {:error, :not_found}
  def get(title) do
    case Repo.get_by(Review, %{title: title}) do
      nil -> {:error, :not_found}
      main_review -> {:ok, Repo.preload(main_review, :product)}
    end
  end
end
