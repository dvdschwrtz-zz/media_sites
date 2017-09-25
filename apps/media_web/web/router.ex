defmodule MediaWeb.Router do
  use MediaWeb.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :assign_site_env
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :amp_pipeline do
    plug :assign_page_type, :amp
    plug :put_layout, {MediaWeb.LayoutView, :amp}
  end

  pipeline :html_pipeline do
    plug :assign_page_type, :html
  end

  def assign_page_type(conn, type) do
    Plug.Conn.assign(conn, :page_type, type)
  end

  def assign_site_env(conn = %{host: host}, _) do
     cond do
       String.contains?(host, "10kid.com") ->
         Plug.Conn.assign(conn, :ga_account, "UA-97114500-2")
         |> Plug.Conn.assign(:site_env, "10kid")
       String.contains?(host, "10devices.com") ->
         Plug.Conn.assign(conn, :ga_account, "UA-97114500-1")
         |> Plug.Conn.assign(:site_env, "10devices")
       String.contains?(host, "10loans.com") -> Plug.Conn.assign(conn, :site_env, "10loans")
       String.contains?(host, "10insure.com") -> Plug.Conn.assign(conn, :site_env, "10insure")
       String.contains?(host, "capitalgal.com") -> Plug.Conn.assign(conn, :site_env, "capitalgal")
       String.contains?(host, "jobiato.com") -> Plug.Conn.assign(conn, :site_env, "jobiato")
       String.contains?(host, "nonville.com") -> Plug.Conn.assign(conn, :site_env, "nonville")
       String.contains?(host, "dapend.com") -> Plug.Conn.assign(conn, :site_env, "dapend")
       String.contains?(host, "chesture.com") -> Plug.Conn.assign(conn, :site_env, "chesture")
       String.contains?(host, "thelegalspot.com") -> Plug.Conn.assign(conn, :site_env, "thelegalspot")
       Application.get_env(:media_web, :env) == :dev ->
         Plug.Conn.assign(conn, :ga_account, "UA-97114500-1")
         |> Plug.Conn.assign(:site_env, "#{System.get_env("MEDIA_ENV")}")
       true ->
         Plug.Conn.assign(conn, :ga_account, "UA-97114500-1")
         |> Plug.Conn.assign(:site_env, "10devices")
     end
  end

  scope "/", MediaWeb do
    pipe_through [:browser, :html_pipeline]

    get "/", HomeController, :index
    get "/categories/subcategories/:subcat", SubcategoryController, :show
    get "/categories/:cat", CategoryController, :show
    get "/articles/:slug", ArticleController, :show
    get "/reviews/:slug", ReviewController, :show

    # health check
    get "/healthz", HealthZController, :healthz
  end

  scope "/amp", MediaWeb do
    pipe_through [:browser, :amp_pipeline]

    get "/", HomeController, :index
    get "/categories/subcategories/:subcat", SubcategoryController, :show
    get "/categories/:cat", CategoryController, :show
    get "/articles/:slug", ArticleController, :show
    get "/reviews/:slug", ReviewController, :show
  end
end
