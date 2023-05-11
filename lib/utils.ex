defmodule ExamplesStyler.Utils do
  @moduledoc false

  @typedoc false
  @type format_opts() :: [
          {:extension, String.t()}
          | {:file, Path.t()}
          | {:plugins, [module()]}
          | {:sigils, [atom()]}
          | {:inputs, [String.t()]}
          | {atom(), any()}
        ]

  @doc """
  Finds the first plugin that should be used for formatting elixir code based on `opts`.
  """
  @spec find_elixir_formatter(format_opts()) :: module()
  def find_elixir_formatter(opts) do
    opts
    |> Keyword.fetch!(:plugins)
    |> Enum.reject(&(&1 in [ExamplesStyler, ExamplesStyler.Examples]))
    |> Enum.find(ExamplesStyler.Default, &is_elixir_plugin?(&1, opts))
  end

  @spec is_elixir_plugin?(module(), format_opts()) :: boolean()
  defp is_elixir_plugin?(plugin, opts) do
    elixir_extensions = MapSet.new([".ex", ".exs"])

    plugins_extensions = opts |> plugin.features() |> Keyword.fetch!(:extensions) |> MapSet.new()
    not MapSet.disjoint?(plugins_extensions, elixir_extensions)
  end
end
