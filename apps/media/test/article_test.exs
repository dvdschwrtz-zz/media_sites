defmodule Media.ArticleTest do
  use Media.Case
  doctest Media

  test "article schema", %{first_article: first_article} do
    first_article
    |> Map.keys
    |> Enum.each(fn(param) -> assert Map.has_key?(%Article{}, param) end)
  end

  test "gets a single article", %{first_article: first_article} do
    {:ok, article} = Article.get(first_article.title)
    assert article == first_article
  end

  test "gets all articles", %{first_article: first_article, second_article: second_article} do
    [article1, article2] = Article.all(first_article.owning_domain)
    assert article1 == first_article
    assert article2 == second_article
  end
end
