defmodule AlgorithmState do
  defstruct X: [],
            XV: %{},
            Network: %Graph{},
            f_G: 0,
            T: [],
            T_star: [],
            C_star: 0.0,
            f_star: 0,
            constants: Configuration.constants()

  @type algorithmstate :: %AlgorithmState{
          X: list(Detection.detection()),
          XV: map(),
          Network: Graph.graph(),
          f_G: number(),
          T: list(Trajectory.trajectory()),
          T_star: list(Trajectory.trajectory()),
          C_star: float(),
          f_star: float(),
          constants: map()
        }

  @spec p_entr(map) :: float
  def p_entr(algorithm_state) do
    length(algorithm_state[:T]) / ((length(algorithm_state[:V]) - 2) / 2)
  end

  @spec p_exit(map) :: float
  def p_exit(algorithm_state) do
    p_entr(algorithm_state)
  end
end
