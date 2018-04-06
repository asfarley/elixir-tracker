defmodule GraphTest do
  use ExUnit.Case
  doctest Graph

  test "detection_to_nodes returns correct atoms (named after detection id/index)" do
    d = %Detection{id: 354}
    nodes = Graph.detection_to_nodes(d)
    assert List.first(nodes) == :u_354
    assert List.last(nodes) == :v_354
  end
end
