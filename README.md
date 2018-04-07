# Tracker

An implementation of the global data-association algorithm described here:  
[Global Data Association for Multi-Object Tracking Using Network Flows (Zhang, Li, Nevatia 2008)](http://vision.cse.psu.edu/courses/Tracking/vlpr12/lzhang_cvpr08global.pdf)

## TODO:
 * Review code status, tests, and overall algorithm structure. What is missing for basic testing?
 * Look up the 'scaling push-relabel method' described by A. V. Goldberg, An efficient implementation of a scaling minimum-cost algorithm

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `tracker` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:tracker, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/tracker](https://hexdocs.pm/tracker).
