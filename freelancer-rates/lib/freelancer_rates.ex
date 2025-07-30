defmodule FreelancerRates do

  #daily rate is 8 * hour rate
  #mouth = 22  billable days.

  def daily_rate(hourly_rate) do
    hourly_rate * 8.0

  end

  def apply_discount(before_discount, discount) do
     before_discount - before_discount * (1/discount)
  end

  def monthly_rate(hourly_rate, discount) do
    # Please implement the monthly_rate/2 function
  end

  def days_in_budget(budget, hourly_rate, discount) do
    # Please implement the days_in_budget/3 function
  end
end
