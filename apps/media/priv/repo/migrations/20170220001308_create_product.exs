defmodule Media.Repo.Migrations.CreateProduct do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :title, :string
      add :summary, :text
      add :product_photo, :map
      add :highlights, {:array, :text}
      add :pros, {:array, :text}
      add :cons, {:array, :text}
      add :conclusion, :text
      add :addl_info, :map
      add :review_id, references(:reviews)

      timestamps()
    end
  end
end
