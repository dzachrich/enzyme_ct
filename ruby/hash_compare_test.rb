# hash_compare_test.rb
require "test/unit"
require_relative './hash_compare'

class HashCompareTest < Test::Unit::TestCase

  def setup
    @h1 = {'a' => 'this', 'b' => 'that', 'c' => true, 'd' => 123, 'e' => [1,"the other",{ 'h' => 'value1'}], 'f' => { 'g' => 'some value', 'h' => { 'j' => 1, 'k' => [1,2,3]}}}
    @h2 = {'a' => 'this', 'b' => 'that', 'c' => true, 'd' => 123, 'e' => [1,"the other 2",{ 'h' => 'value2'}], 'f' => { 'g' => 'some value', 'h' => { 'j' => 2}}}
  end

  # - Hash only have string keys
  # - Hash only have string, boolean, number, array or hash as value
  # - Compare should have an option for deep or shallow compare
  # - Compare should list the difference for keys and values

  description 'test_hash_equality'
  def test_hash_equality
    diff  = Enzyme.hash_compare(@h1, @h1.dup)
    assert diff == []
  end

  description 'test_hash_equality_w_shallow_option'
  def test_hash_equality_w_shallow_option
    diff  = Enzyme.hash_compare(@h1, @h1.dup, { shallow: true })
    assert diff == []
  end

  description 'test_hash_inequality'
  def test_hash_inequality
    diff  = Enzyme.hash_compare(@h1, @h2)
    assert diff == [["-", "e[2]", {"h"=>"value1"}], ["-", "e[1]", "the other"], ["+", "e[1]", "the other 2"], ["+", "e[2]", {"h"=>"value2"}], ["-", "f.h.k", [1, 2, 3]], ["~", "f.h.j", 1, 2]]
  end

  description 'test_hash_inequality_w_shallow_option'
  def test_hash_inequality_w_shallow_option
    diff  = Enzyme.hash_compare(@h1, @h2, { shallow: true })
    assert diff == [["-", "e[2]", {"h"=>"value1"}], ["-", "e[1]", "the other"], ["+", "e[1]", "the other 2"], ["+", "e[2]", {"h"=>"value2"}], ["-", "f.h.k", [1, 2, 3]], ["~", "f.h.j", 1, 2]]
  end

  description 'test_hash_fails_w_symbol_keys'
  def test_hash_fails_w_symbol_keys
    # this was stated as a case that would not happen in the instruction,
    # so unless we transform the symbol keys to strings in Enzyme::hash_compare
    # we need to test it fails if one of the hashes contain a symbol key
    hash1 = {key: "abc"}
    hash2 = {"key" => "abc"}
    diff  = Enzyme.hash_compare(hash1, hash2)
    assert diff == [["-", "key", "abc"], ["+", "key", "abc"]]
  end

  def test_hash_values_changed
    hash1 = {"str" => "abc", "num" => 10}
    hash2 = {"str" => "def", "num" => 15}
    diff  = Enzyme.hash_compare(hash1, hash2)
    assert diff == [["~", "num", 10, 15], ["~", "str", "abc", "def"]]
  end

  def test_hash_subset
    hash1 = {"str" => "abc", "num" => 10, "str2" => "this"}
    hash2 = {"str" => "abc", "num" => 10}
    diff  = Enzyme.hash_compare(hash1, hash2)
    assert diff == [["-", "str2", "this"]]
  end

  def test_hash_superset
    hash1 = {"str" => "abc", "num" => 10}
    hash2 = {"str" => "abc", "num" => 10, "str2" => "this"}
    diff  = Enzyme.hash_compare(hash1, hash2)
    assert diff == [["+", "str2", "this"]]
  end

end
