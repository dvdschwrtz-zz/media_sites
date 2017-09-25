defmodule Media.Repo.Migrations.AlterArticleAddOwningDomain do
  use Ecto.Migration

  def change do
    alter table(:articles) do
      add :owning_domain, :string
    end
  end
end
