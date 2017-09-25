defmodule Media.Repo.Migrations.CreateArticle do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :title, :string
      add :category_id, references(:categories)
      add :subcategory_id, references(:subcategories)
      add :author, :string
      add :summary, :text
      add :main_photo, :map
      add :sections, {:array, :map}
      add :tips, {:array, :string}
      add :things_needed, {:array, :string}
      add :warnings, {:array, :string}
      add :resources, {:array, :string}
      add :references, {:array, :string}
      add :first_published, :date
      add :last_published, :date

      timestamps()
    end
  end
end
