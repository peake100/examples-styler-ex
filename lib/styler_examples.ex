defmodule Styler.Examples do
  @moduledoc """
  Styles Code examples in ".ex", ".exs", ".md", and ".cheatmd" files
  """
  @behaviour Mix.Tasks.Format

  alias Styler.Examples.MultiPlugin

  @typedoc false
  @typep format_opts() :: [
           {:extension, String.t()}
           | {:file, Path.t()}
           | {:plugins, [module()]}
           | {:sigils, [atom()]}
           | {:inputs, [String.t()]}
           | {atom(), any()}
         ]

  # Regex index match on a code example.
  @typep regex_index() :: [{non_neg_integer(), non_neg_integer()}]

  # Tags for a span of input text.
  @typep span_type() :: :code_example | :other

  # Tagged length of input text.
  @typep span_length() :: {span_type(), non_neg_integer()}

  # Tagged section of input text.
  @typep span() :: {span_type(), String.t()}

  @doc false
  @impl Mix.Tasks.Format
  @spec features(format_opts()) :: [sigils: [atom()], extensions: [String.t()]]
  def features(_opts), do: [sigils: [], extensions: [".ex", ".exs", ".md", ".cheatmd"]]

  @code_example_regex ~r/(?>^(?>[\t ]*iex>.*$)(?>{\r\n|\n|\r})?)+/m

  @doc false
  @impl Mix.Tasks.Format
  @spec format(String.t(), format_opts()) :: String.t()
  def format(input, opts) do
    example_indexes = Regex.scan(@code_example_regex, input, return: :index)
    span_lengths = calculate_spans(input, example_indexes)

    input
    |> split_spans(span_lengths)
    |> Enum.map(fn
      {:code_example, example_string} -> reformat_example(example_string, opts)
      {:other, other_string} -> other_string
    end)
    |> List.to_string()
  end

  # Created a list of contiguous character lengths and string types for example and
  # non-example code.
  @spec calculate_spans(String.t(), [regex_index()]) :: [span_length()]
  defp calculate_spans(input, example_indexes) do
    example_indexes
    |> Enum.map(fn [{_, _} = index] -> index end)
    |> Enum.reduce({0, []}, fn {start, length}, {cursor, spans} ->
      pre_example = start - cursor
      example = length

      spans = [{:other, pre_example} | spans]
      spans = [{:code_example, example} | spans]

      {cursor + pre_example + example, spans}
    end)
    |> then(fn {cursor, spans} ->
      final_span = byte_size(input) - cursor
      [{:other, final_span} | spans]
    end)
    |> Enum.reverse()
  end

  # Split the input string into alternating example and non-example strings.
  @spec split_spans(String.t(), [span_length()]) :: [span()]
  defp split_spans(input, span_lengths) do
    span_lengths
    |> Enum.reduce({0, []}, fn {type, length}, {cursor, span_strings} ->
      span_string = binary_part(input, cursor, length)

      {cursor + length, [{type, span_string} | span_strings]}
    end)
    |> then(fn {_, span_strings} -> span_strings end)
    |> Enum.reverse()
  end

  # Reformats a single example.
  @spec reformat_example(String.t(), format_opts()) :: String.t()
  defp reformat_example(example, opts) do
    [indent] = Regex.run(~r/^[\t ]*/, example)

    # We need to remove the current formatter from the list to avoid recursively calling
    # this funciton, and update the extension to ".exs" so that we trigger the correct
    # formatters, even if we are in a markdown file.
    opts =
      opts
      |> Keyword.update(:plugins, [], &List.delete(&1, __MODULE__))
      |> Keyword.put(:extension, ".exs")

    prompt = indent <> "iex> "

    example
    |> String.replace(~r/^[ \t]*iex>[ \t]*/m, "")
    |> MultiPlugin.format(opts)
    |> String.replace(~r/^/m, prompt)
    |> String.trim_trailing(prompt)
  end
end
