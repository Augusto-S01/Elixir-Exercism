defmodule DNA do
  def encode_nucleotide(code_point) do
    case code_point do
      ?A -> 0b0001
      ?C -> 0b0010
      ?G -> 0b0100
      ?T -> 0b1000
      _  -> 0b0000
    end
  end
  def decode_nucleotide(encoded_code) do
    case encoded_code do
      0b0001 -> ?A
      0b0010 -> ?C
      0b0100 -> ?G
      0b1000 -> ?T
      _      -> ?\s
    end
  end


  def encode(dna) do
    encode(dna,<<>>)
  end

  defp encode([],encoded_dna) do
    encoded_dna
  end

  defp encode([head|tail],encoded_dna)  do
    encode(tail ,  << encoded_dna::bitstring  , encode_nucleotide(head)::4 >>)
  end


  def decode(dna) do
    decode(dna,~c"")
  end

  defp decode(<<>>,decoded_dna) , do: decoded_dna

  defp decode(<<head::4 , tail::bitstring>> , decoded_dna) do
    decode(tail, decoded_dna ++ [decode_nucleotide(head)])
  end


end
