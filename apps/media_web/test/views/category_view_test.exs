defmodule MediaWeb.CategoryViewTest do
  use MediaWeb.ConnCase, async: true

  test "function to get the subcategories in nav menu", %{first_article: first_article, second_article: second_article} do
    assert [first_article.subcategory] == MediaWeb.CategoryView.show_subcategories(first_article.category.name)
    assert [second_article.subcategory] == MediaWeb.CategoryView.show_subcategories(second_article.category.name)
  end

  test "check_list function is working", %{} do
    assert ["test"] == MediaWeb.CategoryView.check_list("test")
    assert ["test"] == MediaWeb.CategoryView.check_list(["test"])
  end
end
