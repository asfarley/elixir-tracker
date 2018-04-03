defmodule Graph do
  defstruct X: [], XV: %{}, VX: %{}, nodes: [], arcs: []

  @type graph :: %Graph{
          X: list(Detection.detection()),
          XV: map(),
          VX: map(),
          nodes: list(atom()),
          arcs: list(Arc.arc())
        }

  @spec detection_to_subgraph(Detection.detection(), AlgorithmState.algorithmstate()) ::
          Graph.graph()
  def detection_to_subgraph(x_i, algorithm_state) do
    nodes = detection_to_nodes(x_i)
    arcs = Arc.detection_to_arcs(x_i, algorithm_state, nodes)
    xv = %{x_i => nodes}
    u_i = List.first(nodes)
    v_i = List.last(nodes)
    vx = %{u_i => x_i, v_i => x_i}
    %Graph{X: [x_i], XV: xv, VX: vx, nodes: nodes, arcs: arcs}
  end

  @spec detection_to_nodes(Detection.detection()) :: list(atom())
  def detection_to_nodes(x_i) do
    u_i = String.to_atom("u_#{x_i.id}")
    v_i = String.to_atom("v_#{x_i.id}")
    [u_i, v_i]
  end
end
