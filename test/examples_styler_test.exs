defmodule ExamplesStylerTest do
  @moduledoc false

  use ExUnit.Case

  describe "#features/1" do
    test "returns correct extensions" do
      features = ExamplesStyler.features([])
      extensions = features |> Keyword.fetch!(:extensions) |> MapSet.new()

      assert MapSet.equal?(extensions, MapSet.new([".ex", ".exs", ".md", ".cheatmd"]))
    end

    test "uses styler when passed" do
      opts = [plugins: [Styler, ExamplesStyler], sigils: [], extension: ".md", file: "nofile.md"]

      input = """
      iex> def add(a, b),
      iex>   do: a +     b
      """

      expected = """
      iex> def add(a, b), do: a + b
      """

      assert ExamplesStyler.format(input, opts) == expected
    end

    test "uses default when no plugin passed" do
      opts = [plugins: [ExamplesStyler], sigils: [], extension: ".md", file: "nofile.md"]

      input = """
      iex> 1 +    1

      something something

      iex> def add(a, b),
      iex>   do: a +      b
      """

      expected = """
      iex> 1 + 1

      something something

      iex> def add(a, b),
      iex>   do: a + b
      """

      assert ExamplesStyler.format(input, opts) == expected
    end
  end
end
