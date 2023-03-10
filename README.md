## Code Test Submission

This is my submission for the [Enzyme](https://www.enzyme.com/about) code test for the [Full Stack Developer - Senior](https://angel.co/company/enzymecorp/jobs/287059-full-stack-developer-senior) position. 

In conversation with Julien, he indicated one of his teams is tasked with converting Enzyme's existing RoR apps to Elixir Phoenix LiveView, and the requirements for this position would need to include both ruby and elixir skills.  

As such, my approach will be to implement a solution for the hash_compare task using both ruby and elixir, and then benchmark both solutions to evaluate the performance improvement from these two approaches.

In the interest of time, I have implemented a wrapper using the existing open source `hashdiff` ruby gem to evaluate the two hash inputs, and created test cases to confirm conformance to the use case requirements.

The hashdiff gem is a recursive solution, but does have an unresolved issue when comparing hashes containing large internal arrays, which is documented in the [Limitations/Issues](####-Limitations/Issues) section below.

For the elixir implementation, I have implemented a recursive solution, with passing tests.

### Prerequisites

Before running these two solutions, you need to have the following installed on your machine:
- Ruby 2.3.1 or higher
- Elixir 

### Installation

Clone the repository: 
```shell
git clone https://github.com/dzachrich/enzyme_ct.git
cd enzyme_ct
```


### Usage/Testing/Benchmarking

To run the ruby tests, do the following:
```shell
cd ruby
bundle install
ruby hash_compare_test.rb
```
To benchmark ruby version:
```shell
ruby 3.1.2p20 (2022-04-12 revision 4491bb740a) [arm64-darwin21]

ruby benchmark.rb

       user     system      total        real
hash_compare h1<>h2  2.380356   0.009058   2.389414 (  2.397801)
hash_compare h1==h2  3.239222   0.010878   3.250100 (  3.258526)
hash_compare h1<>h2 (shallow: true)  2.403141   0.007438   2.410579 (  2.412564)
hash_compare h1==h2 (shallow: true)  0.008200   0.000071   0.008271 (  0.008274)
```
Note that the shallow hash compare when the two hashes are equal consumes very little cpu, as expected, but if they are not equal the execution time is even longer than for that of the deep compare.  
That is because if the hashes are not equal doing the shallow compare, a deep compare is performed to determine the differences.  But the tradeoff to perform a shallow compare first would be worth it, if most of the hashes being presented for comparison were equal, particularly when we note that the cost of confirming the equality of two equal hashes is so much more cpu intensive with the deep compare. 

To run the elixir tests, do the following:
```shell
cd elixir/map_compare
mix deps.get
mix test
```
To benchmark elixir version:
```shell
mix run lib/benchmark.exs

Operating System: macOS
CPU Information: Apple M1
Number of Available Cores: 8
Available memory: 16 GB
Elixir 1.14.2
Erlang 25.1.2

Benchmark suite executing with the following configuration:
warmup: 2 s
time: 5 s
memory time: 0 ns
reduction time: 0 ns
parallel: 1
inputs: none specified
Estimated total run time: 28 s

Benchmarking nested map m1<>m2 ...
Benchmarking nested map m1==m3 ...
Benchmarking subset small ...
Benchmarking superset small ...

Name                        ips        average  deviation         median         99th %
nested map m1==m3      205.28 M        4.87 ns  ??2277.90%        4.58 ns        6.25 ns
subset small             2.77 M      361.25 ns  ??6624.32%         333 ns         458 ns
superset small           2.50 M      400.45 ns  ??7898.94%         292 ns         458 ns
nested map m1<>m2        0.47 M     2142.95 ns   ??809.52%        1791 ns        3416 ns

Comparison: 
nested map m1==m3      205.28 M
subset small             2.77 M - 74.16x slower +356.38 ns
superset small           2.50 M - 82.20x slower +395.58 ns
nested map m1<>m2        0.47 M - 439.91x slower +2138.08 ns
```

### Additional Notes
#### Approach taken
- Create test modules to confirm working solutions
- Do the simplest thing that works
- Don't re-invent the wheel
- Understand the code

  - CLI to perform test execution of working code
  - Wrap [`hashdiff`](https://www.rubydoc.info/gems/hashdiff) gem for ruby solution
  - Recursion for elixir solution 
    - looked at the elixir [`map_diff`](https://hexdocs.pm/map_diff/MapDiff.html) hex package to get started, but very much disliked the output
    - output differences in format consistent with ruby `hashdiff` gem

#### Alternative solutions/considerations
- Benchmark both approaches to determine/verify performance improvements
- Create Rails and LiveView apps to provide better reviewer experience
- Containerize to standardize install, possibly using GitHub codespaces
- Replace Hashdiff gem with roll-my-own recursive algorithm for ruby solution
- Finish the recursive algorithm for elixir solution, consider using MapSet instead of Map for input data structure
- Convert ruby hash input parameters to HashWithIndifferentAccess to allow input hashes with symbol keys (the `hashdiff` gem already allows this)
- Or scrub input with `hash = hash.transform_keys(&:to_s)` to convert any symbol keys to string keys
- Demo elixir solution via livebook (requires adding instructions for installing Livebook)
- Complete ruby comparison vs elixir implementation using benchmark-ips and benchee to get better side-by-side comparison

#### Limitations/Issues
- Because the ruby solution uses the [`Hashdiff`](https://www.rubydoc.info/gems/hashdiff) gem, if the hash contains large internal arrays, it will have severe performance [issues](https://github.com/liufengyun/hashdiff/issues/49), because it uses the [LCS(longest common subsequence)](https://en.wikipedia.org/wiki/Longest_common_subsequence) algorithm to determine differences, resulting in an O(n^2) complexity.  So if this is the case, be sure to disable use of the LCS algorithm which is on by default using `use_lcs: false`

#### Have some fun along the way
Life is too short to be all plork and no way.

While I was working on this code submission, 10-year-old Walt introduced me to a posthumously published book he had just checked out from the library by Shel Silverstein:
```
Runny Babbit: A Billy Sook by Shel Silverstein

Way down in the green woods
Where the animals all play,
They do things and they say things
In a different sort of way???
Instead of sayin??? ???purple hat,???
They all say ???hurple pat.???
Instead of sayin??? ???feed the cat,???
The just say ???ceed the fat.
So if you say, ???Let???s bead a rook
That???s billy as can se,???
You???re talkin??? Runny Babbit talk
Just like mim and he. 
```

### Contact
David Zachrich
dave@zachrich.com
614.619.1096
