defmodule AmazonProductApi.Category do
  use Ecto.Schema

  import Ecto.Changeset

  alias AmazonProductApi.{Category, Repo}

  @type t :: %Category{
    id: pos_integer,
    category_id: String.t,
    category_name: String.t,
    called: boolean,
    inserted_at: Ecto.DateTime.t,
    updated_at: Ecto.DateTime.t
  }

  @type category_params :: %{
    category_id: String.t,
    category_name: String.t,
    called: boolean,
  }

  schema "categories" do
    field :category_name, :string
    field :category_id, :string
    field :called, :boolean, default: false

    timestamps()
  end

  @spec create(category_params) :: Category.t
  def create(category_params) do
    required_create_params = [:category_name, :category_id, :called]

    %Category{}
    |> cast(category_params, required_create_params)
    |> validate_required(required_create_params)
    |> unique_constraint(:category_id)
    |> Repo.insert
  end

  @spec all :: list(Category.t)
  def all do
    Repo.all(Category)
  end

  @spec delete_all :: {integer, nil | [term]} | no_return
  def delete_all do
    Repo.delete_all(Category)
  end

  @spec reset_called_to_false_all :: {integer, nil | [term]} | no_return
  def reset_called_to_false_all do
    Repo.update_all(Category, set: [called: false])
  end

  @spec reset_called_to_false_one(String.t) :: Category.t
  def reset_called_to_false_one(category_id) do
    Repo.get_by(Category, category_id: category_id)
    |> change(called: false)
    |> Repo.update
  end
end
