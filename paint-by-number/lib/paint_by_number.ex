defmodule PaintByNumber do
  def palette_bit_size(color_count) do
    find_small_bit(color_count,1)
  end

  defp find_small_bit(value,power) do
    result = 2**power
    cond do
      result >= value -> power
      true -> find_small_bit(value,power+1)
    end
  end

  def empty_picture() do
    <<>>
  end

  def test_picture() do
    <<0::2,1::2,2::2,3::2>>
  end




  def prepend_pixel(picture, color_count, pixel_color_index) do
    <<pixel_color_index::size(palette_bit_size(color_count)) , picture::bitstring >>
  end


  def get_first_pixel(<<>>,_) do nil end

  def get_first_pixel(picture, color_count) do
    size = palette_bit_size(color_count)
    <<first::size(size) , _rest::bitstring>> = <<picture::bitstring>>
    first
  end




  def drop_first_pixel(<<>>,_) do <<>> end
  def drop_first_pixel(picture, color_count) do
    size = palette_bit_size(color_count)
    <<_first::size(size),rest::bitstring>> = <<picture::bitstring>>
    rest
  end


  def concat_pictures(picture1, picture2) do
    <<picture1::bitstring, picture2::bitstring>>
  end
end
