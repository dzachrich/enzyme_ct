defmodule MapCompareTest do
  use ExUnit.Case
  doctest MapCompare

  setup do
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

    #    [map1: m1, map2: m2]
    [map1: s1, map2: s2]
  end

  test "test_map_equality", %{map1: map1, map2: _map2} do
    assert MapCompare.compare(map1, map1) == {}
  end

  test "test_map_subset", %{map1: map1, map2: map2} do
    assert MapCompare.compare(map1, map2) == {"-", "str2", "this"}
  end

  test "test_map_superset", %{map1: map2, map2: map1} do
    assert MapCompare.compare(map1, map2) == {"+", "str2", "this"}
  end
end
