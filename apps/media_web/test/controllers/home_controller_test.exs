defmodule MediaWeb.HomeControllerTest do
  use MediaWeb.ConnCase, async: true

  test "gets and shows the home title and all the articles and reviews on the site", %{conn: conn, first_article: first_article, second_article: second_article, first_review: first_review, second_review: second_review} do
    conn = get(conn, home_path(@endpoint, :index))

    assert html_response(conn, 200) =~ ~r/home/
    assert html_response(conn, 200) =~ ~r/#{first_article.title}/
    assert html_response(conn, 200) =~ ~r/#{second_article.title}/
    assert html_response(conn, 200) =~ ~r/#{first_review.title}/
    assert html_response(conn, 200) =~ ~r/#{second_review.title}/
  end

  test "has all categories in the navigation bar", %{conn: conn, first_article: first_article, second_article: second_article, first_review: first_review, second_review: second_review} do
    conn = get(conn, home_path(@endpoint, :index))

    assert html_response(conn, 200) =~ ~r/#{first_article.category.name}/
    assert html_response(conn, 200) =~ ~r/#{second_article.category.name}/
    assert html_response(conn, 200) =~ ~r/#{first_review.category.name}/
    assert html_response(conn, 200) =~ ~r/#{second_review.category.name}/
  end
end
