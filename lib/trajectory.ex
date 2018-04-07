defmodule Trajectory do
  @moduledoc """
  A Trajectory is a list of Detections.
  """

  defstruct detections: []

  @type trajectory :: %Trajectory{
          detections: list(Detection.detection())
        }

  # Indicator flag: does any trajectory begin at this measurement?
  @spec f_en_i(list(Trajectory.trajectory()), Detection.detection()) :: 0 | 1
  def f_en_i(trajectories, x_i) do
    bool_to_indicator(Enum.any?(trajectories, fn t -> x_i == List.first(t) end))
  end

  # Indicator flag: does any trajectory exit at this measurement?
  @spec f_ex_i(list(Trajectory.trajectory()), Detection.detection()) :: 0 | 1
  def f_ex_i(trajectories, x_i) do
    bool_to_indicator(Enum.any?(trajectories, fn t -> List.last(t) == x_i end))
  end

  # Indicator flag: does x_j follow x_i immediately in any trajectory?
  @spec f_i_j(list(Trajectory.trajectory()), Detection.detection(), Detection.detection()) ::
          0 | 1
  def f_i_j(trajectories, x_i, x_j) do
    bool_to_indicator(
      Enum.any?(trajectories, fn t ->
        i = Enum.find_index(t, fn e -> e == x_i end)
        j = Enum.find_index(t, fn e -> e == x_j end)

        cond do
          i == nil -> false
          j == nil -> false
          i + 1 == j -> true
          true -> false
        end
      end)
    )
  end

  # Indicator flag: does x_i belong to any trajectory?
  @spec f_i(list(Trajectory.trajectory()), Detection.detection()) :: 0 | 1
  def f_i(trajectories, x_i) do
    bool_to_indicator(Enum.any?(trajectories, fn t -> Enum.member?(t, x_i) end))
  end

  # Entrance cost
  @spec c_en_i(number) :: number | :positive_infinity
  def c_en_i(p_entr) do
    cond do
      p_entr == 0.0 -> :positive_infinity
      p_entr > 0.0 -> -:math.log(p_entr)
    end
  end

  # Exit cost
  @spec c_ex_i(number) :: number | :positive_infinity
  def c_ex_i(p_exit) do
    cond do
      p_exit == 0.0 -> :positive_infinity
      p_exit > 0.0 -> -:math.log(p_exit)
    end
  end

  # Cost of linking x_i to x_j
  @spec c_i_j(number) :: number | :positive_infinity
  def c_i_j(p_link) do
    cond do
      p_link == 0.0 -> :positive_infinity
      p_link > 0.0 -> -:math.log(p_link)
    end
  end

  # Cost of detection x_i
  @spec c_i(number) :: number
  def c_i(beta_i) do
    :math.log(beta_i / (1 - beta_i))
  end

  @spec bool_to_indicator(boolean) :: 0 | 1
  def bool_to_indicator(b) do
    case b do
      true -> 1
      false -> 0
    end
  end
end
