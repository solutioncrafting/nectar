defmodule Nectar.Gateway do
  use GenServer

  alias Nectar.Camera.Agent, as: CameraAgent
  alias Nectar.Lamp.Agent, as: LampAgent
  alias Nectar.PIRSensor.Agent, as: PIRSensorAgent

  @recording_time_seconds 15
  @valid_device_types [:pir_sensor, :camera, :lamp]

  def start_link(opts \\ %{}) do
    GenServer.start_link(__MODULE__, opts, name: :gateway)
  end

  def init(_) do
    initial_state = %{
      pir_sensor: nil,
      lamp: nil,
      camera: nil
    }

    {:ok, initial_state}
  end

  def get_gateway_pid() do
    Process.whereis(:gateway)
  end

  def get_device_pid(device_type) do
    gateway = get_gateway_pid()
    GenServer.call(gateway, {:get_device_pid, device_type})
  end

  def send_message(agent_pid, message) do
    GenServer.cast(__MODULE__, {:send_message, agent_pid, message})
  end

  def get_camera_agent_pid(state) do
    state.agents[CameraAgent]
  end

  def get_lamp_agent_pid(state) do
    state.agents[LampAgent]
  end

  def get_pir_sensor_agent_pid(state) do
    state.agents[PIRSensorAgent]
  end

  def handle_pir_event(gateway_pid, lamp_pid, camera_pid) do
    IO.puts("PIR sensor detected movement")

    LampAgent.turn_on(lamp_pid)
    CameraAgent.start_recording(camera_pid, @recording_time_seconds)

    Process.send_after(gateway_pid, {:turn_off_lamp, lamp_pid}, @recording_time_seconds * 1000)
    Process.send_after(gateway_pid, {:get_video_sequence, camera_pid}, @recording_time_seconds * 1000)

    {:noreply, gateway_pid}
  end

  def handle_info({:turn_off_lamp, lamp_pid}, state) do
    IO.puts("Turning off the lamp")
    LampAgent.turn_off(lamp_pid)

    {:noreply, state}
  end

  def handle_info({:get_video_sequence, camera_pid}, state) do
    IO.puts("Retrieving video sequence")

    case CameraAgent.get_video_sequence(camera_pid, @recording_time_seconds) do
      {:ok, video_data} ->
        store_video_sequence(video_data)
        IO.puts("Video sequence stored in a mock storage location.")

      {:error, reason} ->
        IO.puts("Failed to retrieve video sequence: #{reason}")
    end

    {:noreply, state}
  end

  def handle_cast({:register_device, message = %{type: _device_type, pid: device_pid}}, state) do
    if message.type in @valid_device_types && is_pid(device_pid) do
      new_state = Map.put(state, message.type, device_pid)
      {:noreply, new_state}
    else
      {:noreply, state}
    end
  end

  def handle_call({:get_device_pid, device_type}, _from, state) do
    case Map.get(state, device_type) do
      nil ->
        {:reply, {:error, :device_not_found}, state}
      device_pid when is_pid(device_pid) ->
        {:reply, {:ok, device_pid}, state}
    end
  end

  defp store_video_sequence(video_data) do
    # Actual storage logic will be implemented here.
    sample = binary_part(video_data, 0, 12)
    hex_strings = for <<byte::size(8) <- sample>>, do: Integer.to_string(byte, 10)
    formatted_hex = "<<" <> Enum.join(hex_strings, ", ") <> "...>>"
    IO.puts("Video sequence stored (Hexadecimal): #{formatted_hex}")
    :ok
  end
end
