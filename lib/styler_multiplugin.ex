defmodule Styler.Examples.MultiPlugin do
  @moduledoc false
  @behaviour Mix.Tasks.Format

  @impl Mix.Tasks.Format

  @spec features(Keyword.t()) :: [sigils: [atom()], extensions: [String.t()]]
  def features(opts) do
    [Styler, Styler.Examples]
    |> Enum.reduce([sigils: [], extensions: []], fn formatter, features ->
      formatter_features = formatter.features(opts)
      formatter_sigils = Keyword.get(formatter_features, :sigils)
      formatter_extensions = Keyword.get(formatter_features, :extensions)

      features
      |> Keyword.update(:sigils, formatter_sigils, fn sigils ->
        Enum.concat(sigils, formatter_sigils)
      end)
      |> Keyword.update(:extensions, formatter_extensions, fn extensions ->
        Enum.concat(extensions, formatter_extensions)
      end)
    end)
    |> Keyword.update(:sigils, [], &Enum.uniq(&1))
    |> Keyword.update(:extensions, [], &Enum.uniq(&1))
  end

  @impl Mix.Tasks.Format
  @spec format(String.t(), Keyword.t()) :: String.t()
  def format(input, opts) do
    sigils = opts |> Keyword.fetch!(:sigils) |> MapSet.new()
    extension = Keyword.fetch!(opts, :extension)

    Enum.reduce([Styler, Styler.Examples], input, fn plugin, input ->
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
