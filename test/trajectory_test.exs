defmodule TrajectoryTest do
  use ExUnit.Case
  doctest Trajectory

  test "f_en_i returns 0 if no trajectories exist" do
    x_i = %Detection{}
    assert Trajectory.f_en_i([], x_i) == 0
  end
end
