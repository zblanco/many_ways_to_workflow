defmodule OpOtp.Application do
  @moduledoc false
  use Application
  alias OpOtp.Runtime.PermitSupervisor

  def start(_type, _args) do
    children = [
      {Phoenix.PubSub.PG2, [name: OpOtp.PubSub, adapter: Phoenix.PubSub.PG2]},
      {Registry, name: OpOtp.WorkflowRegistry, keys: :unique},
      {PermitSupervisor, []},
    ]

    opts = [strategy: :one_for_one, name: OpOtp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
