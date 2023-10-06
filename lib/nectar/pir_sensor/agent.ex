defmodule Nectar.PIRSensor.Agent do
  alias Nectar.PIRSensor

  def start_link() do
    Agent.start_link(&PIRSensor.new/0)
  end

  # Set properties
  def set_movement_detected(agent, value) do
    Agent.update(agent, fn state -> %{state | movement_detected: value} end)
  end

  def set_tamper_detected(agent, value) do
    Agent.update(agent, fn state -> %{state | tamper_detected: value} end)
  end

  def set_geo_coordinate(agent, geo_coord) do
    Agent.update(agent, fn state -> %{state | device_info: %{state.device_info | geo_coordinate: geo_coord}} end)
  end

  def set_current_time(agent, timestamp) do
    Agent.update(agent, fn state -> %{state | device_info: %{state.device_info | current_time: timestamp}} end)
  end

  # Get properties
  def get_movement_detected(agent) do
    Agent.get(agent, fn state -> state.movement_detected end)
  end

  def get_tamper_detected(agent) do
    Agent.get(agent, fn state -> state.tamper_detected end)
  end

  def get_geo_coordinate(agent) do
    Agent.get(agent, fn state -> state.device_info.geo_coordinate end)
  end

  def get_current_time(agent) do
    Agent.get(agent, fn state -> state.device_info.current_time end)
  end
end

