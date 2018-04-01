defmodule Trajectory do

  #Indicator flag: does any trajectory begin at this measurement?
  def f_en_i(trajectories,x_i) do
   bool_to_indicator(Enum.any?(trajectories, fn t -> (x_i == List.first(t)) end))
  end

  #Indicator flag: does any trajectory exit at this measurement?
  def f_ex_i(trajectories,x_i) do
    bool_to_indicator(Enum.any?(trajectories, fn t -> (List.last(t) == x_i) end))
  end

  #Indicator flag: does x_j follow x_i immediately in any trajectory?
  def f_i_j(trajectories,x_i,x_j) do
    bool_to_indicator(Enum.any?(trajectories, fn t ->
      i = Enum.find_index(t, fn(e) -> (e == x_i) end)
      j = Enum.find_index(t, fn(e) -> (e == x_j) end)
      cond do
        i == nil -> false
        j == nil -> false
        (i + 1 == j) -> true
        true -> false
      end
    end))
  end

  #Indicator flag: does x_i belong to any trajectory?
  def f_i(trajectories, x_i) do
    bool_to_indicator(Enum.any?(trajectories, fn t -> Enum.member?(t,x_i) end))
  end

  #Entrance cost
  def c_en_i(p_entr) do
    -:math.log(p_entr)
  end

  #Exit cost
  def c_ex_i(p_exit) do
    -:math.log(p_exit)
  end

  #Cost of linking x_i to x_j
  def c_i_j(p_link) do
    -:math.log(p_link)
  end

  #Cost of detection x_i
  def c_i(beta_i) do
    :math.log(beta_i/(1-beta_i))
  end

  def bool_to_indicator(b) do
   case b do true -> 1; false -> 0 end
  end

end
