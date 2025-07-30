defmodule BasketballWebsite do

  def extract_from_path(data, path) do
    [head | rest ] = String.split(path,".",parts: 2)

    cond do 
      rest == [] -> data[head] 
      true -> extract_from_path(data[head] ,List.first(rest) ) 
    end
  end



  

  

  def get_in_path(data, path) do
    list_path = String.split(path,".")
    get_in(data,list_path)
    
  end
end
