defmodule Nectar.PIRSensor.Agent do
  alias Nectar.PIRSensor
  import Nectar.DeviceInfo

  @device_type :pir_sensor

  def child_spec(_args) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end

  def start_link() do
    with {:ok, pid} <- Agent.start_link(fn -> PIRSensor.new() end) do
      handshake(pid)
      {:ok, pid}
    end
  end

  defp handshake(pid) do
    handshake(@device_type, pid)
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

  def handle_movement_detection(agent) do
    movement_detected = get_movement_detected(agent)

    if movement_detected do
      IO.puts("PIR sensor detected movement")
      gateway_pid = get_gateway_pid(agent)
      send(gateway_pid, {:pir_movement_detected})
    end
    :ok
  end

  def get_gateway_pid(agent) do
    agent.gateway_pid
  end
end

