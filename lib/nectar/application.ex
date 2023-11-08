defmodule Nectar.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  alias Nectar.Gateway
  alias Nectar.PIRSensor.Agent, as: PIRSensorAgent
  alias Nectar.Lamp.Agent, as: LampAgent
  alias Nectar.Camera.Agent, as: CameraAgent

  @impl true
  def start(_type, _args) do
#    Gateway.start_link()
#    PIRSensorAgent.start_link()
#    LampAgent.start_link()
#    CameraAgent.start_link()

    :timer.sleep(4000)

    children = [
      {Gateway, []},
      {PIRSensorAgent, []},
      {LampAgent, []},
      {CameraAgent, []}
    ]

    opts = [strategy: :one_for_one, name: Nectar.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
