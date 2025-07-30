defmodule GottaSnatchEmAll do
  @type card :: String.t()
  @type collection :: MapSet.t(card())

  @spec new_collection(card()) :: collection()
  def new_collection(card) do
    MapSet.new([card])
  end

  @spec add_card(card(), collection()) :: {boolean(), collection()}
  def add_card(card, collection) do
    case MapSet.member?(collection,card) do
      false -> {false,MapSet.put(collection,card)}
      true -> {true,collection}
    end
  end

  @spec trade_card(card(), card(), collection()) :: {boolean(), collection()}
  def trade_card(your_card, their_card, collection) do
    worth? = not MapSet.member?(collection, their_card)
    valid? = MapSet.member?(collection, your_card)
    traded_collection =
      collection
      |> MapSet.delete(your_card)
      |> MapSet.put(their_card)

    {worth? and valid?, traded_collection}
  end


  @spec remove_duplicates([card()]) :: [card()]
  def remove_duplicates(cards) do
    MapSet.to_list(MapSet.new(cards))
  end

  @spec extra_cards(collection(), collection()) :: non_neg_integer()
  def extra_cards(your_collection, their_collection) do
    MapSet.size(MapSet.difference(your_collection,their_collection))
  end

  @spec boring_cards([collection()]) :: [card()]
  def boring_cards([]), do: []
  def boring_cards([first | rest]) do
    rest
    |> Enum.reduce(first, &MapSet.intersection/2)
    |> MapSet.to_list()
    |> Enum.sort()
  end


  @spec total_cards([collection()]) :: non_neg_integer()
  def total_cards([]), do: 0
  def total_cards([first | rest]) do
    rest
    |> Enum.reduce(first, &MapSet.union/2)
    |> MapSet.size()
  end

  @spec split_shiny_cards(collection()) :: {[card()], [card()]}
  def split_shiny_cards(collection) do
    shiny_collection =  MapSet.filter(collection,fn card -> String.contains?(card,"Shiny") end)
    {MapSet.to_list(shiny_collection),MapSet.to_list(MapSet.difference(collection,shiny_collection))}
  end
end
