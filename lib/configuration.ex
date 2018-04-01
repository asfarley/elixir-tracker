defmodule Configuration do
  def constants do
    %{
      # Maximum time-delta in frames
      :epsilon => 10,
      # Time-delta exponential multiplier
      :zt => 1.0,
      # Miss rate
      :alpha => 0.05,
      # False positive rate
      :beta => 0.01,
      # Variance of position samples from individual vehicles
      :sigma_position => 10.0,
      # Variance of size samples from individual vehicles
      :sigma_size => 1000.0,
      # Variance of color samples from individual vehicles
      :sigma_color => 10.0
    }
  end
end
