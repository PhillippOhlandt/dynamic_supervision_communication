defmodule MyApp do
  @moduledoc """
  Documentation for MyApp.
  """

  alias MyApp.UnitSupervisor

  def add_unit(name) do
    UnitSupervisor.add_unit(name)
  end

  def list_units() do
    UnitSupervisor.list_units()
  end

  def get_unit_state(name) do
    UnitSupervisor.get_unit_state(name)
  end

  def remove_unit(name) do
    UnitSupervisor.remove_unit(name)
  end
end
