defmodule RPG do

  defprotocol Edible do
    def eat(item,character)
  end

  defmodule Character do
    defstruct health: 100, mana: 0
  end


  defmodule LoafOfBread do
    defstruct []

    defimpl Edible, for: RPG.LoafOfBread do
      def eat(_item,character) do
        {nil, %RPG.Character{character | health: character.health + 5 }}
      end
    end

  end

  defmodule EmptyBottle do
    defstruct []
  end
  
  defmodule ManaPotion do
    defstruct strength: 10

    defimpl Edible, for: RPG.ManaPotion do
      def eat(item,character) do
        { %RPG.EmptyBottle{} , %RPG.Character{ character | mana: character.mana + item.strength }}
      end
    end
  end

  defmodule Poison do
    defstruct []

    defimpl Edible, for: RPG.Poison do
      def eat(_item,character) do
        { %RPG.EmptyBottle{} , %RPG.Character{ character | health: 0 }}
      end
    end
  end


end
