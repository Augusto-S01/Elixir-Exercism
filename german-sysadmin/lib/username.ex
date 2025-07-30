defmodule Username do
  def sanitize([]), do: []

  def sanitize([char | rest]) do
    case char do
      ?ä -> ~c"ae" ++ sanitize(rest)
      ?ö -> ~c"oe" ++ sanitize(rest)
      ?ü -> ~c"ue" ++ sanitize(rest)
      ?ß -> ~c"ss" ++ sanitize(rest)
      ?_ -> ~c"_"  ++ sanitize(rest)
      c when c in ?a..?z -> [c | sanitize(rest)]
      _ -> sanitize(rest)
    end
  end
end
