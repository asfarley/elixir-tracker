defmodule Graph do
  defstruct nodes: [], arcs: []

  @type graph :: %Graph{
          nodes: list(atom()),
          arcs: list(Arc.arc())
        }

  @spec detection_to_subgraph(Detection.detection(), AlgorithmState.algorithmstate()) ::
          Graph.graph()
  def detection_to_subgraph(x_i, algorithm_state) do
    nodes = detection_to_nodes(x_i)
    arcs = Arc.detection_to_arcs(x_i, algorithm_state, nodes)
    %Graph{nodes: nodes, arcs: arcs}
  end

  @spec detection_to_nodes(Detection.detection()) :: list(atom())
  def detection_to_nodes(x_i) do
    u_i = String.to_atom("u_#{x_i.id}")
    v_i = String.to_atom("v_#{x_i.id}")
    [u_i, v_i]
  end
end
