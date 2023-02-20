## Code Test Submission

This is my submission for the [Enzyme](https://www.enzyme.com/about) code test for the [Full Stack Developer - Senior](https://angel.co/company/enzymecorp/jobs/287059-full-stack-developer-senior) position. 

In conversation with Julien, he indicated one of his teams is tasked with converting Enzyme's existing RoR apps to Elixir Phoenix LiveView, and the requirements for this position would need to include both ruby and elixir skills.  

As such, my approach will be to implement a solution for the hash_compare task using both ruby and elixir, and then benchmark both solutions to evaluate the performance improvement from these two approaches.

In the interest of time, I have implemented a wrapper using the existing open source `hashdiff` ruby gem to evaluate the two hash inputs, and created test cases to confirm conformance to the use case requirements.

The hashdiff gem is a recursive solution, but does have an unresolved issue when comparing hashes containing large internal arrays, which is documented in the [Limitations/Issues](####-Limitations/Issues) section below.

For the elixir implementation, I would implement a recursive solution, and have started but do not quite have it running and passing tests just yet.

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
To benchmark:
```shell
ruby benchmark.rb

<add benchmark results here>
```

To run the elixir tests, do the following:
```shell
cd elixir/map_compare
mix deps.get
mix test
```
To benchmark:
```shell
mix run lib/benchmark.ex

<add benchmark results here>
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
    - attempt to get output in format more consistent with ruby `hashdiff` gem

#### Alternative solutions/considerations
- Benchmark both approaches to determine/verify performance improvements
- Create Rails and LiveView apps to provide better reviewer experience
- Containerize to standardize install, possibly using GitHub codespaces
- Replace Hashdiff gem with roll-my-own recursive algorithm for ruby solution
- Finish the recursive algorithm for elixir solution, consider using MapSet instead of Map for input data structure
- Convert ruby hash input parameters to HashWithIndifferentAccess to allow input hashes with symbol keys (the `hashdiff` gem already allows this)
- Or scrub input with `hash = hash.transform_keys(&:to_s)` to convert any symbol keys to string keys
- Demo elixir solution via livebook (requires adding instructions for installing Livebook)

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
In a different sort of way—
Instead of sayin’ “purple hat,”
They all say “hurple pat.”
Instead of sayin’ “feed the cat,”
The just say “ceed the fat.
So if you say, “Let’s bead a rook
That’s billy as can se,”
You’re talkin’ Runny Babbit talk
Just like mim and he. 
```

### Contact
David Zachrich
dave@zachrich.com
614.619.1096