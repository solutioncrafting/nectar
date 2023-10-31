defmodule Nectar.Gateway do
  use GenServer
  alias Nectar.Camera.Agent, as: CameraAgent
  alias Nectar.Lamp.Agent, as: LampAgent

  @recording_time_seconds 15

  def start_link() do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    {:ok, state}
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

  defp store_video_sequence(video_data) do
    # Actual storage logic will be implemented here.
    sample = binary_part(video_data, 0, 12)
    hex_strings = for <<byte::size(8) <- sample>>, do: Integer.to_string(byte, 10)
    formatted_hex = "<<" <> Enum.join(hex_strings, ", ") <> "...>>"
    IO.puts("Video sequence stored (Hexadecimal): #{formatted_hex}")

    :ok
  end
end
