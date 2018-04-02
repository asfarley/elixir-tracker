defmodule AlgorithmState do
  defstruct G: %Graph{},
            f_G: 0,
            T: [],
            T_star: [],
            C_star: 0.0,
            f_star: 0.0,
            constants: Configuration.constants()

  @type algorithmstate :: %AlgorithmState{
          G: Graph.graph(),
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

  @spec fromfile(String.t()) :: AlgorithmState.algorithmstate()
  def fromfile(filepath) do
    detections = Detection.fromfile(filepath)
    # TODO: make nodes and detection->node mapping
    # TODO: make arcs
    %AlgorithmState{}
  end

  def detections_to_nodes(detections) do
    Enum.map(detections, fn d ->
      {[]}
    end)
  end
end
