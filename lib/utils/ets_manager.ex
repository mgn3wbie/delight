defmodule ETSManager do
  # creating a 'cache' table
  def create_table_if_needed(table) do
    if :ets.whereis(table) == :undefined do
      :ets.new(table, [:set, :protected, :named_table])
    end
  end


  def set_key_value_pair_in_table(key, value, table) do
    :ets.insert(table, {key, value})
  end


  def get_value_for_key_in_table(key, table) do
    case :ets.lookup(table, key) do
      [{_key, value}] -> value
      [] -> :empty
    end
  end
end
