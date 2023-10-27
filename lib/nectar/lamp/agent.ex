defmodule Nectar.Lamp.Agent do
  alias Nectar.Lamp

  def start_link() do
    Agent.start_link(fn -> Lamp.new() end)
  end

  def get_lamp_state(agent) do
    Agent.get(agent, fn lamp -> lamp.is_on end)
  end

  def set_lamp_state(agent, on_off) do
    Agent.update(agent, fn lamp -> Lamp.switch_on_off(lamp, on_off) end)
  end

  def toggle_lamp_state(agent) do
    Agent.update(agent, fn lamp -> Lamp.toggle(lamp) end)
  end

  def set_rgb_color(agent, color) do
    Agent.update(agent, fn lamp -> Lamp.set_rgb_color(lamp, color) end)
  end

  def set_white_mode(agent, white_mode) do
    Agent.update(agent, fn lamp -> Lamp.set_white_mode(lamp, white_mode) end)
  end

  def set_dim_percentage(agent, dim_percentage) do
    Agent.update(agent, fn lamp -> Lamp.set_dim_percentage(lamp, dim_percentage) end)
  end

  def set_schedule(agent, day_of_week, time, options) do
    Agent.update(agent, fn lamp -> Lamp.set_schedule(lamp, day_of_week, time, options) end)
  end

  def get_day_schedule(agent, day_of_week) do
    Agent.get(agent, fn lamp -> Lamp.get_day_schedule(lamp, day_of_week) end)
  end
end
