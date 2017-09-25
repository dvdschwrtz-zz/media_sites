defmodule Media.SubcategoryTest do
  use Media.Case
  doctest Media

  test "subcategory schema", %{first_subcategory: first_subcategory} do
    first_subcategory
    |> Map.keys
    |> Enum.each(fn(param) -> assert Map.has_key?(%Subcategory{}, param) end)
  end

  test "get all articles and reviews in a single subcategory", %{second_subcategory: second_subcategory, second_article: second_article, second_review: second_review} do
    [[article], [review]] = Subcategory.get_all(second_subcategory.name)
    assert article == second_article
    assert review == second_review
  end
end
