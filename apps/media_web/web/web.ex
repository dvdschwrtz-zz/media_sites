defmodule MediaWeb.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use MediaWeb.Web, :controller
      use MediaWeb.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def model do
    quote do
      # Define common model functionality
    end
  end

  def controller do
    quote do
      use Phoenix.Controller
      use MediaWeb.Aliases
      use Media.Aliases

      import MediaWeb.Router.Helpers
      import MediaWeb.Gettext
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "web/templates"

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML
      use Media.Aliases
      use MediaWeb.Aliases

      import MediaWeb.Router.Helpers
      import MediaWeb.ErrorHelpers
      import MediaWeb.Gettext

      @spec check_list(List.t | Review.t | Article.t) :: List.t
      def check_list(variable) do
        case is_list(variable) do
          false -> [variable]
          true -> variable
        end
      end
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import MediaWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
