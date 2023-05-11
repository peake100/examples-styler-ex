defmodule ExamplesStyler.Default do
  @moduledoc false

  @behaviour Mix.Tasks.Format

  alias ExamplesStyler.Utils
  alias Mix.Tasks.Format

  @doc false
  @impl Format
  @spec features(Utils.format_opts()) :: [sigils: [atom()], extensions: [String.t()]]
  def features(_opts), do: [sigils: [], extensions: [".ex", ".exs"]]

  @doc false
  @impl Format
  @spec format(String.t(), Utils.format_opts()) :: String.t()
  def format(input, opts) do
    case Code.format_string!(input, opts) do
      [] -> ""
      formatted -> IO.iodata_to_binary([formatted, ?\n])
    end
  end
end
