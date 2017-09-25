defmodule AmazonProductApi.Repo.Migrations.AddBestSeller do
  use Ecto.Migration

  def change do
    create table(:best_sellers) do
      add :category_name, :string
      add :category_id, :string
      add :item_name, :string
      add :item_id, :string
      add :cat_item_id, :string
      add :called, :boolean

      timestamps()
    end

    create unique_index(:best_sellers, [:cat_item_id])
  end
end
