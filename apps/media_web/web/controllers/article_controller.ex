defmodule MediaWeb.ArticleController do
  use MediaWeb.Web, :controller
  alias MediaWeb.ErrorView

  def show(conn, %{"slug" => title}) do
    case Article.get(title) do
      {:ok, article} ->
        sidebar_articles = Article.all(article.owning_domain) |> Enum.slice(0..4)
        render(conn, "show.html", article: article, articles: sidebar_articles)
      {:error, :not_found} -> conn |> put_status(:not_found) |> render(ErrorView, "404.html")
    end
  end
end
