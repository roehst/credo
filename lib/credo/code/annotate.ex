defmodule Credo.Code.Annotate do

  def collect_meta(ast) do
    acc = []
    {_, acc} = Macro.prewalk(ast, acc, &collect_meta/2)
    Enum.reverse acc
  end

  def collect_meta({_op, meta, _args} = ast, acc) do
    {ast, [meta|acc]}
  end

  def collect_meta(ast, acc) do
    {ast, acc}
  end

  def annotate(ast) do
    acc = []
    {ast, _} = Macro.traverse ast, acc, &prewalk/2, &postwalk/2
    ast
  end

  def prewalk({:def, _meta, _args} = ast, acc) do
    ast = update_meta(ast, :syn, :definition)
    {ast, acc}
  end

  def prewalk({name, _meta, nil} = ast, acc) when is_atom(name) do
    ast = update_meta(ast, :syn, :variable)
    {ast, acc}
  end

  def prewalk({name, _meta, args} = ast, acc) when is_atom(name) and is_list(args) do
    ast = update_meta(ast, :syn, :call)
    {ast, acc}
  end  

  def prewalk(ast, acc) do
    {ast, acc}
  end

  def postwalk(ast, acc) do
    {ast, acc}
  end

  def update_meta(ast, key, value) do
    case ast do
      {op, meta, args} ->
        {op, Keyword.put(meta, key, value), args}
      _ -> ast
    end
  end
end