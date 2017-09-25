defmodule AmazonProductApi.BrowseNodeSearch do
  @moduledoc """
  Documentation for AmazonProductApi.
  """

  alias __MODULE__
  alias AmazonProductAdvertisingClient.Config

  # note that all values are passed in at amazon_product_api.ex
  defstruct "Availability": nil,
      "BrowseNode": nil,
      "BrowseNodeId": nil,
      "ItemPage": nil,
      "Keywords": nil,
      "MaximumPrice": nil,
      "MinimumPrice": nil,
      "Operation": nil,
      "ResponseGroup": nil,
      "SearchIndex": nil,
      "Sort": nil,
      "Title": nil


  @doc """
  execute.

  ## Examples

      iex> AmazonProductApi.BrowseNodeSearch.execute
      {:ok, _response}

  """
  def execute(search_params \\ %BrowseNodeSearch{}, config \\ %Config{}) do
    AmazonProductAdvertisingClient.call_api(search_params, config)
  end
end
