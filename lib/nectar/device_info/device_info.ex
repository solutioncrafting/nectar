defmodule Nectar.DeviceInfo do
  @type geo_coordinate :: Nectar.Types.geo_coordinate
  @type current_time :: integer

  defstruct [:geo_coordinate, :current_time]
end

