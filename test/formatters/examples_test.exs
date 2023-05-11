defmodule ExamplesStyler.ExamplesTest do
  @moduledoc false

  use ExUnit.Case

  describe "format/2" do
    setup [:setup_test_case]

    test_cases = [
      %{
        name: "ignored non-example",
        input: ">>> 1 +     1\n",
        expected: ">>> 1 +     1\n"
      },
      %{
        name: "single line",
        input: "iex> 1 +     1\n",
        expected: "iex> 1 + 1\n"
      },
      %{
        name: "preserves indent | spaces",
        input: "    iex> 1 +     1\n",
        expected: "    iex> 1 + 1\n"
      },
      %{
        name: "preserves indent | tabs",
        input: "\t\tiex> 1 +     1\n",
        expected: "\t\tiex> 1 + 1\n"
      },
      %{
        name: "preserves indent | mixed",
        input: "\t  \t   iex> 1 +     1\n",
        expected: "\t  \t   iex> 1 + 1\n"
      },
      %{
        name: "multiple lines",
        input: """
        iex> a =      1
        iex> b = 2
        iex> a +     b
        """,
        expected: """
        iex> a = 1
        iex> b = 2
        iex> a + b
        """
      },
      %{
        name: "removes line",
        input: """
        iex> def add(a + b),
        iex>   do: a + b
        """,
        expected: """
        iex> def add(a + b), do: a + b
        """
      },
      %{
        name: "adds lines",
        input: """
        iex> add(1,
        iex>    2)
        """,
        expected: """
        iex> add(
        iex>   1,
        iex>   2
        iex> )
        """
      },
      %{
        name: "with outputs",
        input: """
        iex> a =     1
        iex> b = 2
        iex> a +   b
        3
        iex> "some text"
        "some text"
        """,
        expected: """
        iex> a = 1
        iex> b = 2
        iex> a + b
        3
        iex> "some text"
        "some text"
        """
      },
      %{
        name: "in code block",
        input: """
        ```elixir
        iex> a =     1
        iex> b = 2
        iex> a +   b
        3
        iex> "some text"
        "some text"
        ```
        """,
        expected: """
        ```elixir
        iex> a = 1
        iex> b = 2
        iex> a + b
        3
        iex> "some text"
        "some text"
        ```
        """
      },
      %{
        name: "with preceding non-example text",
        input: """
        Some example text here.

            iex> a =     1
            iex> b = 2
            iex> a +   b
            3
            iex> "some text"
            "some text"
        """,
        expected: """
        Some example text here.

            iex> a = 1
            iex> b = 2
            iex> a + b
            3
            iex> "some text"
            "some text"
        """
      },
      %{
        name: "with leading, trailing and codeblock",
        input: """
        some text here

        ```elixir
        iex> a =     1
        iex> b = 2
        iex> a +   b
        3
        iex> "some text"
        "some text"
        ```

        more text here
        """,
        expected: """
        some text here

        ```elixir
        iex> a = 1
        iex> b = 2
        iex> a + b
        3
        iex> "some text"
        "some text"
        ```

        more text here
        """
      },
      # grapheme cluster examples taken from: https://unicode.org/reports/tr29/
      %{
        name: "with legacy grapheme clusters",
        input: """
        these are legacy grapheme clusters: ำ กष  ि

        ```elixir
        iex> a =     1
        iex> b = 2
        iex> a +   b
        3
        iex> " ำ กष  ि"
        " ำ กष  ि"
        ```

        more text here
        """,
        expected: """
        these are legacy grapheme clusters: ำ กष  ि

        ```elixir
        iex> a = 1
        iex> b = 2
        iex> a + b
        3
        iex> " ำ กष  ि"
        " ำ กष  ि"
        ```

        more text here
        """
      },
      %{
        name: "with extended grapheme clusters",
        input: """
        these are extended grapheme clusters: நி กำ षि เ

        ```elixir
        iex> a =     1
        iex> b = 2
        iex> a +   b
        3
        iex> "நி กำ षि เ"
        "நி กำ षि เ"
        ```

        more text here
        """,
        expected: """
        these are extended grapheme clusters: நி กำ षि เ

        ```elixir
        iex> a = 1
        iex> b = 2
        iex> a + b
        3
        iex> "நி กำ षि เ"
        "நி กำ षि เ"
        ```

        more text here
        """
      },
      %{
        name: "with tailored grapheme clusters",
        input: """
        these are tailored grapheme clusters: kʷ क्षि ch

        ```elixir
        iex> a =     1
        iex> b = 2
        iex> a +   b
        3
        iex> "kʷ क्षि ch"
        "kʷ क्षि ch"
        ```

        more text here
        """,
        expected: """
        these are tailored grapheme clusters: kʷ क्षि ch

        ```elixir
        iex> a = 1
        iex> b = 2
        iex> a + b
        3
        iex> "kʷ क्षि ch"
        "kʷ क्षि ch"
        ```

        more text here
        """
      },
      %{
        name: "with mixed grapheme clusters",
        input: """
        these are mixed grapheme clusters:  ำ กष  ि | நி กำ षि เ | kʷ क्षि ch

        ```elixir
        iex> a =     1
        iex> b = 2
        iex> a +   b
        3
        iex> " ำ กष  ि | நி กำ षि เ | kʷ क्षि ch"
        " ำ กष  ि | நி กำ षि เ | kʷ क्षि ch"
        ```

        more text here
        """,
        expected: """
        these are mixed grapheme clusters:  ำ กष  ि | நி กำ षि เ | kʷ क्षि ch

        ```elixir
        iex> a = 1
        iex> b = 2
        iex> a + b
        3
        iex> " ำ กष  ि | நி กำ षि เ | kʷ क्षि ch"
        " ำ กष  ि | நி กำ षि เ | kʷ क्षि ch"
        ```

        more text here
        """
      },
      %{
        name: "complex example",
        input: """
        ## Demo

        A small preview of what `Vtc` has to offer. Note that printing statements like
        `inspect/1` have been elided from the examples below.

        `Vtc` can [parse](https://hexdocs.pm/vtc/Vtc.Timecode.html#parse) a number of different
        formats, from timecodes, to frame counts, to film length measured in feet and frames:

        ```elixir
        iex> Timecode.with_seconds!(1.5,
        iex>    Rates.f23_98())
        "<00:05:23:04 <23.98 NTSC>>"
        iex> tc = Timecode.with_frames!("17:23:13:02", Rates.f23_98())
        "<17:23:00:02 <23.98 NTSC>>"
        ```

        Once in a [Timecode](https://hexdocs.pm/vtc/Vtc.Timecode.html) struct, you
        [convert](https://hexdocs.pm/vtc/Vtc.Timecode.html#convert) to any of the supported
        formats:

        ```elixir
        iex>     Timecode.frames(tc)
        1501922
        iex> Timecode.feet_and_frames(tc)
        "<93889+10 :ff35mm_4perf>"
        ```
        """,
        expected: """
        ## Demo

        A small preview of what `Vtc` has to offer. Note that printing statements like
        `inspect/1` have been elided from the examples below.

        `Vtc` can [parse](https://hexdocs.pm/vtc/Vtc.Timecode.html#parse) a number of different
        formats, from timecodes, to frame counts, to film length measured in feet and frames:

        ```elixir
        iex> Timecode.with_seconds!(
        iex>   1.5,
        iex>   Rates.f23_98()
        iex> )
        "<00:05:23:04 <23.98 NTSC>>"
        iex> tc = Timecode.with_frames!("17:23:13:02", Rates.f23_98())
        "<17:23:00:02 <23.98 NTSC>>"
        ```

        Once in a [Timecode](https://hexdocs.pm/vtc/Vtc.Timecode.html) struct, you
        [convert](https://hexdocs.pm/vtc/Vtc.Timecode.html#convert) to any of the supported
        formats:

        ```elixir
        iex> Timecode.frames(tc)
        1501922
        iex> Timecode.feet_and_frames(tc)
        "<93889+10 :ff35mm_4perf>"
        ```
        """
      }
    ]

    @tag test_case: hd(test_cases)
    test "does not recurse when `Styler.Exmaples` present in plugins", context do
      opts = [plugins: [Styler, ExamplesStyler], sigils: [], extension: ".exs", file: "nofile.exs"]

      input = wrap_doc(context.input)
      assert ExamplesStyler.Examples.format(input, opts) == wrap_doc(context.expected)
    end

    @tag test_case: hd(test_cases)
    test "correctly styles when Styler is second", context do
      opts = [plugins: [ExamplesStyler, Styler], sigils: [], extension: ".exs", file: "nofile.exs"]

      input = wrap_doc(context.input)
      assert ExamplesStyler.Examples.format(input, opts) == wrap_doc(context.expected)
    end

    @tag test_case: %{}
    test "correctly formats multiple docstrings" do
      opts = [plugins: [ExamplesStyler, Styler], sigils: [], extension: ".exs", file: "nofile.exs"]

      input = """
      @doc \"\"\"
      iex> 1 +    1
      \"\"\"

      @doc \"\"\"
      iex> 1 +    2
      \"\"\"

      @moduledoc \"\"\"
      iex> 1 +   3
      \"\"\"
      """

      expected = """
      @doc \"\"\"
      iex> 1 + 1
      \"\"\"

      @doc \"\"\"
      iex> 1 + 2
      \"\"\"

      @moduledoc \"\"\"
      iex> 1 + 3
      \"\"\"
      """

      assert ExamplesStyler.Examples.format(input, opts) == expected
    end

    for test_case <- test_cases do
      name = "#{test_case.name} | @doc | .ex"

      @tag test_id: UUID.uuid3(:oid, name)
      @tag test_case: test_case
      test name, context do
        input = wrap_doc(context.input)

        opts = [plugins: [Styler], sigils: [], extension: ".ex", file: "nofile.ex"]
        assert ExamplesStyler.Examples.format(input, opts) == wrap_doc(context.expected)
      end

      name = "#{test_case.name} | @doc | .ex | with indent"

      @tag test_id: UUID.uuid3(:oid, name)
      @tag test_case: test_case
      test name, context do
        input = context.input |> wrap_doc() |> String.split(~r/\n/) |> Enum.map_join("\n", &("\t    " <> &1))
        expected = context.expected |> wrap_doc() |> String.split(~r/\n/) |> Enum.map_join("\n", &("\t    " <> &1))

        opts = [plugins: [Styler], sigils: [], extension: ".ex", file: "nofile.ex"]
        assert ExamplesStyler.Examples.format(input, opts) == expected
      end

      name = "#{test_case.name} | @moduledoc | .ex"

      @tag test_id: UUID.uuid3(:oid, name)
      @tag test_case: test_case
      test name, context do
        input = wrap_moduledoc(context.input)

        opts = [plugins: [Styler], sigils: [], extension: ".ex", file: "nofile.ex"]
        assert ExamplesStyler.Examples.format(input, opts) == wrap_moduledoc(context.expected)
      end

      name = "#{test_case.name} | @typedoc | .ex"

      @tag test_id: UUID.uuid3(:oid, name)
      @tag test_case: test_case
      test name, context do
        input = wrap_moduledoc(context.input)

        opts = [plugins: [Styler], sigils: [], extension: ".ex", file: "nofile.ex"]
        assert ExamplesStyler.Examples.format(input, opts) == wrap_moduledoc(context.expected)
      end

      name = "#{test_case.name} | does not format non-doc"

      @tag test_id: UUID.uuid3(:oid, name)
      @tag test_case: test_case
      test name, context do
        opts = [plugins: [Styler], sigils: [], extension: ".ex", file: "nofile.ex"]
        assert ExamplesStyler.Examples.format(context.input, opts) == context.input
      end

      name = "#{test_case.name} | @doc | .exs"

      @tag test_id: UUID.uuid3(:oid, name)
      @tag test_case: test_case
      test name, context do
        input = wrap_doc(context.input)

        opts = [plugins: [Styler], sigils: [], extension: ".exs", file: "nofile.exs"]
        assert ExamplesStyler.Examples.format(input, opts) == wrap_doc(context.expected)
      end

      name = "#{test_case.name} | @moduledoc | .exs"

      @tag test_id: UUID.uuid3(:oid, name)
      @tag test_case: test_case
      test name, context do
        input = wrap_moduledoc(context.input)

        opts = [plugins: [Styler], sigils: [], extension: ".exs", file: "nofile.exs"]
        assert ExamplesStyler.Examples.format(input, opts) == wrap_moduledoc(context.expected)
      end

      name = "#{test_case.name} | @typedoc | .exs"

      @tag test_id: UUID.uuid3(:oid, name)
      @tag test_case: test_case
      test name, context do
        input = wrap_typedoc(context.input)

        opts = [plugins: [Styler], sigils: [], extension: ".exs", file: "nofile.exs"]
        assert ExamplesStyler.Examples.format(input, opts) == wrap_typedoc(context.expected)
      end

      name = "#{test_case.name} | .md"

      @tag test_id: UUID.uuid3(:oid, name)
      @tag test_case: test_case
      test name, context do
        opts = [plugins: [Styler], sigils: [], extension: ".md", file: "nofile.md"]
        assert ExamplesStyler.Examples.format(context.input, opts) == context.expected
      end

      name = "#{test_case.name} | .cheatmd"

      @tag test_id: UUID.uuid3(:oid, name)
      @tag test_case: test_case
      test name, context do
        opts = [plugins: [Styler], sigils: [], extension: ".md", file: "cheatmd.md"]
        assert ExamplesStyler.Examples.format(context.input, opts) == context.expected
      end
    end
  end

  defp setup_test_case(context), do: context.test_case

  @doc """
  Wrap text in a multiline doc string.
  """
  @spec wrap_doc(String.t()) :: String.t()
  def wrap_doc(text), do: "@doc \"\"\"\n" <> text <> "\n\"\"\"\n"

  @doc """
  Wrap text in a multiline moduledoc string.
  """
  @spec wrap_moduledoc(String.t()) :: String.t()
  def wrap_moduledoc(text), do: "@moduledoc \"\"\"\n" <> text <> "\n\"\"\"\n"

  @doc """
  Wrap text in a multiline typedoc string.
  """
  @spec wrap_typedoc(String.t()) :: String.t()
  def wrap_typedoc(text), do: "@typedoc \"\"\"\n" <> text <> "\n\"\"\"\n"
end
