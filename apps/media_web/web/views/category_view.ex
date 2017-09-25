defmodule MediaWeb.CategoryView do
  use MediaWeb.Web, :view

  @spec show_subcategories(String.t) :: list(String.t)
  def show_subcategories(category) do
    case Category.get_subcategories(category) do
      {:error, :not_found} -> nil
      subcategories -> subcategories
    end
  end
end
