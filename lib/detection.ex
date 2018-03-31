defmodule Detection do
  @moduledoc """
  Documentation for Detection.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Detection.fromfile("./data/Detections.json")
      [
  %{
    "Blue" => 156.0,
    "Green" => 155.0,
    "Height" => 57.0,
    "ObjectClass" => 1,
    "Red" => 153.0,
    "Size" => 3021.0,
    "Width" => 53.0,
    "X" => 26.0,
    "Y" => 119.0
  },...

  """

  def fromfile(detectionsFilepath) do
    {:ok, text} = File.read detectionsFilepath
    lines = String.split(text, "\n")
    lines_to_detections(lines,[])
  end

  def lines_to_detections([head|tail],detections) do
    measurements = line_to_detections(head)
    lines_to_detections(tail,detections ++ measurements)
  end

  def lines_to_detections([],detections) do
    detections
  end

  def line_to_detections(line) do
    parse_result = JSON.decode line
    case(parse_result) do
      {:ok,json} ->
        json["Measurements"]
      {:error,_} ->
        []
    end
  end

end
