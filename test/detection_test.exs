defmodule DetectionTest do
  use ExUnit.Case
  doctest Detection

  def fmt(decimal) do
    :io_lib.format("~.6f", [decimal])
  end

  test "p_size_delta is inversely related to size-delta" do
    constants = Configuration.constants()
    x_i = %{Detection.new() | "Size" => 100}
    x_j = %{Detection.new() | "Size" => 110}
    x_k = %{Detection.new() | "Size" => 100_000}
    p_size_ij = Detection.p_size_delta(x_i, x_j, constants)
    p_size_jk = Detection.p_size_delta(x_j, x_k, constants)
    IO.puts("p_size_ij: #{fmt(p_size_ij)}, p_size_jk: #{fmt(p_size_jk)}")
    assert p_size_jk < p_size_ij
  end
end
