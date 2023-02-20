list = Enum.to_list(1..10_000)
map_fun = fn i -> [i, i * i] end

m1 = %{
  "a" => "this",
  "b" => "that",
  "c" => true,
  "d" => 123,
  "e" => [1, "the other", %{"h" => "value1"}],
  "f" => %{"g" => "some value", "h" => %{"j" => 1, "k" => [1, 2, 3]}}
}

m2 = %{
  "a" => "this",
  "b" => "that",
  "c" => true,
  "d" => 123,
  "e" => [1, "the other 2", %{"h" => "value2"}],
  "f" => %{"g" => "some value", "h" => %{"j" => 2}}
}

s1 = %{"str" => "abc", "num" => 10, "str2" => "this"}
s2 = %{"str" => "abc", "num" => 10}

Benchee.run(%{
  "flat_map" => fn -> Enum.flat_map(list, map_fun) end,
  "map.flatten" => fn -> list |> Enum.map(map_fun) |> List.flatten() end,
  "subset" => fn -> MapCompare.compare(m1, m2) end,
  "superset" => fn -> MapCompare.compare(m2, m1) end
})
