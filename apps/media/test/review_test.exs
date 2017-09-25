defmodule Media.ReviewTest do
  use Media.Case
  doctest Media

  test "review schema", %{first_review: first_review} do
    first_review
    |> Map.keys
    |> Enum.each(fn(param) -> assert Map.has_key?(%Review{}, param) end)
  end

  test "gets a single review", %{first_review: first_review} do
    {:ok, review} = Review.get(first_review.title)
    assert review == first_review
  end

  test "gets all reviews", %{first_review: first_review, second_review: second_review} do
    [review1, review2] = Review.all()
    assert review1 == first_review
    assert review2 == second_review
  end
end
