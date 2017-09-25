defmodule AmazonProductApi.Repo.Migrations.AddItem do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :category_name, :string
      add :category_id, :string
      add :item_name, :string
      add :item_id, :string
      add :lowest_price, :float
      add :cat_item_id, :string
      add :sales_rank, :integer
      add :scraped, :boolean

      timestamps()
    end

    create unique_index(:items, [:cat_item_id])
  end
end
