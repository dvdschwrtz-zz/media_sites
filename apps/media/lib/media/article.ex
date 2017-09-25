defmodule Media.Article do
  use Ecto.Schema
  use Media.Aliases

  import Ecto.Query, only: [from: 2]

  @type t :: %Article{
    id: pos_integer,
    title: String.t,
    owning_domain: String.t,
    summary: String.t,
    main_photo: Map.t,
    sections: list(Map.t),
    tips: list(String.t),
    things_needed: list(String.t),
    warnings: list(String.t),
    resources: list(String.t),
    references: list(String.t),
    author: String.t,
    sections: non_neg_integer,
    category_id: pos_integer,
    subcategory_id: pos_integer,
    first_published: Ecto.DateTime.t,
    last_published: Ecto.DateTime.t,
    inserted_at: Ecto.DateTime.t,
    updated_at: Ecto.DateTime.t
  }

  schema "articles" do
    field :title, :string
    field :summary, :string
    field :owning_domain, :string
    field :main_photo, :map
    field :author, :string
    field :sections, {:array, :map}
    field :tips, {:array, :string}
    field :things_needed, {:array, :string}
    field :warnings, {:array, :string}
    field :resources, {:array, :string}
    field :references, {:array, :string}
    field :first_published, :date
    field :last_published, :date
    belongs_to :category, Category
    belongs_to :subcategory, Subcategory

    timestamps()
  end

  @spec all(String.t) :: list(Article.t)
  def all(owning_domain) do
    query = from(a in Article,
      where: a.owning_domain == ^owning_domain)
    Repo.all(query)
  end

  @spec get(String.t) :: Article.t | nil
  def get(title) do
    case Repo.get_by(Article, %{title: title}) do
      nil -> {:error, :not_found}
      article -> {:ok, article}
    end
  end
end
