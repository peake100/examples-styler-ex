defmodule ExamplesStyler do
  @moduledoc """
  Styles code examples in ".ex", ".exs", ".md", and ".cheatmd" files. Add to `:plugins`
  value of your `.formatter.exs` file.
  """

  @behaviour Mix.Tasks.Format

  alias ExamplesStyler.Utils
  alias Mix.Tasks.Format

  @doc false
  @impl Format
  @spec features(Utils.format_opts()) :: [sigils: [atom()], extensions: [String.t()]]
  def features(_), do: [sigils: [], extensions: [".ex", ".exs", ".md", ".cheatmd"]]

  @doc false
  @impl Format
  @spec format(String.t(), Utils.format_opts()) :: String.t()
  def format(input, opts) do
    sigils = opts |> Keyword.fetch!(:sigils) |> MapSet.new()
    extension = Keyword.fetch!(opts, :extension)

    elixir_plugin = Utils.find_elixir_formatter(opts)

    Enum.reduce([elixir_plugin, ExamplesStyler.Examples], input, fn plugin, input ->
      features = plugin.features(opts)
      plugin_sigils = features |> Keyword.fetch!(:sigils) |> MapSet.new()
      plugin_extensions = Keyword.fetch!(features, :extensions)

      if extension in plugin_extensions or not MapSet.disjoint?(sigils, plugin_sigils) do
        plugin.format(input, opts)
      else
        input
      end
    end)
  end
end
