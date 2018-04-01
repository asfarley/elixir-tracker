defmodule NFAlgorithmState do

  def algorithm_state do
    %{
      :X => [],      # Detections
      :V => [],      # Vertices
      :XV => %{},    # Detection->Vertex map
      :E => [],      # Edges
      :C => [],      # Costs
      :f => [],      # Flows
      :f_G => 0,     # f(G): total flow on this graph G(V,E,C,f)
      :T => [],      # Trajectories in this assignment
      :T_star => [], # Optimal trajectories
      :C_star => 0.0,# Optimal cost
      :f_star => 0,  # Optimal flow
      :constants => Configuration.constants
    }
  end

  def p_entr(algorithm_state) do
    length(algorithm_state[:T])/((length(algorithm_state[:V])-2)/2)
  end

  def p_exit(algorithm_state) do
    p_entr(algorithm_state)
  end

end
