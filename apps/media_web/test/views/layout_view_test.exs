defmodule MediaWeb.LayoutViewTest do
  use MediaWeb.ConnCase, async: true

  test "canonical function", %{conn: conn, first_article: first_article} do
    conn = get(conn, home_path(@endpoint, :index))
    assert  "http://10kid.com/" == MediaWeb.LayoutView.canonical(conn, :amp, first_article.owning_domain)
    assert "http://10kid.com/amp/" == MediaWeb.LayoutView.canonical(conn, :html, first_article.owning_domain)
  end

  test "function to get the main categories in nav menu", %{first_article: first_article, second_article: second_article} do
    assert [first_article.category, second_article.category] == MediaWeb.LayoutView.show_categories(first_article.owning_domain)
  end
end
