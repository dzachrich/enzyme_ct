require 'benchmark'
require_relative './hash_compare'

h1 = {'a' => 'this', 'b' => 'that', 'c' => true, 'd' => 123, 'e' => [1,"the other",{ 'h' => 'value1'}], 'f' => { 'g' => 'some value', 'h' => { 'j' => 1, 'k' => [1,2,3]}}}
h2 = {'a' => 'this', 'b' => 'that', 'c' => true, 'd' => 123, 'e' => [1,"the other 2",{ 'h' => 'value2'}], 'f' => { 'g' => 'some value', 'h' => { 'j' => 2}}}

n = 50_000

Benchmark.bm do |benchmark|
  benchmark.report("hash_compare h1<>h2") do
    n.times do
      Enzyme.hash_compare(h1, h2)
    end
  end

  benchmark.report("hash_compare h1==h2") do
    n.times do
      Enzyme.hash_compare(h1, h1)
    end
  end

  benchmark.report("hash_compare h1<>h2 (shallow: true)") do
    n.times do
      Enzyme.hash_compare(h1, h2, { shallow: true })
    end
  end

  benchmark.report("hash_compare h1==h2 (shallow: true)") do
    n.times do
      Enzyme.hash_compare(h1, h1, { shallow: true })
    end
  end
end