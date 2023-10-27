defmodule Nectar.Camera.Agent do
  alias Nectar.Camera

  def start_link() do
    Agent.start_link(fn -> Camera.new() end)
  end

  # Camera Functions
  def get_snapshot(agent) do
    Agent.get(agent, fn camera -> Camera.get_snapshot(camera) end)
  end

  def get_video_sequence(agent, duration_seconds) do
    Agent.update(agent, fn camera -> Camera.get_video_sequence(camera, duration_seconds) end)
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
