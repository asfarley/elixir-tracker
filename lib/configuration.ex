defmodule Configuration do

  def constants do
    %{
      :epsilon => 10,          # Maximum time-delta in frames
      :zt => 1.0,              # Time-delta exponential multiplier
      :alpha => 0.05,          # Miss rate
      :beta => 0.01,           # False positive rate
      :sigma_position => 10.0, # Variance of position samples from individual vehicles
      :sigma_size => 10000.0,  # Variance of size samples from individual vehicles
      :sigma_color => 10.0     # Variance of color samples from individual vehicles
    }
  end

end
