# 2016

Solutions for [Advent of Code 2016](https://adventofcode.com/2016) in Swift.

## Usage

### CLI

Run from the CLI with `swift run AOC2016 {day} {part}`.
where {day} specifies the number of the day (1...25)
and {part} whether part `1` or `2` should be run.

Additionally `-t` can be added to run the the day using the example input.

### Xcode

When running in Xcode the arguments should be added to the scheme `AOC2016` scheme.

### user specific input

You have to include your input inside `./Sources/AOC2016Core/Inputs`.
The input files need to be named `input_{day}_{part}.txt`.
However usually, there's the same input for part 1 and part 2.
