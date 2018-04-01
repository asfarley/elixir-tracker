defmodule Graph do

  def detection_to_subgraph(x_i,algorithm_state) do
    nodes = detection_to_nodes(x_i)
    arcs = detection_to_arcs(x_i,algorithm_state,nodes)
    %{:nodes => nodes, :arcs => arcs}
  end

  def detection_to_entry_arc(x_i,algorithm_state,u_i) do
    p_entr = NFAlgorithmState.p_entr(algorithm_state)
    entry_cost = Trajectory.c_en_i(p_entr)
    entry_flow = Trajectory.f_en_i(algorithm_state[:T],x_i)
    {:source, u_i, entry_cost, entry_flow}
  end

  def detection_to_exit_arc(x_i,algorithm_state,v_i) do
    p_exit = NFAlgorithmState.p_exit(algorithm_state)
    exit_cost = Trajectory.c_ex_i(p_exit)
    exit_flow = Trajectory.f_ex_i(algorithm_state[:T],x_i)
    {v_i, :sink, exit_cost, exit_flow}
  end

  def detection_to_detection_arc(x_i,algorithm_state,nodes) do
    exit_cost = Trajectory.c_i(algorithm_state[:constants][:beta])
    exit_flow = Trajectory.f_i(algorithm_state[:T],x_i)
    {elem(nodes,0), elem(nodes,1), exit_cost, exit_flow}
  end

  def detection_to_association_arcs(x_i,v_i,algorithm_state) do
   plinked_detections = get_plinked_detections(x_i,algorithm_state[:X],algorithm_state[:constants])
   Enum.map(plinked_detections, fn d ->
     destination_node = algorithm_state[:XV][d]
     cost = Trajectory.c_i_j(Detection.p_link(x_i,d,algorithm_state[:constants]))
     flow = Trajectory.f_i_j(algorithm_state[:T],x_i,d)
     {v_i,destination_node,cost,flow}
   end)
  end

  def detection_to_nodes(x_i) do
    u_i = String.to_atom("u_#{x_i["id"]}")
    v_i = String.to_atom("v_#{x_i["id"]}")
    {u_i, v_i}
  end

  def detection_to_arcs(x_i,algorithm_state,nodes) do
    u_i = elem(nodes,0)
    v_i = elem(nodes,1)

    entry_arc = detection_to_entry_arc(x_i,algorithm_state,u_i)
    exit_arc = detection_to_exit_arc(x_i, algorithm_state, v_i)
    detection_arc = detection_to_detection_arc(x_i,algorithm_state,nodes)
    association_arcs = detection_to_association_arcs(x_i,v_i,algorithm_state)

    [entry_arc, detection_arc, exit_arc] ++ association_arcs
  end

  def get_plinked_detections(x_i,detections,constants) do
    Enum.filter(detections, fn d -> (Detection.p_link(x_i,d,constants) > 0.0) end)
  end

end
