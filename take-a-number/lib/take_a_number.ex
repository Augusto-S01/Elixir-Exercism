defmodule TakeANumber do

  def loop(state) do
    receive do
      {:report_state,recieve_arg} -> send(recieve_arg,state)
    end
    loop(state)
  end



  def start() do
    spawn(fn ->
        loop(0)
       end
       )
  end
end
