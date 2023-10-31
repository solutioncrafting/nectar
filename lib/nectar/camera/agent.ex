defmodule Nectar.Camera.Agent do
  alias Nectar.Camera

  def start_link() do
    Agent.start_link(fn -> Camera.new() end)
  end

  # Camera Functions
  def get_snapshot(agent) do
    Agent.get(agent, fn camera -> Camera.get_snapshot(camera) end)
  end

  def start_recording(agent, duration_seconds) when is_integer(duration_seconds) and duration_seconds > 0 do
    Agent.update(agent, fn camera -> Camera.start_recording(camera, duration_seconds) end)
  end

  def stop_recording(agent) do
    Agent.update(agent, fn camera -> Camera.stop_recording(camera) end)
  end

  def get_video_sequence(agent, duration_seconds) when is_integer(duration_seconds) and duration_seconds > 0 do
    Agent.get(agent, fn camera -> Camera.get_video_sequence(camera, duration_seconds) end)
  end

  def set_motion_detected(agent, motion_detected) do
    Agent.update(agent, fn camera -> Camera.set_motion_detected(camera, motion_detected) end)
  end

  def set_night_mode(agent, night_mode) do
    Agent.update(agent, fn camera -> Camera.set_night_mode(camera, night_mode) end)
  end

  def set_ptz(agent, {pan, tilt, zoom}) do
    Agent.update(agent, fn camera -> Camera.set_ptz(camera, {pan, tilt, zoom}) end)
  end
end
