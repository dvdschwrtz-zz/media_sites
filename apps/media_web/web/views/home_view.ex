defmodule MediaWeb.HomeView do
  use MediaWeb.Web, :view

  @spec show_categories(String.t) :: list(Category.t)
  def show_categories(site_env) do
    Category.all(site_env)
  end
end
