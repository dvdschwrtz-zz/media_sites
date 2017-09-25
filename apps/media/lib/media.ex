defmodule Media do
  @moduledoc false

  use Application
  use Media.Aliases

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: Media.Worker.start_link(arg1, arg2, arg3)
      # worker(Media.Worker, [arg1, arg2, arg3]),
      worker(Repo, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Media.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
