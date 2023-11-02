defmodule NectarTest.Nectar do
  use ExUnit.Case
  alias Nectar.Gateway
  alias Nectar.PIRSensor.Agent, as: PIRSensorAgent
  alias Nectar.Lamp.Agent, as: LampAgent
#  alias Nectar.Camera.Agent, as: CameraAgent
  alias Nectar.DeviceInfo

  @recording_time_seconds 15

  test "test PIR sensor event handling" do
    # Simulate PIR sensor detecting movement and sending an event to the gateway
    gateway_pid = DeviceInfo.gateway_pid()
    {:ok, pir_sensor_pid} = Gateway.get_device_pid(:pir_sensor)
    {:ok, lamp_pid} = Gateway.get_device_pid(:lamp)
    {:ok, camera_pid} = Gateway.get_device_pid(:camera)

    PIRSensorAgent.set_movement_detected(pir_sensor_pid, true)
    Gateway.handle_pir_event(gateway_pid, lamp_pid, camera_pid)

    # Allow the Gateway to process the event
    :timer.sleep(1000)

    # Lamp should be turned on
    assert LampAgent.get_lamp_state(lamp_pid) == true

    # After @recording_time_seconds + 1 second the lamp should be turned off
    :timer.sleep((@recording_time_seconds + 1) * 1000)
    assert LampAgent.get_lamp_state(lamp_pid) == false
  end
end
