defmodule AmazonProductApi.Result do
  use Ecto.Schema

  import Ecto.Changeset

  alias AmazonProductApi.{Result, Repo}

  @type t :: %Result{
    id: pos_integer,
    category_name: String.t,
    avg_price: float,
    avg_sales_rank: float,
    max_sales_rank: integer,
    trend_score: integer,
    relative_trend_score: integer,
    inserted_at: Ecto.DateTime.t,
    updated_at: Ecto.DateTime.t
  }

  @type result_params :: %{
    category_name: String.t,
    avg_price: float,
    avg_sales_rank: float,
    max_sales_rank: integer,
    trend_score: integer,
    relative_trend_score: integer,
  }

  schema "results" do
    field :category_name, :string
    field :avg_price, :float
    field :avg_sales_rank, :float
    field :max_sales_rank, :integer
    field :trend_score, :integer
    field :relative_trend_score, :integer

    timestamps()
  end

  @spec create(result_params) :: Result.t
  def create(result_params) do
    required_create_params = [:category_name, :avg_price, :avg_sales_rank, :max_sales_rank, :trend_score, :relative_trend_score]

    %Result{}
    |> cast(result_params, required_create_params)
    |> validate_required(required_create_params)
    |> unique_constraint(:category_name)
    |> Repo.insert!
  end

  @spec all :: list(Result.t)
  def all do
    Repo.all(Result)
  end

  @spec delete_all :: {integer, nil | [term]} | no_return
  def delete_all do
    Repo.delete_all(Result)
  end

  @spec results_to_csv(String.t) :: :ok
  def results_to_csv(file_name) do
    file = File.open!("#{file_name}.csv", [:append, :utf8])

    all()
    |> Stream.map(fn(%{
        category_name: name,
        avg_price: price,
        avg_sales_rank: avg_rank,
        max_sales_rank: max_rank,
        trend_score: score,
        relative_trend_score: relative_score,
      }) -> [name, price, avg_rank, max_rank, score, relative_score]
    end)
    |> CSV.encode
    |> Enum.each(&IO.write(file, &1))
  end
end
