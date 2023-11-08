defmodule Nectar.Lamp.Agent do
  import Nectar.DeviceInfo
  alias Nectar.Lamp

  @device_type :lamp

  def child_spec(_args) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end

  def start_link() do
    with {:ok, pid} <- Agent.start_link(fn -> Lamp.new() end) do
      handshake(pid)
      {:ok, pid}
    end
  end

  defp handshake(pid) do
    handshake(@device_type, pid)
  end

  # def send_to_gen_server(agent, message) do
  #   {:gateway_pid, gateway_pid} = Agent.get(agent, fn state -> state end)
  #   GenServer.cast(gateway_pid, {:send_message, self(), message})
  # end

  def get_lamp_state(agent) do
    Agent.get(agent, fn lamp -> lamp.is_on end)
  end

  def turn_on(agent) do
    Agent.update(agent, fn lamp -> Lamp.turn_on(lamp) end)
  end

  def turn_off(agent) do
    Agent.update(agent, fn lamp -> Lamp.turn_off(lamp) end)
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
