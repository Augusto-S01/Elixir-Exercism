defmodule Lasagna do


  def expected_minutes_in_oven do
    40
  end


  def remaining_minutes_in_oven(time) do
    expected_minutes_in_oven() - time
  end





  def preparation_time_in_minutes(layer) do
    layer * 2
  end




  def total_time_in_minutes(layer, time) do
      preparation_time_in_minutes(layer) +time
  end



  def alarm() do
    "Ding!"
  end


end


IO.puts Lasagna.preparation_time_in_minutes(1)
