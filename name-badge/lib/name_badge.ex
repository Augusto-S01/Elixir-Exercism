defmodule NameBadge do
  def print(id , name , department) do

    if department == nil do
      if id == nil do 
        "#{name} - OWNER"
      else
        "[#{id}] - #{name} - OWNER"
      end
    else
      if id == nil do 
        "#{name} - #{String.upcase(department)}"
      else
        "[#{id}] - #{name} - #{String.upcase(department)}"
      end
    end

  
   end
end

