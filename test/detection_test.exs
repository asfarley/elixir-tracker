defmodule DetectionTest do
  use ExUnit.Case
  doctest Detection

  def fmt(decimal) do
    :io_lib.format("~.6f", [decimal])
  end

  test "p_size_delta is inversely related to size-delta" do
    constants = Configuration.constants()
    x_i = %Detection{Size: 200}
    x_j = %Detection{Size: 210}
    x_k = %Detection{Size: 10_000}
    p_size_ij = Detection.p_size_delta(x_i, x_j, constants)
    p_size_jk = Detection.p_size_delta(x_j, x_k, constants)
    assert p_size_jk < p_size_ij
  end

  test "p_position_delta is inversely related to position-delta" do
    constants = Configuration.constants()
    x_i = %Detection{X: 100}
    x_j = %Detection{X: 110}
    x_k = %Detection{X: 300}
    p_position_ij = Detection.p_position_delta(x_i, x_j, constants)
    p_position_jk = Detection.p_position_delta(x_j, x_k, constants)
    assert p_position_jk < p_position_ij
  end

  test "p_color_delta is inversely related to color-delta" do
    constants = Configuration.constants()
    x_i = %Detection{Red: 100}
    x_j = %Detection{Red: 110}
    x_k = %Detection{Red: 30}
    p_color_ij = Detection.p_color_delta(x_i, x_j, constants)
    p_color_jk = Detection.p_color_delta(x_j, x_k, constants)
    assert p_color_jk < p_color_ij
  end

  test "p_time_delta is inversely related to time-delta when time-delta is greater
  than 0 and not greater than the maximum time-gap" do
    constants = Configuration.constants()
    x_i = %Detection{frame: 100}
    x_j = %Detection{frame: 101}
    x_k = %Detection{frame: 101 + constants[:epsilon]}
    p_time_ij = Detection.p_time_delta(x_i, x_j, constants)
    p_time_jk = Detection.p_time_delta(x_j, x_k, constants)
    assert p_time_jk < p_time_ij
  end

  test "p_time_delta is zero when time-delta is equal to or less than 0" do
    constants = Configuration.constants()
    x_i = %Detection{frame: 100}
    x_j = %Detection{frame: 100}
    x_k = %Detection{frame: 50}
    p_time_ij = Detection.p_time_delta(x_i, x_j, constants)
    p_time_jk = Detection.p_time_delta(x_j, x_k, constants)
    assert p_time_ij == 0
    assert p_time_jk == 0
  end

  test "p_time_delta is zero when maximum time-delta is exceeded" do
    constants = Configuration.constants()
    x_i = %Detection{frame: 100}
    x_j = %Detection{frame: 101}
    x_k = %Detection{frame: 101 + constants[:epsilon] + 1}
    p_time_ij = Detection.p_time_delta(x_i, x_j, constants)
    p_time_jk = Detection.p_time_delta(x_j, x_k, constants)
    assert p_time_ij != 0
    assert p_time_jk == 0
  end

  test "p_link decreases when measurements are dissimiliar" do
    constants = Configuration.constants()
    x_i = %Detection{X: 100, Y: 200, Size: 100, frame: 100, Red: 100}
    x_j = %Detection{X: 101, Y: 201, Size: 110, frame: 101, Red: 110}
    x_k = %Detection{X: 110, Y: 250, Size: 1000, frame: 1000, Red: 200}
    p_link_ij = Detection.p_link(x_i, x_j, constants)
    p_link_jk = Detection.p_link(x_j, x_k, constants)
    assert p_link_ij != 0
    assert p_link_jk < p_link_ij
  end
end
