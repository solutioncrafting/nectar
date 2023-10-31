defmodule NectarTest.Nectar do
  use ExUnit.Case
  alias Nectar.Gateway
  alias Nectar.PIRSensor.Agent, as: PIRSensorAgent
  alias Nectar.Lamp.Agent, as: LampAgent
  alias Nectar.Camera.Agent, as: CameraAgent

  @recording_time_seconds 15

  test "test PIR sensor event handling" do
    {:ok, pir_sensor} = PIRSensorAgent.start_link()
    {:ok, lamp_agent} = LampAgent.start_link()
    {:ok, camera_agent} = CameraAgent.start_link()

    {:ok, gateway} = Gateway.start_link()

    # Simulate PIR sensor detecting movement and sending an event to the gateway
    PIRSensorAgent.set_movement_detected(pir_sensor, true)
    Gateway.handle_pir_event(gateway, lamp_agent, camera_agent)

    # Allow the Gateway to process the event
    :timer.sleep(1000)

    # Lamp should be turned on
    assert LampAgent.get_lamp_state(lamp_agent) == true

    # After @recording_time_seconds + 1 second the lamp should be turned off
    :timer.sleep((@recording_time_seconds + 1) * 1000)
    assert LampAgent.get_lamp_state(lamp_agent) == false
  end
end
