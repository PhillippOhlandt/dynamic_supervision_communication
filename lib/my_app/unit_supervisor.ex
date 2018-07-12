defmodule MyApp.UnitSupervisor do
  @moduledoc false

  use DynamicSupervisor

  alias MyApp.Unit

  def start_link(arg) do
    DynamicSupervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def add_unit(name) do
    DynamicSupervisor.start_child(__MODULE__, {Unit, name})
  end

  def list_units() do
    info =
      DynamicSupervisor.which_children(__MODULE__)
      |> Enum.map(fn {_, pid, _, _} -> pid end)
      |> Enum.map(&to_unit_info/1)

    {:ok, info}
  end

  defp to_unit_info(pid) do
    name = case Registry.keys(MyApp.Registry, pid) do
      [{:unit, name}] -> name
      _ -> nil
    end

    %{name: name, pid: pid}
  end
end
