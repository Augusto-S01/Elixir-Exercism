defmodule TopSecret do
  def to_ast(variable) do
    Code.string_to_quoted!(variable)
  end

  def decode_secret_message_part(ast, acc) do
    case ast do
      {:def ,  _meta, [ {name,_,argument} | _rest]}  ->
        length(argument) |> IO.inspect()

        {ast,
        [Atom.to_string(name) |> String.slice(0,length(argument)) | acc ] }



      {:defp, _meta, [ {name,_,argument} | _rest]}  ->
        length(argument) |> IO.inspect()
        {ast,
        [Atom.to_string(name) |> String.slice(0,length(argument)) | acc] }
      _
       -> {ast , acc}
    end
  end


  def decode_secret_message(string) do
    # Please implement the decode_secret_message/1 function
  end
end


# string = "def fit(a, b, c), do: :scale"
# TopSecret.to_ast(string) |> IO.inspect()

# {:def, [line: 1], []}

#  [

#   {:fit, [line: 1],
#     [{:a, [line: 1], nil}, {:b, [line: 1], nil}, {:c, [line: 1], nil}]},
#    [do: :scale]
# ]
