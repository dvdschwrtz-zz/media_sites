defmodule MediaWeb.ArticleControllerTest do
  use MediaWeb.ConnCase, async: true

  test "gets and shows an article", %{conn: conn, first_article: first_article} do
    {:ok, article} = Article.get(first_article.title)
    conn = get(conn, article_path(@endpoint, :show, article.title))
    assert html_response(conn, 200) =~ ~r/#{article.title}/
  end

  test "renders page not found when article slug is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      conn = get(conn, article_path(@endpoint, :show, "wrong-title"))
      assert html_response(conn, 200) =~ ~r/404 Error: Page not found/
    end
  end
end
