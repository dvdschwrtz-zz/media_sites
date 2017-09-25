defmodule AmazonProductApi.Repo.Migrations.AddResult do
  use Ecto.Migration

  def change do
    create table(:results) do
      add :category_name, :string
      add :avg_price, :float
      add :avg_sales_rank, :float
      add :max_sales_rank, :integer
      add :trend_score, :integer
      add :relative_trend_score, :integer

      timestamps()
    end

    create unique_index(:results, [:category_name])
  end
end
