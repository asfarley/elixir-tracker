defmodule Tracker do
  @moduledoc """
  Documentation for Tracker.
  """
  def samplepath do
    "./data/Detections.json"
  end

  def sample_detections do
    Detection.fromfile(samplepath())
  end
end
