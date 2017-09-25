defmodule MediaWeb.ArticleView do
  use MediaWeb.Web, :view

  def format_datetime(%{day: day, month: month, year: year}) do
    "#{format_month(month)} #{day}, #{year}"
  end

  defp format_month(1), do: "January"
  defp format_month(2), do: "February"
  defp format_month(3), do: "March"
  defp format_month(4), do: "April"
  defp format_month(5), do: "May"
  defp format_month(6), do: "June"
  defp format_month(7), do: "July"
  defp format_month(8), do: "August"
  defp format_month(9), do: "September"
  defp format_month(10), do: "October"
  defp format_month(11), do: "November"
  defp format_month(12), do: "December"
end
