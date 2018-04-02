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

  test "f_i_j returns 1 if x_j immediately follows x_i, 0 otherwise" do
    x_i = %Detection{id: 0}
    x_j = %Detection{id: 1}
    x_k = %Detection{id: 2}
    trajectory = [x_i, x_j, x_k]
    assert Trajectory.f_i_j([trajectory], x_i, x_j) == 1
    assert Trajectory.f_i_j([trajectory], x_j, x_k) == 1
    assert Trajectory.f_i_j([trajectory], x_i, x_k) == 0
  end

  test "f_i returns 1 if any trajectory contains x_i" do
    x_i = %Detection{id: 0}
    x_j = %Detection{id: 1}
    x_k = %Detection{id: 2}
    t1 = [x_i, x_j, x_k]
    t2 = [x_j, x_k]
    t3 = [x_k]
    trajectories_1 = [t1, t2, t3]
    trajectories_2 = [t2, t3]
    assert Trajectory.f_i(trajectories_1, x_i) == 1
    assert Trajectory.f_i(trajectories_2, x_i) == 0
    assert Trajectory.f_i(trajectories_1, x_k) == 1
  end
end
