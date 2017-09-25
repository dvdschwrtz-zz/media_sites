defmodule MediaWeb.HomeController do
  use MediaWeb.Web, :controller

  def index(%{assigns: %{site_env: site_env}} = conn, _params) do
    results = [Article.all(site_env), Review.all()]
    case results do
      [articles, reviews] -> render(conn, "index.html", reviews: reviews, articles: articles)
    end
  end
end
