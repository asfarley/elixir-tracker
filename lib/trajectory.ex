defmodule Trajectory do

  #Indicator flag: does this trajectory begin at this measurement?
  def f_en_i(t,x_i) do
   [head|_] = t
   case (x_i == head) do
    true -> 1
    false -> 0
   end
  end

  #Indicator flag: does this trajectory exit at this measurement?
  def f_ex_i(t,x_i) do
    case (List.last(t) == x_i) do
      true -> 1
      false -> 0
    end
  end

  #Indicator flag: does x_j follow x_i immediately in t?
  def f_i_j(t,x_i,x_j) do
    i = Enum.find_index(t, fn(e) -> (e == x_i) end)
    j = Enum.find_index(t, fn(e) -> (e == x_j) end)
    cond do
      i == nil -> 0
      j == nil -> 0
      (i + 1 == j) -> 1
      true -> 0
    end
  end

  #Indicator flag: does x_i belong to t?
  def f_i(t, x_i) do
    case Enum.member?(t,x_i) do
      true -> 1
      false -> 0
    end
  end

  def c_en_i(p_entr) do
    -:math.log(p_entr)
  end

end
