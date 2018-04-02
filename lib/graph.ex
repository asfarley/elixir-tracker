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
    # TODO: Build XV and VX
    %Graph{X: [x_i], nodes: nodes, arcs: arcs}
  end

  @spec detection_to_nodes(Detection.detection()) :: list(atom())
  def detection_to_nodes(x_i) do
    u_i = String.to_atom("u_#{x_i.id}")
    v_i = String.to_atom("v_#{x_i.id}")
    [u_i, v_i]
  end
end
