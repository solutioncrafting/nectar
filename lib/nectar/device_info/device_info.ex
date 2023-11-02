defmodule Nectar.DeviceInfo do
  @type geo_coordinate :: Nectar.Types.geo_coordinate
  @type current_time :: integer

  defstruct [:geo_coordinate, :current_time]

  def gateway_pid() do
    case Process.whereis(:gateway) do
      nil -> :error
      pid when is_pid(pid) -> pid
    end
  end

  def handshake(device_type, device_pid) when is_atom(device_type) and is_pid(device_pid) do
    send_to_gateway(:register_device, %{type: device_type, pid: device_pid})
  end

  def send_to_gateway(message_type, message) when is_atom(message_type) do
    pid = gateway_pid()
    GenServer.cast(pid, {message_type, message})
  end

  def send_to_gateway(_, _) do
    IO.puts("error: message_type must be an atom.")
  end
end

