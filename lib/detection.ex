defmodule Detection do
  @moduledoc """
  A Detection represents a single observation of a single
  object from one frame of video data.
  """

  @doc """
  Read detections from JSON log file.
  """
  def fromfile(detectionsFilepath) do
    {:ok, text} = File.read(detectionsFilepath)
    lines = String.split(text, "\n")
    line_numbers = 1..length(lines)
    numbered_lines = Enum.zip(lines, line_numbers)
    lines_to_detections(numbered_lines, [])
  end

  def lines_to_detections([head | tail], detections) do
    measurements = numbered_line_to_detections(head)
    lines_to_detections(tail, detections ++ measurements)
  end

  def lines_to_detections([], detections) do
    add_unique_numbering(detections)
  end

  def numbered_line_to_detections(line_with_number) do
    line = elem(line_with_number, 0)
    line_number = elem(line_with_number, 1)
    parse_result = JSON.decode(line)

    detections =
      case(parse_result) do
        {:ok, json} -> json["Measurements"]
        {:error, _} -> []
      end

    Enum.map(detections, fn d -> Map.merge(d, %{"frame" => line_number}) end)
  end

  def add_unique_numbering(detections) do
    detection_number_tuples = Enum.zip(detections, 1..length(detections))

    Enum.map(detection_number_tuples, fn dnt ->
      Map.merge(elem(dnt, 0), %{"id" => elem(dnt, 1)})
    end)
  end

  def p_link(x_i, x_j, constants) do
    psd = p_size_delta(x_i, x_j, constants)
    ppd = p_position_delta(x_i, x_j, constants)
    ptd = p_time_delta(x_i, x_j, constants)
    pcd = p_color_delta(x_i, x_j, constants)
    psd * ppd * ptd * pcd
  end

  def p_size_delta(x_i, x_j, constants) do
    size_delta = x_i["Size"] - x_j["Size"]
    Statistics.Distributions.Normal.pdf(0, constants[:sigma_size]).(size_delta)
  end

  def p_position_delta(x_i, x_j, constants) do
    x_delta = x_i["X"] - x_j["X"]
    y_delta = x_i["Y"] - x_j["Y"]
    straight_line_distance = :math.sqrt(:math.pow(x_delta, 2) + :math.pow(y_delta, 2))
    Statistics.Distributions.Normal.pdf(0, constants[:sigma_position]).(straight_line_distance)
  end

  def p_time_delta(x_i, x_j, constants) do
    time_delta = x_j["frame"] - x_i["frame"]

    cond do
      time_delta < 1 -> 0.0
      time_delta > constants[:epsilon] -> 0.0
      true -> constants[:zt] * :math.pow(constants[:alpha], time_delta - 1)
    end
  end

  def p_color_delta(x_i, x_j, constants) do
    red_delta = x_i["Red"] - x_j["Red"]
    green_delta = x_i["Green"] - x_j["Green"]
    blue_delta = x_i["Blue"] - x_j["Blue"]

    color_distance =
      :math.sqrt(:math.pow(red_delta, 2) + :math.pow(green_delta, 2) + :math.pow(blue_delta, 2))

    Statistics.Distributions.Normal.pdf(0, constants[:sigma_color]).(color_distance)
  end

  def in_frame(detections, frame) do
    Enum.filter(detections, fn d ->
      d["frame"] == frame
    end)
  end

  def new(
        x \\ 0,
        y \\ 0,
        red \\ 0,
        green \\ 0,
        blue \\ 0,
        height \\ 0,
        width \\ 0,
        size \\ 0,
        objectclass \\ 0,
        frame \\ 0,
        id \\ 0
      ) do
    %{
      "X" => x,
      "Y" => y,
      "Red" => red,
      "Green" => green,
      "Blue" => blue,
      "Height" => height,
      "Width" => width,
      "Size" => size,
      "ObjectClass" => objectclass,
      "frame" => frame,
      "id" => id
    }
  end
end
