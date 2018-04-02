# Tracker

An implementation of the global data-association algorithm described here:  
[Global Data Association for Multi-Object Tracking Using Network Flows (Zhang, Li, Nevatia 2008)](http://vision.cse.psu.edu/courses/Tracking/vlpr12/lzhang_cvpr08global.pdf)

## TODO:
 * Write tests for Graph, Arc, AlgorithmState
 * Implement global cost calculation
 * Implement min-cost flow calculation
 * Implement basic iterative algorithm (no occlusion model)

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
