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
  def new() do
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
    %{camera | snapshot: generate_image_snapshot()}
  end

  def start_recording(camera, _duration) do
    IO.puts("Starting video recording")
    %{camera | continuous_stream: :recording}
  end

  def stop_recording(camera) do
    IO.puts("Stopping video recording")
    %{camera | continuous_stream: nil}
  end

  def get_video_sequence(_camera, duration_seconds) when is_integer(duration_seconds) and duration_seconds > 0 do
    frame_rate = 30  # Number of frames per second
    frame_count = duration_seconds * frame_rate

    frame_data = generate_video_frames(frame_count)

    {:ok, frame_data}
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

  defp generate_image_snapshot() do
    {:ok, snapshot_data} = :crypto.strong_rand_bytes(1024 * 1024)  # 1 MB snapshot
    snapshot_data
  end

  defp generate_video_frames(frame_count) do
    Enum.reduce_while(1..frame_count, <<>>, fn _frame_number, acc ->
      frame_data = generate_single_frame()
      new_acc = <<acc::binary, frame_data::binary>>

      if byte_size(new_acc) >= frame_count * byte_size(frame_data) do
        {:halt, new_acc}
      else
        {:cont, new_acc}
      end
    end)
  end

  defp generate_single_frame() do
    # You can generate image data or any other simulated video content here.
    # For simplicity, we'll just generate random binary data.
    <<255::size(8)>> <> <<255::size(8)>> <> <<255::size(8)>>
  end
end
