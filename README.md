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

## Usage

`Examples Styler` relies on [adobe/elixir-styler](https://github.com/adobe/elixir-styler),
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

It will also run `Styler.Examples` `.md` and `.cheatmd` files.

## Approach and Limitations

This package is still in very early development, and as such, make sure that you do not
run it on any code that is not backed up.

THe current approach is to simply find any contiguous lines that start with `iex> ` via
regex and styling those, ignoring considerations of context, such as code blocks or 
`@doc` attributes.

This approach may catch things like multi-line strings that start with `iex>`, such as
appear in the tests for this module! As a starting approach, we feel that this should be
fine for the vast majority of projects, however, if it does happen to cause issues for 
your particular code, please open a ticket with steps to re-create the issue and we'll
take a look!

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