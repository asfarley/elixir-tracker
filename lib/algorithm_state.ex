defmodule NFAlgorithmState do
  def algorithm_state do
    %{
      # Detections
      :X => [],
      # Vertices
      :V => [],
      # Detection->Vertex map
      :XV => %{},
      # Edges
      :E => [],
      # Costs
      :C => [],
      # Flows
      :f => [],
      # f(G): total flow on this graph G(V,E,C,f)
      :f_G => 0,
      # Trajectories in this assignment
      :T => [],
      # Optimal trajectories
      :T_star => [],
      # Optimal cost
      :C_star => 0.0,
      # Optimal flow
      :f_star => 0,
      :constants => Configuration.constants()
    }
  end

  def p_entr(algorithm_state) do
    length(algorithm_state[:T]) / ((length(algorithm_state[:V]) - 2) / 2)
  end

  def p_exit(algorithm_state) do
    p_entr(algorithm_state)
  end
end
