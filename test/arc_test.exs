defmodule ArcTest do
  use ExUnit.Case
  doctest Arc

  test "detection_to_entry_arc generates entry arc" do
    d = %Detection{}
    trajectories = []
    detections = []
    arc = Arc.detection_to_entry_arc(d, trajectories, detections, :u_1)
    assert arc.in == :source
    assert arc.out == :u_1
    assert arc.cost > 0 or arc.cost == :positive_infinity
    assert arc.flow == 0
  end

  test "detection_to_exit_arc generates exit arc" do
    d = %Detection{}
    trajectories = []
    detections = []
    arc = Arc.detection_to_exit_arc(d, trajectories, detections, :v_1)
    assert arc.in == :v_1
    assert arc.out == :sink
    assert arc.cost > 0 or arc.cost == :positive_infinity
    assert arc.flow == 0
  end

  test "detection_to_detection_arc generates inter-detection arc" do
    d = %Detection{}
    trajectories = []
    nodes = [:u_1, :v_1]

    arc =
      Arc.detection_to_detection_arc(
        d,
        trajectories,
        Configuration.constants().beta,
        nodes
      )

    assert arc.in == :u_1
    assert arc.out == :v_1
    assert arc.cost < 0
    assert arc.flow == 0
  end

  test "detection_to_association_arcs generates association arcs" do
    d = %Detection{}
    trajectories = []
    detections = []
    xv = %{}

    arcs =
      Arc.detection_to_association_arcs(
        d,
        :v_1,
        trajectories,
        detections,
        xv,
        Configuration.constants()
      )

    assert length(arcs) == 0
  end

  test "detection_to_arcs generates all arcs" do
    d = %Detection{}
    detections = []
    trajectories = []
    nodes = [:u_1, :v_1]
    arcs = Arc.detection_to_arcs(d, trajectories, detections, nodes, Configuration.constants())
    assert length(arcs) == 3
  end

  test "get_plinked_detections returns all detections where plink > 0" do
    d0 = %Detection{frame: 0}
    d1 = %Detection{frame: 1}
    d2 = %Detection{frame: 2}
    d3 = %Detection{frame: 3}
    d4 = %Detection{frame: 4}
    detections = [d0, d1, d2, d3, d4]
    plinked_detections = Arc.get_plinked_detections(d1, detections, Configuration.constants())
    assert length(plinked_detections) == 3
  end
end
