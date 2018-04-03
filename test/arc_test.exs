defmodule ArcTest do
  use ExUnit.Case
  doctest Arc

  test "detection_to_entry_arc generates entry arc" do
    d = %Detection{}
    as = %AlgorithmState{}
    arc = Arc.detection_to_entry_arc(d, as, :u_1)
    assert arc.in == :source
    assert arc.out == :u_1
    assert arc.cost > 0 or arc.cost == :positive_infinity
    assert arc.flow == 0
  end

  test "detection_to_exit_arc generates exit arc" do
    d = %Detection{}
    as = %AlgorithmState{}
    arc = Arc.detection_to_exit_arc(d, as, :v_1)
    assert arc.in == :v_1
    assert arc.out == :sink
    assert arc.cost > 0 or arc.cost == :positive_infinity
    assert arc.flow == 0
  end

  test "detection_to_detection_arc generates inter-detection arc" do
    d = %Detection{}
    as = %AlgorithmState{}
    nodes = [:u_1, :v_1]
    arc = Arc.detection_to_detection_arc(d, as, nodes)
    assert arc.in == :u_1
    assert arc.out == :v_1
    assert arc.cost < 0
    assert arc.flow == 0
  end

  test "detection_to_association_arcs generates association arcs" do
    d = %Detection{}
    as = %AlgorithmState{}
    nodes = [:u_1, :v_1]
    arcs = Arc.detection_to_association_arcs(d, :v_1, as)
    assert length(arcs) == 0
  end

  test "detection_to_arcs generates all arcs" do
    d = %Detection{}
    as = %AlgorithmState{}
    nodes = [:u_1, :v_1]
    arcs = Arc.detection_to_arcs(d, as, nodes)
    assert length(arcs) == 3
  end

  test "get_plinked_detections returns all detections where plink > 0" do
    d0 = %Detection{frame: 0}
    d1 = %Detection{frame: 1}
    d2 = %Detection{frame: 2}
    d3 = %Detection{frame: 3}
    d4 = %Detection{frame: 4}
    detections = [d0, d1, d2, d3, d4]
    g = %Graph{X: detections}
    as = %AlgorithmState{G: g}
    nodes = [:u_1, :v_1]
    plinked_detections = Arc.get_plinked_detections(d1, detections, as.constants)
    assert length(plinked_detections) == 3
  end
end
