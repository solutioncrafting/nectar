defmodule Nectar.Lamp do
  alias Nectar.Types.GeoCoordinate
  alias Nectar.DeviceInfo

  @type rgb_color :: {integer, integer, integer}
  @type dim_percentage :: integer

  defstruct [
    :is_on,
    :rgb_color,
    :is_white_mode,
    :dim_percentage,
    :schedule,
    :device_info
  ]

  def new() do
    %__MODULE__{
      is_on: false,
      rgb_color: {0, 0, 0},
      is_white_mode: false,
      dim_percentage: 100,
      schedule: %{
        :sunday => [],
        :monday => [],
        :tuesday => [],
        :wednesday => [],
        :thursday => [],
        :friday => [],
        :saturday => []
      },
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

  def switch_on_off(%__MODULE__{is_on: is_on} = lamp, true) when is_on == false do
    %{lamp | is_on: true}
  end

  def switch_on_off(%__MODULE__{is_on: is_on} = lamp, false) when is_on == true do
    %{lamp | is_on: false}
  end

  def turn_on(lamp) do
    %{lamp | is_on: true}
  end

  def turn_off(lamp) do
    %{lamp | is_on: false}
  end

  def toggle(%__MODULE__{is_on: is_on} = lamp) do
    %{lamp | is_on: not is_on}
  end

  def set_rgb_color(%__MODULE__{rgb_color: _} = lamp, color) when is_tuple(color) and tuple_size(color) == 3 do
    if validate_rgb_color(color) do
      %__MODULE__{lamp | rgb_color: color}
    else
      # Handle invalid color
      lamp
    end
  end

  defp validate_rgb_color({r, g, b}) when r in 0..255 and g in 0..255 and b in 0..255 do
    true
  end

  defp validate_rgb_color(_) do
    false
  end


  def set_white_mode(lamp, white_mode) do
    %{lamp | is_white_mode: white_mode}
  end

  def set_dim_percentage(%__MODULE__{dim_percentage: _} = lamp, dim_percentage) when dim_percentage >= 0 and dim_percentage <= 100 do
    if validate_dim_percentage(dim_percentage) do
      %__MODULE__{lamp | dim_percentage: dim_percentage}
    else
      # Handle invalid dim_percentage
      lamp
    end
  end

  defp validate_dim_percentage(dim_percentage) when dim_percentage >= 0 and dim_percentage <= 100 do
    true
  end

  defp validate_dim_percentage(_) do
    false
  end

  def set_schedule(lamp, day_of_week, _time, options) do
    updated_schedule =
      Map.update!(lamp.schedule, day_of_week, fn
        actions when is_list(actions) ->
          [options | actions]
        nil ->
          [options]
      end)

    %{lamp | schedule: updated_schedule}
  end

  def get_day_schedule(lamp, day_of_week) do
    Map.get(lamp.schedule, day_of_week, [])
  end
end
