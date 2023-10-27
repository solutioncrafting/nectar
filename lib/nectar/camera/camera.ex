defmodule Nectar.Camera do
  alias Nectar.Types.GeoCoordinate
  alias Nectar.DeviceInfo

  @type image() :: binary
  @type video() :: binary
  @type motion_detected() :: boolean
  @type night_mode() :: boolean
  @type ptz() :: {float, float, float}
  @type device_info() :: Nectar.DeviceInfo.t()

  defstruct [
    :continuous_stream,
    :snapshot,
    :video_sequence,
    :motion_detected,
    :night_mode,
    :ptz,
    :device_info
  ]

  # Camera Initialization
  def new do
    %__MODULE__{
      continuous_stream: nil,
      snapshot: nil,
      video_sequence: nil,
      motion_detected: false,
      night_mode: false,
      ptz: {0.0, 0.0, 1.0},
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

  # Camera Functions
  def get_snapshot(camera) do
    camera.snapshot
  end

  def get_video_sequence(_camera, duration_seconds) do
    {:ok, "Simulated video sequence for #{duration_seconds} seconds"}
  end

  def set_motion_detected(camera, motion_detected) do
    %{camera | motion_detected: motion_detected}
  end

  def set_night_mode(camera, night_mode) do
    %{camera | night_mode: night_mode}
  end

  def set_ptz(camera, {pan, tilt, zoom}) do
    %{camera | ptz: {pan, tilt, zoom}}
  end
end
