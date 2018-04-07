defmodule Detection do
  @moduledoc """
  A Detection represents one observation of one
  object from one frame of video data.
  """

  defstruct X: 0,
            Y: 0,
            Width: 0,
            Height: 0,
            Size: 0,
            Red: 0,
            Green: 0,
            Blue: 0,
            ObjectClass: 0,
            frame: 0,
            id: 0

  @type detection :: %Detection{
          X: number(),
          Y: number(),
          Width: number(),
          Height: number(),
          Size: number(),
          Red: number(),
          Green: number(),
          Blue: number(),
          ObjectClass: integer(),
          frame: integer(),
          id: integer()
        }

  @doc """
  Read detections from JSON log file.
  """
  @spec fromfile(String.t()) :: list(Detection.detection())
  def fromfile(detectionsFilepath) do
    {:ok, text} = File.read(detectionsFilepath)
    lines = String.split(text, "\n")
    line_numbers = 1..length(lines)
    numbered_lines = Enum.zip(lines, line_numbers)
    lines_to_detections(numbered_lines, [])
  end

  @spec lines_to_detections(list(String.t()), list(Detection.detection())) ::
          list(Detection.detection())
  def lines_to_detections([head | tail], detections) do
    measurements = numbered_line_to_detections(head)
    lines_to_detections(tail, detections ++ measurements)
  end

  def lines_to_detections([], detections) do
    add_unique_numbering(detections)
  end

  @spec numbered_line_to_detections({String.t(), integer}) :: list(Detection.detection())
  def numbered_line_to_detections(line_with_number) do
    line = elem(line_with_number, 0)
    line_number = elem(line_with_number, 1)
    parse_result = JSON.decode(line)

    detections =
      case(parse_result) do
        {:ok, json} -> json["Measurements"]
        {:error, _} -> []
      end

    Enum.map(detections, fn d -> Map.merge(d, %{:frame => line_number}) end)
  end

  @spec add_unique_numbering(list(Detection.detection())) :: list(Detection.detection())
  def add_unique_numbering(detections) do
    detection_number_tuples = Enum.zip(detections, 1..length(detections))

    Enum.map(detection_number_tuples, fn d ->
      %{elem(d, 0) | id: elem(d, 1)}
    end)
  end

  @spec p_link(Detection.detection(), Detection.detection(), map) :: number
  def p_link(x_i, x_j, constants) do
    psd = p_size_delta(x_i, x_j, constants)
    ppd = p_position_delta(x_i, x_j, constants)
    ptd = p_time_delta(x_i, x_j, constants)
    pcd = p_color_delta(x_i, x_j, constants)
    psd * ppd * ptd * pcd
  end

  @spec p_size_delta(Detection.detection(), Detection.detection(), map) :: number
  def p_size_delta(x_i, x_j, constants) do
    size_delta = x_i."Size" - x_j."Size"
    Statistics.Distributions.Normal.pdf(0, constants[:sigma_size]).(size_delta)
  end

  @spec p_position_delta(Detection.detection(), Detection.detection(), map) :: number
  def p_position_delta(x_i, x_j, constants) do
    x_delta = x_i."X" - x_j."X"
    y_delta = x_i."Y" - x_j."Y"
    straight_line_distance = :math.sqrt(:math.pow(x_delta, 2) + :math.pow(y_delta, 2))
    Statistics.Distributions.Normal.pdf(0, constants[:sigma_position]).(straight_line_distance)
  end

  @spec p_time_delta(Detection.detection(), Detection.detection(), map) :: number
  def p_time_delta(x_i, x_j, constants) do
    time_delta = x_j.frame - x_i.frame

    cond do
      time_delta < 1 -> 0.0
      time_delta > constants[:epsilon] -> 0.0
      true -> constants[:zt] * :math.pow(constants[:alpha], time_delta - 1)
    end
  end

  @spec p_color_delta(Detection.detection(), Detection.detection(), map) :: number
  def p_color_delta(x_i, x_j, constants) do
    red_delta = x_i."Red" - x_j."Red"
    green_delta = x_i."Green" - x_j."Green"
    blue_delta = x_i."Blue" - x_j."Blue"

    color_distance =
      :math.sqrt(:math.pow(red_delta, 2) + :math.pow(green_delta, 2) + :math.pow(blue_delta, 2))

    Statistics.Distributions.Normal.pdf(0, constants[:sigma_color]).(color_distance)
  end

  @spec in_frame([Detection.detection()], integer) :: [Detection.detection()]
  def in_frame(detections, frame) do
    Enum.filter(detections, fn d ->
      d.frame == frame
    end)
  end
end
