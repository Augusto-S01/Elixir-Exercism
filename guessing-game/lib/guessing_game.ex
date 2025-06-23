defmodule GuessingGame do
  def compare(_secret_number,guess \\ :no_guess) 
  def compare(_secret_number,guess) when guess == :no_guess do
    "Make a guess"
  end

    def compare(_secret_number,guess ) when guess == :no_guess do
    "Make a guess"
  end


  def compare(secret_number,guess) when guess+1 == secret_number  do
    "So close"
  end

    def compare(secret_number,guess) when guess-1 == secret_number  do
    "So close"
  end
  
  
  def compare(secret_number,guess) when guess > secret_number do
    "Too high"
  end

  def compare(secret_number,guess) when guess < secret_number do
    "Too low"
  end

  def compare(_secret_number, _guess) do
    "Correct"
  end


end
