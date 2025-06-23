defmodule HighSchoolSweetheart do
  def first_letter(name) do
    String.first(String.trim(name))
  end

  def initial(name) do
    name
    |> first_letter()
    |> Kernel.<>(".")
    |> String.upcase()
  end

  def initials(full_name) do
    list = String.split(full_name)
    last_name = List.last(list)
    first_name = List.first(list)
    initial(first_name) <> " " <> initial(last_name)
  end

  def pair(full_name1, full_name2) do
    """
    ❤-------------------❤
    |  #{initials(full_name1)}  +  #{initials(full_name2)}  |
    ❤-------------------❤
    """
  end
end
