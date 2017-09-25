defmodule Media.Repo.Migrations.CreateSubcategory do
  use Ecto.Migration

  def change do
    create table(:subcategories) do
      add :name, :string

      timestamps()
    end
  end
end
