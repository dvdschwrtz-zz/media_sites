defmodule MediaWeb.CategoryControllerTest do
  use MediaWeb.ConnCase, async: true

  test "gets and shows a list of all categories", %{first_article: first_article, second_article: second_article} do
    category_list = Category.all(first_article.owning_domain)

    assert length(category_list) == 2
    assert Enum.member?(category_list, first_article.category)
    assert Enum.member?(category_list, second_article.category)
  end

  test "gets and shows articles related to a category", %{conn: conn, first_article: first_article} do
    conn = get(conn, category_path(@endpoint, :show, first_article.category.name))
    assert html_response(conn, 200) =~ ~r/#{first_article.title}/
  end

  test "shows a 404 page when a user enters a nonexistent category", %{conn: conn} do
    assert_error_sent 404, fn ->
      conn = get(conn, category_path(@endpoint, :show, "wrong-category"))
      assert html_response(conn, 200) =~ ~r/404 Error: Page not found/
    end
  end
end
