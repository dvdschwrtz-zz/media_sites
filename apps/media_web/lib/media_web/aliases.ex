defmodule MediaWeb.Aliases do
  defmacro __using__(_) do
    quote do
      alias MediaWeb.{
        ErrorView,
        Amp
      }
    end
  end
end
