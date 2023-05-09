<h1 align="center">examples-styler-ex</h1>
</p>
<p align="center">Use Styler on elixir code examples in your docs!</p>
<p align="center">
    <a href="https://dev.azure.com/peake100/Peake100/_build?definitionId=21"><img src="https://dev.azure.com/peake100/Peake100/_apis/build/status/examples-styler-ex?repoName=peake100%2examples-styler-ex&branchName=dev" alt="click to see build pipeline"></a>
    <a href="https://dev.azure.com/peake100/Peake100/_build?definitionId=21"><img src="https://img.shields.io/azure-devops/tests/peake100/Peake100/21/dev?compact_message" alt="click to see build pipeline"></a>
    <a href="https://dev.azure.com/peake100/Peake100/_build?definitionId=21"><img src="https://img.shields.io/azure-devops/coverage/peake100/Peake100/21/dev?compact_message" alt="click to see build pipeline"></a>
</p>
<p align="center">
    <a href="https://hex.pm/packages/examples_styler"><img src="https://img.shields.io/hexpm/v/examples_styler.svg" alt="Hex version" height="18"></a>
    <a href="https://hexdocs.pm/examples_styler/readme.html"><img src="https://img.shields.io/badge/docs-hexdocs.pm-blue" alt="Documentation"></a>
</p>

`Styler.Examples` is an extension for [adobe/elixir-styler](https://github.com/adobe/elixir-styler) that styles code examples in your docstrings and markdown files!

## Usage

This package implements a `mix format` plugin. Add the following `plugins` value to your `.formatter.exs` file:

```elixir
[
  plugins: [Styler.Examples.MultiPlugin],
  inputs: ...
]
```

Although it is also a plugin, `Styler` itself should not be added. `mix format` will only run one plugin per file, so if both `Styler` and `Styler.Examples` are present, only the one listed first will be run for `.ex` and `.exs` files. `Styler.MultiPlugin` handles running both `Styler` and `Styler.Examples` on those files in sequence.

`Styler.Examples` will also be run on any `.md` and `.cheatmd` files returned by your `:input` filters. Be sure to add your README of you want your examples styled!

## What gets styled

We follow the same approach as ExUnit doc tests: example code must be prefaced by `iex> `.

```elixir
iex> # Input
iex> 1 +     1
```

```elixir
iex> # Output
iex> 1 + 1
```

Code found on contiguous lines is styled together:

```elixir
iex> # Input
iex> def add(a, b),
iex>   do: a + b
```

```elixir
iex> # Output
iex> def add(a, b), do: a + b
```

Any lines prefaced with `iex> ` that are separated in any way will be styled separately.

## Approach and Limitations

This package is still in very early development; be sure to back up your code before running the formatter.

Our current approach simply finds any lines starting with `iex> ` via regex and styles those. It ignores considerations of context, such code blocks or `@doc` attributes. Be warned that the formatter will execute on ANY lines that fit this criteria, like multi-line strings which start with `iex>`, for instance the inputs for our own test suite!

As a starting approach, we suspect this will be fine for the vast majority of projects. However, if it does cause issues for your particular code, please open a ticket with steps to re-create the issue and we'll take a look!

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `examples_styler` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:examples_styler, "~> 0.1", only: [:dev, :test], runtime: false}
  ]
end
```
