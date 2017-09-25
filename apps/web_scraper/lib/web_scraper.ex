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
