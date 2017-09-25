defmodule Media.CategoryTest do
  use Media.Case
  doctest Media

  test "category schema", %{first_category: first_category} do
    first_category
    |> Map.keys
    |> Enum.each(fn(param) -> assert Map.has_key?(%Category{}, param) end)
  end

  test "get all categories", %{first_category: first_category, second_category: second_category} do
    [category1, category2] = Category.all(first_category.owning_domain)

    assert category1 == first_category
    assert category2 == second_category
  end

  test "gets all subcategories in a single category", %{second_category: second_category, second_subcategory: second_subcategory} do
    [subcat] = Category.get_subcategories(second_category.name)
    assert subcat == second_subcategory
  end

  test "get all articles and reviews in a single category", %{second_category: second_category, second_article: second_article, second_review: second_review} do
    [[article], [review]] = Category.get_all(second_category.owning_domain, second_category.name)
    assert article == second_article
    assert review == second_review
  end
end
