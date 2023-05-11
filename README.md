<h1 align="center">examples-styler-ex</h1>
</p>
<p align="center">Format elixir code examples in your docs!</p>
<p align="center">
    <a href="https://dev.azure.com/peake100/Peake100/_build?definitionId=21"><img src="https://dev.azure.com/peake100/Peake100/_apis/build/status/examples-styler-ex?repoName=peake100%2examples-styler-ex&branchName=dev" alt="click to see build pipeline"></a>
    <a href="https://dev.azure.com/peake100/Peake100/_build?definitionId=21"><img src="https://img.shields.io/azure-devops/tests/peake100/Peake100/21/dev?compact_message" alt="click to see build pipeline"></a>
    <a href="https://dev.azure.com/peake100/Peake100/_build?definitionId=21"><img src="https://img.shields.io/azure-devops/coverage/peake100/Peake100/21/dev?compact_message" alt="click to see build pipeline"></a>
</p>
<p align="center">
    <a href="https://hex.pm/packages/examples_styler"><img src="https://img.shields.io/hexpm/v/examples_styler.svg" alt="Hex version" height="18"></a>
    <a href="https://hexdocs.pm/examples_styler/readme.html"><img src="https://img.shields.io/badge/docs-hexdocs.pm-blue" alt="Documentation"></a>
</p>

`Mix.Tasks.Format.Examples` is a `Mix.Tasks.Format` plugin to bring the same styling 
rules to your docs!

## Usage

This package implements a `mix format` plugin. Add the following `plugins` value to your 
`.formatter.exs` file:

```elixir
[
  plugins: [Mix.Tasks.Format.Examples],
  inputs: ...
]
```

If you use a non-default plugin like [adobe/elixir-styler](https://github.com/adobe/elixir-styler) to style your code, it will also need to be added:

```elixir
[
  plugins: [Mix.Tasks.Format.Examples, Styler],
  inputs: ...
]
```

Don't forget to add any `.md` or `.cheatmd` files you want examples styled for!

## What gets styled

We follow the same approach as ExUnit doc tests: example code must be prefaced by 
`iex> `.

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
iex> do: a + b
```

```elixir
iex> # Input
iex> def add(a, b),
iex>   do: a + b
```

Any lines prefaced with `iex> ` that are separated in any way will be styled separately.

## Caution is advised

This package is still in very early development; be sure to back up your code before running the formatter!

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `examples_styler` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:examples_styler, "~> 0.2", only: [:dev, :test], runtime: false}
  ]
end
```
