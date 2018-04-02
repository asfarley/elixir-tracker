defmodule Arc do
  defstruct in: nil, out: nil, cost: 0, flow: 0

  @type arc :: %Arc{}

  @spec detection_to_subgraph(Detection.detection(), AlgorithmState.algorithmstate()) ::
          Graph.graph()
  def detection_to_subgraph(x_i, algorithm_state) do
    nodes = detection_to_nodes(x_i)
    arcs = detection_to_arcs(x_i, algorithm_state, nodes)
    %Graph{nodes: nodes, arcs: arcs}
  end

  @spec detection_to_entry_arc(Detection.detection(), AlgorithmState.algorithmstate(), atom()) ::
          Arc.arc()
  def detection_to_entry_arc(x_i, algorithm_state, u_i) do
    p_entr = AlgorithmState.p_entr(algorithm_state)
    entry_cost = Trajectory.c_en_i(p_entr)
    entry_flow = Trajectory.f_en_i(algorithm_state[:T], x_i)
    %Arc{in: :source, out: u_i, cost: entry_cost, flow: entry_flow}
  end

  @spec detection_to_exit_arc(Detection.detection(), AlgorithmState.algorithmstate(), atom()) ::
          Arc.arc()
  def detection_to_exit_arc(x_i, algorithm_state, v_i) do
    p_exit = AlgorithmState.p_exit(algorithm_state)
    exit_cost = Trajectory.c_ex_i(p_exit)
    exit_flow = Trajectory.f_ex_i(algorithm_state[:T], x_i)
    %Arc{in: v_i, out: :sink, cost: exit_cost, flow: exit_flow}
  end

  @spec detection_to_detection_arc(
          Detection.detection(),
          AlgorithmState.algorithmstate(),
          list()
        ) :: Arc.arc()
  def detection_to_detection_arc(x_i, algorithm_state, nodes) do
    exit_cost = Trajectory.c_i(algorithm_state[:constants][:beta])
    exit_flow = Trajectory.f_i(algorithm_state[:T], x_i)
    %Arc{in: List.first(nodes), out: List.last(nodes), cost: exit_cost, flow: exit_flow}
  end

  @spec detection_to_entry_arc(Detection.detection(), atom(), AlgorithmState.algorithmstate()) ::
          list(Arc.arc())
  def detection_to_association_arcs(x_i, v_i, algorithm_state) do
    plinked_detections =
      get_plinked_detections(x_i, algorithm_state[:X], algorithm_state[:constants])

    Enum.map(plinked_detections, fn d ->
      destination_node = algorithm_state[:XV][d]
      cost = Trajectory.c_i_j(Detection.p_link(x_i, d, algorithm_state[:constants]))
      flow = Trajectory.f_i_j(algorithm_state[:T], x_i, d)
      {v_i, destination_node, cost, flow}
    end)
  end

  @spec detection_to_nodes(Detection.detection()) :: list(atom())
  def detection_to_nodes(x_i) do
    u_i = String.to_atom("u_#{x_i.id}")
    v_i = String.to_atom("v_#{x_i.id}")
    [u_i, v_i]
  end

  @spec detection_to_arcs(Detection.detection(), AlgorithmState.algorithmstate(), list()) ::
          list(Arc.arc())
  def detection_to_arcs(x_i, algorithm_state, nodes) do
    u_i = List.first(nodes)
    v_i = List.last(nodes)

    entry_arc = detection_to_entry_arc(x_i, algorithm_state, u_i)
    exit_arc = detection_to_exit_arc(x_i, algorithm_state, v_i)
    detection_arc = detection_to_detection_arc(x_i, algorithm_state, nodes)
    association_arcs = detection_to_association_arcs(x_i, v_i, algorithm_state)

    [entry_arc, detection_arc, exit_arc] ++ association_arcs
  end

  @spec get_plinked_detections(Detection.detection(), list(Detection.detection()), map()) ::
          list(Detection.detection())
  def get_plinked_detections(x_i, detections, constants) do
    Enum.filter(detections, fn d -> Detection.p_link(x_i, d, constants) > 0.0 end)
  end
end
