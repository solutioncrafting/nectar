defmodule Nectar.Types.GeoCoordinate do
  @type t :: %{
    lat: float,
    lng: float,
    alt: float
  }

  defstruct [:lat, :lng, :alt]
end
