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

  test "p_position_delta is inversely related to position-delta" do
    constants = Configuration.constants()
    x_i = %{Detection.new() | "X" => 100}
    x_j = %{Detection.new() | "X" => 110}
    x_k = %{Detection.new() | "X" => 100_000}
    p_position_ij = Detection.p_position_delta(x_i, x_j, constants)
    p_position_jk = Detection.p_position_delta(x_j, x_k, constants)
    IO.puts("p_position_ij: #{fmt(p_position_ij)}, p_position_jk: #{fmt(p_position_jk)}")
    assert p_position_jk < p_position_ij
  end

  test "p_color_delta is inversely related to color-delta" do
    constants = Configuration.constants()
    x_i = %{Detection.new() | "Red" => 100}
    x_j = %{Detection.new() | "Red" => 110}
    x_k = %{Detection.new() | "Red" => 30}
    p_color_ij = Detection.p_color_delta(x_i, x_j, constants)
    p_color_jk = Detection.p_color_delta(x_j, x_k, constants)
    IO.puts("p_color_ij: #{fmt(p_color_ij)}, p_color_jk: #{fmt(p_color_jk)}")
    assert p_color_jk < p_color_ij
  end

  test "p_time_delta is inversely related to time-delta when time-delta is greater
  than 0 and not greater than the maximum time-gap" do
    constants = Configuration.constants()
    max_delta = constants[:epsilon]
    x_i = %{Detection.new() | "frame" => 100}
    x_j = %{Detection.new() | "frame" => 101}
    x_k = %{Detection.new() | "frame" => 101 + max_delta}
    p_time_ij = Detection.p_time_delta(x_i, x_j, constants)
    p_time_jk = Detection.p_time_delta(x_j, x_k, constants)
    IO.puts("p_time_ij: #{fmt(p_time_ij)}, p_time_jk: #{fmt(p_time_jk)}")
    assert p_time_jk < p_time_ij
  end

  test "p_time_delta is zero when time-delta is equal to or less than 0" do
    constants = Configuration.constants()
    x_i = %{Detection.new() | "frame" => 100}
    x_j = %{Detection.new() | "frame" => 100}
    x_k = %{Detection.new() | "frame" => 50}
    p_time_ij = Detection.p_time_delta(x_i, x_j, constants)
    p_time_jk = Detection.p_time_delta(x_j, x_k, constants)
    IO.puts("p_time_ij: #{fmt(p_time_ij)}, p_time_jk: #{fmt(p_time_jk)}")
    assert p_time_ij == 0
    assert p_time_jk == 0
  end
end
