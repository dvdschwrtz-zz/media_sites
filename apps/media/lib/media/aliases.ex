defmodule Media.Aliases do
  defmacro __using__(_) do
    quote do
      alias Media.{
        Article,
        Category,
        Review,
        Product,
        Repo,
        Subcategory
      }
    end
  end
end
