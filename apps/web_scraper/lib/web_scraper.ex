defmodule WebScraper do
  @moduledoc """
  Documentation for WebScraper.
  """

  use Hound.Helpers

  @spec get_keyword_score(String.t, String.t, integer) :: integer
  def get_keyword_score(keyword, relative_word, call \\ 0) do
    Hound.start_session

    IO.puts("keywords")
    IO.inspect(keyword)
    IO.inspect(relative_word)
    no_comma_relative_word = String.replace(relative_word, ",", "")
    no_comma_keyword = String.replace(keyword, ",", "")

    navigate_to("https://www.google.com/trends/explore?geo=US&q=#{URI.encode(no_comma_keyword)},#{URI.encode(no_comma_relative_word)}")

    Hound.Helpers.Window.current_window_handle
    |> Hound.Helpers.Window.maximize_window

    :timer.sleep(7000)

    case Floki.find(page_source(), ".bar-chart-content tbody td") do
      [] -> if (call < 1), do: get_keyword_score(keyword, relative_word, call+1), else: -1
      [{"td", [], ["Average"]}, {"td", [], [score]}, {"td", [], [_]}] ->
        IO.puts("score")
        IO.inspect(score)
        String.to_integer(score)
    end
  end
end

# [error] Task #PID<0.362.0> started from #PID<0.356.0> terminating
# ** (ArgumentError) Postgrex expected an integer in -2147483648..2147483647, got 2672.0. Please make sure the value you are passing matches the definition in your table or in your query or convert the value accordingly.
#     (ecto) /Users/davidschwartz/dev/black_tiger/deps/postgrex/lib/postgrex/type_module.ex:716: Ecto.Adapters.Postgres.TypeModule.encode_params/3
#     (postgrex) lib/postgrex/query.ex:45: DBConnection.Query.Postgrex.Query.encode/3
#     (db_connection) lib/db_connection.ex:1070: DBConnection.describe_run/5
#     (db_connection) lib/db_connection.ex:1141: anonymous fn/4 in DBConnection.run_meter/5
#     (db_connection) lib/db_connection.ex:1198: DBConnection.run_begin/3
#     (db_connection) lib/db_connection.ex:584: DBConnection.prepare_execute/4
#     (ecto) lib/ecto/adapters/postgres/connection.ex:93: Ecto.Adapters.Postgres.Connection.execute/4
#     (ecto) lib/ecto/adapters/sql.ex:243: Ecto.Adapters.SQL.sql_call/6
# Function: #Function<4.58330402/0 in AmazonProductApi.Item.scrape_all_items/1>
#     Args: []
