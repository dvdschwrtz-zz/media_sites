defmodule MediaWeb.LayoutView do
  use MediaWeb.Web, :view

  def canonical(conn, page_type, site_env) do
    case page_type do
      :amp -> "http://" <> site_env <> ".com" <> conn.request_path
      :html -> "http://" <> site_env <> ".com/amp" <> conn.request_path
    end
  end

  @spec show_categories(String.t) :: list(Category.t)
  def show_categories(site_env) do
    Category.all(site_env)
  end
end
