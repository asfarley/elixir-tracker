defmodule AlgorithmState do
  defstruct G: %Graph{},
            f_G: 0,
            T: [],
            T_star: [],
            C_star: :positive_infinity,
            f_star: 0.0,
            constants: Configuration.constants()

  @type algorithmstate :: %AlgorithmState{
          G: Graph.graph(),
          f_G: number(),
          T: list(Trajectory.trajectory()),
          T_star: list(Trajectory.trajectory()),
          C_star: float() | :positive_infinity,
          f_star: float(),
          constants: map()
        }

  @spec p_entr(list(), list()) :: float
  def p_entr(trajectories, detections) do
    cond do
      length(detections) == 0 -> 0.0
      true -> length(trajectories) / length(detections)
    end
  end

  @spec p_exit(list(), list()) :: float
  def p_exit(trajectories, detections) do
    p_entr(trajectories, detections)
  end

  @spec fromfile(String.t()) :: AlgorithmState.algorithmstate()
  def fromfile(filepath) do
    detections = Detection.fromfile(filepath)
    # TODO: make nodes and detection->node mapping
    # TODO: make arcs
    %AlgorithmState{}
  end
end
