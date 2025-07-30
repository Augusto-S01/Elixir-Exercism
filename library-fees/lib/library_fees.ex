import NaiveDateTime

defmodule LibraryFees do
  #("2021-01-01T13:30:45Z")
  def datetime_from_string(string) do
    {:ok,result } = NaiveDateTime.from_iso8601(string)
    result
  end

  def before_noon?(datetime) do
    Time.before?(NaiveDateTime.to_time(datetime),~T[12:00:00])
  end



  def return_date(checkout_datetime) do
    # Please implement the return_date/1 function
  end

  def days_late(planned_return_date, actual_return_datetime) do
    # Please implement the days_late/2 function
  end

  def monday?(datetime) do
    # Please implement the monday?/1 function
  end

  def calculate_late_fee(checkout, return, rate) do
    # Please implement the calculate_late_fee/3 function
  end
end
