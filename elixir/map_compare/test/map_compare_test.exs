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
      "a" => "thissy",
      "c" => true,
      "d" => 123,
      "e" => [1, "the other 2", %{"h" => "value2"}],
      "f" => %{"g" => "some value", "h" => %{"j" => 2}},
      "k" => "that"
    }

    s1 = %{"str" => "abc", "num" => 10, "str2" => "this"}
    s2 = %{"str" => "abc", "num" => 10}

    [map1: s1, map2: s2, map1nested: m1, map2nested: m2]
  end

  test "test_map_equality", %{map1: map1} do
    assert MapCompare.compare(map1, map1) == []
  end

  test "test_map_equality_nested", %{map1nested: map1} do
    assert MapCompare.compare(map1, map1) == []
  end

  test "test_map_nested", %{map1nested: map1, map2nested: map2} do
    assert MapCompare.compare(map1, map2) |> Enum.sort() ==
             [
               {"~", "a", "this", "thissy"},
               {"-", "b", "that"},
               {"-", "f.h.k", [1, 2, 3]},
               {"~", "f.h.j", 1, 2},
               {"~", "e[2]", %{"h" => "value1"}, %{"h" => "value2"}},
               {"~", "e[1]", "the other", "the other 2"},
               {"+", "k", "that"}
             ]
             |> Enum.sort()
  end

  test "test_map_subset", %{map1: map1, map2: map2} do
    assert MapCompare.compare(map1, map2) == [{"-", "str2", "this"}]
  end

  test "test_map_superset", %{map1: map2, map2: map1} do
    assert MapCompare.compare(map1, map2) == [{"+", "str2", "this"}]
  end
end
