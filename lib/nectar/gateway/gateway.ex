defmodule Nectar.Gateway do
  use GenServer
  alias Nectar.Camera.Agent, as: CameraAgent
  alias Nectar.Lamp.Agent, as: LampAgent
  alias Nectar.PIRSensor.Agent, as: PIRSensorAgent

  def start_link() do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    {:ok, state}
  end

  def handle_pir_event(state, lamp_pid, camera_pid) do
    IO.puts("PIR sensor detected movement")

    LampAgent.set_lamp_state(lamp_pid, true)
    CameraAgent.get_video_sequence(camera_pid, 30)

    Process.send_after(self(), :turn_off_lamp, 5 * 60 * 1000)

    {:noreply, state}
  end

  def handle_turn_off_lamp(state, lamp_pid) do
    IO.puts("Turning off the lamp")

    LampAgent.set_lamp_state(lamp_pid, false)

    {:noreply, state}
  end
end
