defmodule Graph do

  def detection_to_subgraph(detection_with_id,p_entr,p_exit,beta,trajectories) do
    # nodes u_i, v_i
    index = elem(detection_with_id,1)
    u_i = String.to_atom("u_#{index}")
    v_i = String.to_atom("v_#{index}")
    nodes = [u_i, v_i]

    entry_cost = Trajectory.c_en_i(p_entr)
    entry_flow = Trajectory.f_en_i(trajectories,detection_with_id)
    entry_arc = {:source, u_i, entry_cost, entry_flow}

    exit_cost = Trajectory.c_ex_i(p_exit)
    exit_flow = Trajectory.f_ex_i(trajectories,detection_with_id)
    exit_arc = {v_i, :sink, exit_cost, exit_flow}

    detection_cost = Trajectory.c_i(beta)
    detection_flow = Trajectory.f_i(trajectories,detection_with_id)
    detection_arc = {u_i,v_i,detection_cost,detection_flow}

    association_arcs = []

    arcs = [entry_arc, detection_arc, exit_arc] ++ association_arcs
    %{:nodes => nodes, :arcs => arcs}
  end

end
