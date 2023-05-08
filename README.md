<h1 align="center">examples-styler-ex</h1>
</p>
<p align="center">Use Styler on elixir code examples in your docs!</p>
<p align="center">
    <a href="https://dev.azure.com/peake100/Peake100/_build?definitionId=20"><img src="https://dev.azure.com/peake100/Peake100/_apis/build/status/examples-styler-ex?repoName=peake100%2examples-styler-ex&branchName=dev" alt="click to see build pipeline"></a>
    <a href="https://dev.azure.com/peake100/Peake100/_build?definitionId=20"><img src="https://img.shields.io/azure-devops/tests/peake100/Peake100/20/dev?compact_message" alt="click to see build pipeline"></a>
    <a href="https://dev.azure.com/peake100/Peake100/_build?definitionId=20"><img src="https://img.shields.io/azure-devops/coverage/peake100/Peake100/20/dev?compact_message" alt="click to see build pipeline"></a>
</p>
<p align="center">
    <a href="https://hex.pm/packages/example"><img src="https://img.shields.io/hexpm/v/vtc.svg" alt="PyPI version" height="18"></a>
    <a href="https://hexdocs.pm/vtc/readme.html"><img src="https://img.shields.io/badge/docs-hexdocs.pm-blue" alt="Documentation"></a>
</p>

## Usage

Example Styler relies on [adobe/elixir-styler](https://github.com/adobe/elixir-styler),
and acts as an extension to bring the same styling rules to your docs!

Add the following `plugins` value to your `.formatter.exs` file:

```elixir
[
  plugins: [Styler.Examples.MultiPlugin],
  inputs: ...
]
```

There is no need to add `Styler` itself. By default, `mix format` will only run one 
plugin per file; `Styler.MultiPlugin` handles running both `Styler` and 
`Styler.Examples` on `.exs` and `.ex` files.

It will also run `Styler.Examples` `.mo` and `.cheatmd files`.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `vtc` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:examples_styler, "~> 0.1"}
  ]
end
```