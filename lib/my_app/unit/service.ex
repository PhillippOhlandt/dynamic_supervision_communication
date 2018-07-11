defmodule MyApp.Unit.Service do
  @moduledoc false

  use GenServer

  def start_link(arg) do
    name = {:via, Registry, {MyApp.Registry, {:unit, arg, :service}}}
    GenServer.start_link(__MODULE__, arg, [name: name])
  end

  def init(arg) do
    state = %{
      name: arg,
      results: %{
        worker_one: [],
        worker_two: []
      }
    }

    Process.send_after(self(), :push_work, 10_000)

    {:ok, state}
  end

  def handle_info(:push_work, state) do
    selected =
      [:worker_one, :worker_two]
      |> Enum.random()

    case get_worker_pid(state.name, selected) do
      {:ok, pid} -> GenServer.cast(pid, :do_work)
      {:error, :not_found} -> IO.puts "#{state.name}: Could not find worker process #{inspect(selected)}"
    end

    Process.send_after(self(), :push_work, 10_000)

    {:noreply, state}
  end

  def handle_cast({:result, {worker, result}}, state) do

    IO.puts "#{state.name}: Message from #{inspect(worker)}: #{result}"

    {:noreply, state}
  end

  def get_worker_pid(name, worker_name) do
    case Registry.lookup(MyApp.Registry, {:unit, name, worker_name}) do
      [{pid, _}] -> {:ok, pid}
      _ -> {:error, :not_found}
    end
  end
end
