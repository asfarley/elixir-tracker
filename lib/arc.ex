defmodule Arc do
  defstruct in: nil, out: nil, cost: 0, flow: 0

  @type arc :: %Arc{}

  @spec detection_to_entry_arc(
          Detection.detection(),
          list(Trajectory.trajectory()),
          list(Detection.detections()),
          atom()
        ) :: Arc.arc()
  def detection_to_entry_arc(x_i, trajectories, detections, u_i) do
    p_entr = AlgorithmState.p_entr(trajectories, detections)
    entry_cost = Trajectory.c_en_i(p_entr)
    entry_flow = Trajectory.f_en_i(trajectories, x_i)
    %Arc{in: :source, out: u_i, cost: entry_cost, flow: entry_flow}
  end

  @spec detection_to_exit_arc(
          Detection.detection(),
          list(Trajectory.trajectory()),
          list(Detection.detection()),
          atom()
        ) :: Arc.arc()
  def detection_to_exit_arc(x_i, trajectories, detections, v_i) do
    p_exit = AlgorithmState.p_exit(trajectories, detections)
    exit_cost = Trajectory.c_ex_i(p_exit)
    exit_flow = Trajectory.f_ex_i(trajectories, x_i)
    %Arc{in: v_i, out: :sink, cost: exit_cost, flow: exit_flow}
  end

  @spec detection_to_detection_arc(
          Detection.detection(),
          list(Trajectory.trajectory()),
          number(),
          list()
        ) :: Arc.arc()
  def detection_to_detection_arc(x_i, trajectories, beta, nodes) do
    exit_cost = Trajectory.c_i(beta)
    exit_flow = Trajectory.f_i(trajectories, x_i)
    %Arc{in: List.first(nodes), out: List.last(nodes), cost: exit_cost, flow: exit_flow}
  end

  @spec detection_to_association_arcs(
          Detection.detection(),
          atom(),
          list(Trajectory.trajectory()),
          list(Detection.detection()),
          map(),
          map()
        ) :: list(Arc.arc())
  def detection_to_association_arcs(x_i, v_i, trajectories, detections, xv, constants) do
    plinked_detections = get_plinked_detections(x_i, detections, constants)

    Enum.map(plinked_detections, fn d ->
      destination_node = xv[d]
      cost = Trajectory.c_i_j(Detection.p_link(x_i, d, constants))
      flow = Trajectory.f_i_j(trajectories, x_i, d)
      %Arc{in: v_i, out: destination_node, cost: cost, flow: flow}
    end)
  end

  @spec detection_to_arcs(
          Detection.detection(),
          list(Trajectory.trajectory()),
          list(Detection.detection()),
          list(),
          map()
        ) :: list(Arc.arc())
  def detection_to_arcs(x_i, trajectories, detections, nodes, constants) do
    u_i = List.first(nodes)
    v_i = List.last(nodes)

    xv = %{x_i => [u_i, v_i]}

    entry_arc = detection_to_entry_arc(x_i, trajectories, detections, u_i)
    exit_arc = detection_to_exit_arc(x_i, trajectories, detections, v_i)

    detection_arc = detection_to_detection_arc(x_i, trajectories, constants.beta, nodes)

    association_arcs =
      detection_to_association_arcs(x_i, v_i, trajectories, detections, xv, constants)

    [entry_arc, detection_arc, exit_arc] ++ association_arcs
  end

  @spec get_plinked_detections(Detection.detection(), list(Detection.detection()), map()) ::
          list(Detection.detection())
  def get_plinked_detections(x_i, detections, constants) do
    Enum.filter(detections, fn d -> Detection.p_link(x_i, d, constants) > 0.0 end)
  end
end
