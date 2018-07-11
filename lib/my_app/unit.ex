defmodule MyApp.Unit do
  @moduledoc false

  use Supervisor

  alias MyApp.Unit.Service
  alias MyApp.Unit.Worker

  def start_link(arg) do
    name = {:via, Registry, {MyApp.Registry, {:unit, arg}}}
    Supervisor.start_link(__MODULE__, arg, name: name)
  end

  def init(arg) do
    children = [
       {Service, arg},
        Supervisor.child_spec({Worker, %{name: arg, worker_name: :worker_one}}, id: {Worker, 1}),
        Supervisor.child_spec({Worker, %{name: arg, worker_name: :worker_two}}, id: {Worker, 2}),
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
