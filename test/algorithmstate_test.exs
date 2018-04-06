defmodule AlgorithmStateTest do
  use ExUnit.Case
  doctest AlgorithmState

  test "p_entr is the probability of a detection being an entrance" do
    d0 = %Detection{frame: 0, id: 0}
    d1 = %Detection{frame: 0, id: 1}
    d2 = %Detection{frame: 1, id: 2}
    d3 = %Detection{frame: 1, id: 3}
    detections = [d0, d1, d2, d3]
    trajectories = []
    g = Graph.build_graph(trajectories, detections)
    %AlgorithmState{G: g}
    p_entr = AlgorithmState.p_entr(trajectories, detections)
    assert p_entr == 0
  end

  test "p_exit is the probability of a detection being an exit" do
    d0 = %Detection{frame: 0, id: 0}
    d1 = %Detection{frame: 0, id: 1}
    d2 = %Detection{frame: 1, id: 2}
    d3 = %Detection{frame: 1, id: 3}
    detections = [d0, d1, d2, d3]
    trajectories = []
    g = Graph.build_graph(trajectories, detections)
    %AlgorithmState{G: g}
    p_exit = AlgorithmState.p_entr(trajectories, detections)
    assert p_exit == 0
  end
end
