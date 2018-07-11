defmodule MyApp.Unit.Worker do
  @moduledoc false

  use GenServer

  def start_link(arg) do
    name = {:via, Registry, {MyApp.Registry, {:unit, arg.name, arg.worker_name}}}
    GenServer.start_link(__MODULE__, arg, [name: name])
  end

  def init(arg) do
    {:ok, arg}
  end

  def handle_cast(:do_work, state) do
    IO.puts "#{state.name}/#{inspect(state.worker_name)} got work to do"

    case get_service_pid(state.name) do
      {:ok, pid} -> GenServer.cast(pid, {:result, {state.worker_name, "I don't really wanna do the work today!"}})
      {:error, :not_found} -> IO.puts "#{state.name}: Could not find service process"
    end

    {:noreply, state}
  end

  def get_service_pid(name) do
    case Registry.lookup(MyApp.Registry, {:unit, name, :service}) do
      [{pid, _}] -> {:ok, pid}
      _ -> {:error, :not_found}
    end
  end
end
