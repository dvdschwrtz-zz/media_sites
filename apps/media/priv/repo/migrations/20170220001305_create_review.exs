defmodule Media.Repo.Migrations.CreateReview do
  use Ecto.Migration

  def change do
    create table(:reviews) do
      add :title, :string
      add :author, :string
      add :summary, :text
      add :main_photo, :map
      add :conclusion, {:array, :map}
      add :first_published, :date
      add :last_published, :date
      add :category_id, references(:categories)
      add :subcategory_id, references(:subcategories)

      timestamps()
    end
  end
end
