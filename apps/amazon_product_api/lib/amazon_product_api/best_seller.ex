defmodule AmazonProductApi.BestSeller do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  alias AmazonProductApi.{BestSeller, Repo, Item}

  @type t :: %BestSeller{
    id: pos_integer,
    category_id: String.t,
    category_name: String.t,
    item_id: String.t,
    item_name: String.t,
    cat_item_id: String.t,
    called: boolean,
    inserted_at: Ecto.DateTime.t,
    updated_at: Ecto.DateTime.t
  }

  @type best_seller_params :: %{
    category_id: String.t,
    category_name: String.t,
    item_id: String.t,
    item_name: String.t,
    cat_item_id: String.t,
    called: boolean,
  }

  schema "best_sellers" do
    field :category_name, :string
    field :category_id, :string
    field :item_name, :string
    field :item_id, :string
    field :cat_item_id, :string
    field :called, :boolean, default: false

    timestamps()
  end

  @spec create(best_seller_params) :: BestSeller.t
  def create(best_seller_params) do
    required_create_params = [:category_name, :category_id, :item_name, :item_id, :cat_item_id, :called]

    %BestSeller{}
    |> cast(best_seller_params, required_create_params)
    |> validate_required(required_create_params)
    |> unique_constraint(:cat_item_id)
    |> Repo.insert!
  end

  @spec all :: list(BestSeller.t)
  def all do
    Repo.all(BestSeller)
  end

  @spec delete_all :: {integer, nil | [term]} | no_return
  def delete_all do
    Repo.delete_all(BestSeller)
  end

  @spec reset_called_to_false_for_all :: {integer, nil | [term]} | no_return
  def reset_called_to_false_for_all do
    Repo.update_all(BestSeller, set: [called: false])
  end

  @spec reset_only_failed_best_sellers :: {integer, nil | [term]} | no_return
  def reset_only_failed_best_sellers do
    query = from b in BestSeller,
      left_join: i in Item,
      on: i.item_id == b.item_id,
      where: is_nil(i.item_id)

    Enum.each(Repo.all(query), fn(%{item_id: failed_id}) ->
      Repo.update_all(from(listing in BestSeller, where: listing.item_id == ^failed_id), set: [called: false])
    end)
  end
end
