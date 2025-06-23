defmodule LogLevel do
  def to_label(level, legacy?) do
    cond do 
      level == 0 and legacy? == false  -> :trace
      level == 1 -> :debug
      level == 2 -> :info
      level == 3 -> :warning
      level == 4 -> :error
      level == 5 and legacy? == false -> :fatal
      true -> :unknown 
    end
  end

  def alert_recipient(level, legacy?) do
    #if unknown and legacy ->   dev1
    #if unkown and not legacy -> dev2
    # fatal or error  -> ops
    cond do 
      legacy? == true  and to_label(level,legacy?) == :unknown -> :dev1
      legacy? == false and to_label(level,legacy?) == :unknown -> :dev2
      to_label(level,legacy?) == :error or to_label(level,legacy?) == :fatal    -> :ops
      true -> false
      end
  end
end
