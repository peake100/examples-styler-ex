defmodule Mix.Tasks.Format.Examples.Formatter do
  @moduledoc """
  Styles Code examples in ".ex", ".exs", ".md", and ".cheatmd" files
  """
  @behaviour Mix.Tasks.Format

  alias Mix.Tasks.Format

  @typep format_opts() :: Format.Default.format_opts()

  # Regex index match on a code example.
  @typep regex_index() :: [{non_neg_integer(), non_neg_integer()}]

  # Tags for a span of input text.
  @typep span_type() :: :code_example | :other

  # Tagged length of input text.
  @typep span_length() :: {span_type(), non_neg_integer()}

  # Tagged section of input text.
  @typep span() :: {span_type(), String.t()}

  @doc false
  @impl Format
  @spec features(format_opts()) :: [sigils: [atom()], extensions: [String.t()]]
  def features(_opts), do: [sigils: [], extensions: [".ex", ".exs", ".md", ".cheatmd"]]

  @docs_regex ~r/(?>@doc|@moduledoc|@typedoc)\s*""".*"""/msU
  @code_example_regex ~r/(?>^(?>[\t ]*iex>.*$)(?>{\r\n|\n|\r})?)+/m

  @doc false
  @impl Format
  @spec format(String.t(), format_opts()) :: String.t()
  def format(input, opts) do
    elixir_plugin = find_elixir_formatter(opts)
    extension = Keyword.fetch!(opts, :extension)

    docs_indexes =
      if extension in [".ex", ".exs"] do
        Regex.scan(@docs_regex, input, return: :index)
      else
        [[{0, byte_size(input)}]]
      end

    example_indexes = Regex.scan(@code_example_regex, input, return: :index)
    span_lengths = calculate_spans(input, example_indexes, docs_indexes)

    input
    |> split_spans(span_lengths)
    |> Enum.map(fn
      {:code_example, example_string} -> reformat_example(example_string, elixir_plugin, opts)
      {:other, other_string} -> other_string
    end)
    |> IO.iodata_to_binary()
  end

  # Created a list of contiguous character lengths and string types for example and
  # non-example code.
  @spec calculate_spans(String.t(), [regex_index()], [regex_index()] | nil) :: [span_length()]
  defp calculate_spans(input, example_indexes, docs_indexes) do
    example_indexes
    |> Enum.map(fn [{_, _} = index] -> index end)
    |> Enum.filter(fn {example_start, example_length} ->
      example_end = example_start + example_length

      Enum.any?(docs_indexes, fn [{doc_start, doc_length}] ->
        doc_end = doc_start + doc_length
        example_start >= doc_start and example_end <= doc_end
      end)
    end)
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
  @spec reformat_example(String.t(), module(), format_opts()) :: String.t()
  defp reformat_example(example, elixir_plugin, opts) do
    [indent] = Regex.run(~r/^[\t ]*/, example)

    prompt = indent <> "iex> "

    example
    |> String.replace(~r/^[ \t]*iex>[ \t]*/m, "")
    |> elixir_plugin.format(opts)
    |> String.replace(~r/^/m, prompt)
    |> String.trim_trailing(prompt)
  end

  @spec find_elixir_formatter(format_opts()) :: module()
  def find_elixir_formatter(opts) do
    opts
    |> Keyword.fetch!(:plugins)
    |> Enum.reject(&(&1 in [__MODULE__, Format.Examples]))
    |> Enum.find(Format.Default, &is_elixir_plugin?(&1, opts))
  end

  @spec is_elixir_plugin?(module(), format_opts()) :: boolean()
  def is_elixir_plugin?(plugin, opts) do
    elixir_extensions = MapSet.new([".ex", ".exs"])

    plugins_extensions = opts |> plugin.features() |> Keyword.fetch!(:extensions) |> MapSet.new()
    not MapSet.disjoint?(plugins_extensions, elixir_extensions)
  end
end
