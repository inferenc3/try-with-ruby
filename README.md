# The 10 million row challenge.
This challenge is inspired by the [1 billion row challenge](https://1brc.dev/) that shot to fame on HackerNews in early March 2024.

We'll do a slightly different version:
1. Using Ruby, and
2. Only with 10 million rows. (tentative, maybe 100M could work)
3. No hard restrictions. If you want to be a smart ass and subvert the challenge, that's cool too, as long as you can explain your smart-assery. Keep in mind the getting started kit is for people using a ruby solution.

We can feasibly generate and test 10 million rows on our machines.

# Instructions

```bash
git clone ...
cd ...
ruby generate_data.rb dev 10_000 -> dev_data.txt

run in background:
ruby generate_data.rb competition 10_000_000 -> competition_data.txt

open main.rb
bundle exec guard
def calculate(path) -> spec
test until correctness test passed

THEN

rspec:
  - enable benchmark test and show perf report

Submit correct and most performant solution

Correctness test:
  load spec.txt into hash
  run calculate -> spec
  check:
    hash key sets equal
    if equal: check min,max,mean values equal to within +-0.1
```
