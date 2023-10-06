defmodule Nectar.PIRSensor do
  alias Nectar.Types.GeoCoordinate
  alias Nectar.DeviceInfo

  defstruct [:movement_detected, :tamper_detected, :device_info]

  def new do
    %__MODULE__{
      movement_detected: false,
      tamper_detected: false,
      device_info: %DeviceInfo{
        geo_coordinate: %GeoCoordinate{
          lat: 50.09431362821687,
          lng: 14.449474425948397,
          alt: 0
        },
        current_time: :os.system_time(:second)
      }
    }
  end
end
