defmodule Tracker do
  @moduledoc """
  Documentation for Tracker.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Tracker.hello
      :world

  """
  def hello do
    :world
  end

  def samplepath do
    "./data/Detections.json"
  end

  def sample_detections do
    Detection.fromfile(samplepath())
  end

end
