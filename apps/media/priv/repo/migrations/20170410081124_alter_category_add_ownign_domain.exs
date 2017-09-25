defmodule Media.Repo.Migrations.AlterCategoryAddOwningDomain do
  use Ecto.Migration

  def change do
    alter table(:categories) do
      add :owning_domain, :string
    end
  end
end
