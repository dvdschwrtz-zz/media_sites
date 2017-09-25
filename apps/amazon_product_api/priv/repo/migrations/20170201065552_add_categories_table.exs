defmodule AmazonProductApi.Repo.Migrations.AddCategory do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :category_name, :string
      add :category_id, :string
      add :called, :boolean, default: false

      timestamps()
    end

    create unique_index(:categories, [:category_id])
  end
end
