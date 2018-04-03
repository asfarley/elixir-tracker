defmodule GraphTest do
  use ExUnit.Case
  doctest Graph

  test "detection_to_subgraph returns sensible subgraph" do
    d = %Detection{}
    as = %AlgorithmState{}
    sg = Graph.detection_to_subgraph(d, as)
    assert length(sg."X") == 1
    assert length(Map.keys(sg."XV")) == 1
    assert length(Map.keys(sg."VX")) == 2
    assert length(sg.nodes) == 2
    assert length(sg.arcs) == 3
  end

  test "detection_to_nodes returns correct atoms (named after detection id/index)" do
    d = %Detection{id: 354}
    nodes = Graph.detection_to_nodes(d)
    assert List.first(nodes) == :u_354
    assert List.last(nodes) == :v_354
  end
end
