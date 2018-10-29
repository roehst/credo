defmodule Credo.Code.AnnotateTest do
  use Credo.TestHelper

  alias Credo.Code.Annotate

  test "it should" do
    source = """
    def foo(a, b) do
      a + b
    end
    """

    ast = Code.string_to_quoted! source
    ast = Annotate.annotate ast
    meta = Annotate.collect_meta ast
    syn = Enum.map(meta, &Keyword.get(&1, :syn))

    assert syn == [:definition, :call, :variable, :variable, :call, :variable, :variable]

  end
end