defmodule MediaWeb.ReviewControllerTest do
  use MediaWeb.ConnCase, async: true

  test "gets and shows a review", %{conn: conn, first_review: first_review} do
    {:ok, review} = Review.get(first_review.title)
    conn = get(conn, review_path(@endpoint, :show, review.title))
    assert html_response(conn, 200) =~ ~r/#{review.title}/
  end

  test "renders page not found when review slug is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      conn = get(conn, review_path(@endpoint, :show, "wrong-title"))
      assert html_response(conn, 200) =~ ~r/404 Error: Page not found/
    end
  end
end
