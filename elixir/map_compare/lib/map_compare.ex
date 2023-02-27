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
      []

    - keys the same, value is changed, indicated by '~' and the previous and new value

      iex> m1 = %{"a" => "this", "b" => "that"}
      iex> m2 = %{"a" => "this", "b" => "the other"}
      iex> MapCompare.compare(m1,m2)
      [{"~","b","that","the other"}]

    - new key has been added in second map, indicated by '+' and the new value

      iex> m1 = %{"a" => "this", "b" => "that"}
      iex> m2 = %{"a" => "this", "b" => "that", "c" => true}
      iex> MapCompare.compare(m1,m2)
      [{"+","c",true}]

    - new key has been removed from second map, indicated by '-' and the old value

      iex> m1 = %{"a" => "this", "b" => "that"}
      iex> m2 = %{"a" => "this"}
      iex> MapCompare.compare(m1,m2)
      [{"-","b","that"}]

    In order to compare the differences between two deeply nested maps, a recursive solution will be used

  ## Examples
  A much more complex nested example would return a list of multiple differences.

      iex> m1 = %{"a" => "this", "b" => "that", "c" => true, "d" => 123, "e" => {1,"the other",%{ "h" => "value1"}}, "f" => %{ "g" => "some value", "h" => %{ "j" => 1, "k" => [1,2,3]}}}
      iex> m2 = %{"a" => "this",                "c" => true, "d" => 123, "e" => {1,"the other 2",%{ "h" => "value2"}}, "f" => %{ "g" => "some value", "h" => %{ "j" => 2}}}
      iex> MapCompare.compare(m1,m2) |> Enum.sort
      ...>[
      ...>     {
      ...>       {"-", "e[2]", %{"h" => "value1"}},
      ...>       {"-", "b", "that"},
      ...>       {"-", "e[1]", "the other"},
      ...>       {"+", "e[1]", "the other 2"},
      ...>       {"+", "e[2]", %{"h" => "value2"}},
      ...>       {"-", "f.h.k", [1, 2, 3]},
      ...>       {"~", "f.h.j", 1, 2}
      ...>     }
      ...>   ] |> Enum.sort

  """

  def compare(m1, m2, path \\ "", diffs \\ [])

  # maps equal, keys the same, values are unchanged
  def compare(m1, m1, _path, diffs) do
    diffs
  end

  def compare(m1, m2, path, diffs) when not is_map(m1) and not is_list(m1) do
    [{"~", path, m1, m2}] ++ diffs
  end

  def compare(m1, m2, path, diffs) when not is_map(m2) and not is_list(m2) do
    [{"~", path, m1, m2}] ++ diffs
  end

  def compare([l1], [l2], path, diffs) do
    compare(l1, l2, path, 0, diffs)
  end

  def compare(m1 = %{}, m2 = %{}, path, diffs) do
    Enum.reduce(m1, diffs, fn {key, v1}, ldiffs ->
      new_path =
        case blank?(path) do
          true -> key
          _ -> "#{path}.#{key}"
        end

      case Map.has_key?(m2, key) do
        true ->
          v2 = m2[key]

          case v1 === v2 do
            true ->
              ldiffs

            _ ->
              cond do
                is_map(v1) && is_map(v2) -> compare(v1, v2, new_path, ldiffs)
                is_list(v1) && is_list(v2) -> compare(v1, v2, new_path, 0, ldiffs)
                true -> [{"~", new_path, v1, v2}] ++ ldiffs
              end
          end

        _ ->
          [{"-", new_path, v1}] ++ ldiffs
      end
    end) ++
      Enum.reduce(Map.keys(m2) -- Map.keys(m1), [], fn key, _diffs ->
        [{"+", key, m2[key]}]
      end)
  end

  def compare([], [], _path, _index, diffs), do: diffs

  def compare([h1 | t1], [h2 | t2], path, index, diffs) do
    ldiffs =
      cond do
        h1 == h2 -> []
        true -> [{"~", "#{path}[#{index}]", h1, h2}]
      end

    compare(t1, t2, "#{path}", index + 1, ldiffs ++ diffs)
  end

  def compare([], [l2], path, index, diffs) do
    [{"+", "#{path}[#{index}]", l2}] ++ diffs
  end

  def compare([l1], [], path, index, diffs) do
    [{"-", "#{path}[#{index}]", l1}] ++ diffs
  end

  defp blank?(str) when not is_nil(str), do: IO.iodata_length(str) == 0
  defp blank?(_), do: true
end
