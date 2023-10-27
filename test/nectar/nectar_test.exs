defmodule NectarTest.Nectar do
  use ExUnit.Case
  alias Nectar.Gateway
  alias Nectar.PIRSensor.Agent, as: PIRSensorAgent
  alias Nectar.Lamp.Agent, as: LampAgent
  alias Nectar.Camera.Agent, as: CameraAgent

  test "test PIR sensor event handling" do
    {:ok, pir_sensor} = PIRSensorAgent.start_link()
    {:ok, lamp_agent} = LampAgent.start_link()
    {:ok, camera_agent} = CameraAgent.start_link()

    {:ok, gateway} = Gateway.start_link()

    # Simulate PIR sensor detecting movement and sending an event to the gateway
    pid = self()
    spawn(fn ->
      PIRSensorAgent.set_movement_detected(pir_sensor, true)
      Gateway.handle_pir_event(gateway, pid, pid)
    end)

    # Wait for a while to allow the Gateway to process the event
    :timer.sleep(1000)

    # Assert that the lamp state is turned on
    assert LampAgent.get_lamp_state(lamp_agent) == true

    # Assert that the camera took a snapshot
    assert CameraAgent.get_snapshot(camera_agent) == "snapshot.jpg"

    # Assert that the camera made 30 video recordings
    assert CameraAgent.get_video_links(camera_agent) == Enum.map(1..30, fn i -> "video#{i}.mp4" end)

    # Wait for 30 seconds (simulating the lamp being on)
    :timer.sleep(30_000)

    # Assert that the lamp state is turned off after 30 seconds
    assert LampAgent.get_lamp_state(lamp_agent) == false
  end
end
