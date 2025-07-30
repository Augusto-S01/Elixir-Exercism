defmodule BirdCount do
  def today(list) do
    cond do
     list == [] -> nil
     true -> hd(list)
    end
  end

def increment_day_count([head | tail]) do
  [head + 1 | tail]
end

def increment_day_count([]) do
  [1]
end


  def has_day_without_birds?([]) do
     false
  end

  

  def has_day_without_birds?([head | tail]) do
     cond do
       head == 0 -> true
       true -> has_day_without_birds?(tail)
       end
  end

  def total (list) do
  cond do 
    list == [] -> 0
    tl(list) == [] -> hd(list)
    true -> hd(list) + total(tl(list))
  end
  end

  

  def busy_days(list) do
    cond do 
    list == []    -> 0
    hd(list) >= 5 -> 1 + busy_days(tl(list))
    hd(list) < 5 -> 0 + busy_days(tl(list))
    true -> 0
    end
  end
end
