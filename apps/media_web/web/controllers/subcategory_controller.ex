defmodule MediaWeb.SubcategoryController do
  use MediaWeb.Web, :controller
  alias MediaWeb.ErrorView

  def show(conn, %{"subcat" => subcategory}) do
    case Subcategory.get_all(subcategory) do
      {:error, :not_found} -> conn |> put_status(:not_found) |> render(ErrorView, "404.html")
      [articles, reviews] -> render(conn, "show.html", articles: articles, reviews: reviews, category: subcategory)
    end
  end
end
