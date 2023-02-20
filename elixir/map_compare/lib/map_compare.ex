defmodule MapCompare do
  @moduledoc """
  Documentation for `MapCompare`.
  """

  @doc """
  Nested map compare

  ## Approach
  When comparing two maps, there are 4 different conditions to be evaluated with regard to keys
    - keys the same, values are unchanged, will not be listed

      iex> m1 = %{"a" => "this", "b" => "that"}
      iex> m2 = %{"a" => "this", "b" => "that"}
      iex> MapCompare.compare(m1,m2)
      {}

    - keys the same, value is changed, indicated by '~' and the previous and new value

      iex> m1 = %{"a" => "this", "b" => "that"}
      iex> m2 = %{"a" => "this", "b" => "the other"}
      iex> MapCompare.compare(m1,m2)
      {"~","b","that","the other"}

    - new key has been added in second map, indicated by '+' and the new value

      iex> m1 = %{"a" => "this", "b" => "that"}
      iex> m2 = %{"a" => "this", "b" => "that", "c" => true}
      iex> MapCompare.compare(m1,m2)
      {"+","c",true}

    - new key has been removed from second map, indicated by '-' and the old value

      iex> m1 = %{"a" => "this", "b" => "that"}
      iex> m2 = %{"a" => "this"}
      iex> MapCompare.compare(m1,m2)
      {"-","b","that"}

    In order to compare the differences between two deeply nested maps, a recursive solution will be used

  ## Examples
  A much more complex nested example would return a list of multiple differences.

      iex> m1 = %{"a" => "this", "b" => "that", "c" => true, "d" => 123, "e" => [1,"the other",%{ "h" => "value1"}], "f" => %{ "g" => "some value", "h" => %{ "j" => 1, "k" => [1,2,3]}}}
      iex> m2 = %{"a" => "this",                "c" => true, "d" => 123, "e" => [1,"the other 2",%{ "h" => "value2"}], "f" => %{ "g" => "some value", "h" => %{ "j" => 2}}}
      iex> MapCompare.compare(m1,m2)
      {{"-", "e[2]", {"h"=>"value1"}}, {"-", "e[1]", "the other"}, {"+", "e[1]", "the other 2"}, {"+", "e[2]", {"h"=>"value2"}}, {"-", "f.h.k", [1, 2, 3]}, {"~", "f.h.j", 1, 2}}

  """

  def compare(m1, m2)

  # maps equal, keys the same, values are unchanged
  def compare(m1, m1) do
    IO.inspect(m1, label: "maps equal")
    {}
  end

  # comparing two unequal maps
  def compare(m1 = %{}, m2 = %{}) do
    IO.inspect(m1, label: "compare m1")
    IO.inspect(m2, label: "compare m2")

    list = Enum.reduce(m1, fn {key, v1}, list ->
      IO.inspect([key,v1,list], label: "key, v1, list")
      if Map.has_key?(m2, key) do
        v2 = m2[key]
        if v1 === v2 do
          {}
        else
          if is_map(v1) && is_map(v2) do
            v_list = compare(v1, v2)
            if (v_list == list) do
              list
            else
              v_list
            end
          else
            {"~", key, v1, v2}
          end
        end
      else
        {"-", key, v1}
      end
    end)

    cur_list = list
    list = Enum.reduce(Map.keys(m2) -- Map.keys(m1), cur_list, fn key, list ->
      IO.inspect([key,m2[key],list], label: "key, m2[key], list")
      {"+", key, m2[key]}
    end)

    list

  end


end
