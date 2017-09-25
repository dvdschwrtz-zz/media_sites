defmodule Media.Product do
  use Ecto.Schema
  use Media.Aliases

  @type t :: %Product{
    id: pos_integer,
    title: String.t,
    summary: String.t,
    review_id: pos_integer,
    product_photo: Map.t,
    highlights: list(String.t),
    pros: list(String.t),
    cons: list(String.t),
    conclusion: String.t,
    addl_info: Map.t,
    inserted_at: Ecto.DateTime.t,
    updated_at: Ecto.DateTime.t
  }

  schema "products" do
    field :title, :string
    field :summary, :string
    field :product_photo, :map
    field :highlights, {:array, :string}
    field :pros, {:array, :string}
    field :cons, {:array, :string}
    field :conclusion, :string
    field :addl_info, :map
    belongs_to :review, Review

    timestamps()
  end
end
