defmodule RPG.CharacterSheet do
  def welcome() do
    IO.puts("Welcome! Let's fill out your character sheet together.")
  end

  def ask_name() do
    String.trim(IO.gets("What is your character's name?\n"))
  end

  def ask_class() do
    String.trim(IO.gets("What is your character's class?\n"))
  end

def ask_level() do
  String.to_integer(String.trim(IO.gets("What is your character's level?\n")))
end


def run() do
  welcome()
  %{name: ask_name(), class: ask_class(), level: ask_level()}
  |> IO.inspect(label: "Your character")
end

end
