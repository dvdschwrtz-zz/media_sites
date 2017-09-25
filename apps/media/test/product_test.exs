defmodule Media.ProductTest do
  use Media.Case
  doctest Media

  test "product schema", %{test_product: test_product} do
    test_product
    |> Map.keys
    |> Enum.each(fn(param) -> assert Map.has_key?(%Product{}, param) end)
  end
end
