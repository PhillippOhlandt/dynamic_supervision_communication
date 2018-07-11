defmodule MyApp do
  @moduledoc """
  Documentation for MyApp.
  """

  alias MyApp.UnitSupervisor

  def add_unit(name) do
    UnitSupervisor.add_unit(name)
  end

  def list_units(name) do
    :ok
  end

  def get_unit_state(name) do
    :ok
  end

  def remove_unit(name) do
    :ok
  end
end
