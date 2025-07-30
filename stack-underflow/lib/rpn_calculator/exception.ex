defmodule RPNCalculator.Exception do
  defmodule DivisionByZeroError do
    defexception message: "division by zero occurred"

    @impl true
    def exception(value) do
      case value do
        [] ->
          %DivisionByZeroError{}
        _ ->
          %DivisionByZeroError{message: "Alert: " <> value}
      end
    end
  end

  defmodule StackUnderflowError do
    defexception message: "stack underflow occurred"

    @impl true
    def exception(value) do
      case value do
        [] ->
          %StackUnderflowError{}
        _ ->
          %StackUnderflowError{message: "stack underflow occurred, context: " <> value}
      end
    end
  end

  def divide([]), do: raise(StackUnderflowError,"when dividing")

  def divide(stack) do 
    if rem(Enum.count(stack) ,2 ) != 0 do
      raise(StackUnderflowError,"when dividing")
    end

    [divisor ,dividend ] = stack

    if divisor == 0 do
      raise(DivisionByZeroError)
    end
    dividend  /  divisor
  end

end
