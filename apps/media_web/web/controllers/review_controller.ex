defmodule MediaWeb.ReviewController do
  use MediaWeb.Web, :controller
  alias MediaWeb.ErrorView

  def show(conn, %{"slug" => title}) do
    case Review.get(title) do
      {:ok, review} -> render(conn, "show.html", review: review, article: nil)
      {:error, :not_found} -> conn |> put_status(:not_found) |> render(ErrorView, "404.html")
    end
  end
end
