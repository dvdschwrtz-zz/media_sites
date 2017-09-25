defmodule MediaWeb.HealthZController do
  use MediaWeb.Web, :controller

  def healthz(conn, _params), do: text(conn, "ok")
end
