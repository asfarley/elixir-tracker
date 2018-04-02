defmodule Graph do
  defstruct nodes: [], arcs: []

  @type graph :: %Graph{
          nodes: list(atom()),
          arcs: list(Arc.arc())
        }
end
