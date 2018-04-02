defmodule TrajectoryTest do
  use ExUnit.Case
  doctest Trajectory

  test "f_en_i returns 0 if no trajectories exist" do
    x_i = %Detection{}
    assert Trajectory.f_en_i([], x_i) == 0
  end

  test "f_en_i returns 1 if trajectory starts at this detections" do
    x_i = %Detection{id: 0}
    x_j = %Detection{id: 1}
    x_k = %Detection{id: 2}
    trajectory = [x_i, x_j, x_k]
    assert Trajectory.f_en_i([trajectory], x_i) == 1
    assert Trajectory.f_en_i([trajectory], x_j) == 0
    assert Trajectory.f_en_i([trajectory], x_k) == 0
  end

  test "f_ex_i returns 0 if no trajectories exist" do
    x_i = %Detection{}
    assert Trajectory.f_ex_i([], x_i) == 0
  end

  test "f_ex_i returns 1 if trajectory ends at this detection" do
    x_i = %Detection{id: 0}
    x_j = %Detection{id: 1}
    x_k = %Detection{id: 2}
    trajectory = [x_i, x_j, x_k]
    assert Trajectory.f_ex_i([trajectory], x_i) == 0
    assert Trajectory.f_ex_i([trajectory], x_j) == 0
    assert Trajectory.f_ex_i([trajectory], x_k) == 1
  end
end
