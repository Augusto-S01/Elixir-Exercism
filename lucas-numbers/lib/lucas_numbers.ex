defmodule LucasNumbers do
  def generate(count) when count < 1 or not is_integer(count), do: raise(ArgumentError,"count must be specified as an integer >= 1")

  def generate(count) do

    Stream.iterate({2,1}, fn {a,b} -> { b, a+b } end  )
    |> Stream.map(fn {a,_b} -> a end )
    |> Enum.take(count)
  end
end


LucasNumbers.generate(1) |> IO.inspect()
