defmodule Graph do
  defstruct X: [], XV: %{}, VX: %{}, nodes: [], arcs: []

  @type graph :: %Graph{
          X: list(Detection.detection()),
          XV: map(),
          VX: map(),
          nodes: list(atom()),
          arcs: list(Arc.arc())
        }

  @spec detection_to_nodes(Detection.detection()) :: list(atom())
  def detection_to_nodes(x_i) do
    u_i = String.to_atom("u_#{x_i.id}")
    v_i = String.to_atom("v_#{x_i.id}")
    [u_i, v_i]
  end

  def build_graph(trajectories, detections) do
    # Build nodes and XV/VX mappings
    detection_mapping_tuples =
      Enum.map(detections, fn det ->
        this_detection_nodes = detection_to_nodes(det)
        {this_detection_nodes, det}
      end)

    nodes =
      Enum.map(detection_mapping_tuples, fn dmt ->
        elem(dmt, 0)
      end)

    xv =
      Enum.reduce(detection_mapping_tuples, %{}, fn dmt, detection_node_mapping ->
        nodes = elem(dmt, 0)
        x = elem(dmt, 1)
        Map.put(detection_node_mapping, x, nodes)
      end)

    vx =
      Enum.reduce(detection_mapping_tuples, %{}, fn dmt, detection_node_mapping ->
        nodes = elem(dmt, 0)
        node_u = List.first(nodes)
        node_v = List.last(nodes)
        x = elem(dmt, 1)
        Map.merge(detection_node_mapping, %{node_u => x, node_v => x})
      end)

    arcs =
      Enum.map(detections, fn det ->
        Arc.detection_to_arcs(det, trajectories, detections, nodes, Configuration.constants())
      end)

    %Graph{X: detections, nodes: nodes, arcs: arcs, XV: xv, VX: vx}
  end
end
