defmodule Mix.Tasks.Format.Default do
  @moduledoc false
  @behaviour Mix.Tasks.Format

  alias Mix.Tasks.Format

  @typedoc false
  @type format_opts() :: [
          {:extension, String.t()}
          | {:file, Path.t()}
          | {:plugins, [module()]}
          | {:sigils, [atom()]}
          | {:inputs, [String.t()]}
          | {atom(), any()}
        ]

  @doc false
  @impl Format
  @spec features(format_opts()) :: [sigils: [atom()], extensions: [String.t()]]
  def features(_opts), do: [sigils: [], extensions: [".ex", ".exs"]]

  @doc false
  @impl Format
  @spec format(String.t(), format_opts()) :: String.t()
  def format(input, opts) do
    case Code.format_string!(input, opts) do
      [] -> ""
      formatted -> IO.iodata_to_binary([formatted, ?\n])
    end
  end
end
