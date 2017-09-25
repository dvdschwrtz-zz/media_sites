defmodule MediaWeb.CategoryController do
  use MediaWeb.Web, :controller
  alias MediaWeb.ErrorView

  def show(%{assigns: %{site_env: site_env}} = conn, %{"cat" => category}) do
    case Category.get_all(site_env, category) do
      {:error, :not_found} -> conn |> put_status(:not_found) |> render(ErrorView, "404.html")
      [articles, reviews] -> render(conn, "show.html", articles: articles, reviews: reviews, category: category)
    end
  end
end
