defmodule MediaWeb.SubcategoryControllerTest do
  use MediaWeb.ConnCase, async: true

  test "gets and shows articles related to a subcategory", %{conn: conn, second_article: second_article} do
    conn = get(conn, subcategory_path(@endpoint, :show, second_article.subcategory.name))
    assert html_response(conn, 200) =~ ~r/#{second_article.title}/
  end

  test "shows a 404 page when a user enters a nonexistent subcategory", %{conn: conn} do
    assert_error_sent 404, fn ->
      conn = get(conn, subcategory_path(@endpoint, :show, "wrong-subcategory"))
      assert html_response(conn, 200) =~ ~r/404 Error: Page not found/
    end
  end
end
