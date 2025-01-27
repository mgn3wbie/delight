defmodule DateHelper do
  def complete_date_from(date, precision) do
    case precision do
      "day" -> date
      "month" -> date <> "-01"
      "year" -> date <> "-01-01"
    end

    date
  end

  def is_date_older(date1, date2) do
    date1 <= date2
  end

  def is_date_more_recent(date1, date2) do
    date1 > date2
  end
end
