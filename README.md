# nvim-dotnet-cli

Add dotnet cli support into Neovim!

## What is this plugin for?

This plugin is for dotnet cli users who want to use Neovim as their IDE.
I have made this primarily for myself, but I hope that it will be useful
for others too. Keep in mind that this plugin is still in development as
a side project, next to my day job. So it may take some time between
updates and bug fixes.

But feel free to open issues, pull requests, or even fork this repo and
make your own version!

## Installation

### Requirements

This plugin leverages the powerful Tree-sitter library for syntax parsing,
providing enhanced functionality specifically designed for C# projects.
To ensure full compatibility and to make use of all features, users must
ensure that both Tree-sitter and the C# language parser are installed and
properly configured within Neovim.

#### Installing Tree-sitter

Tree-sitter is integrated into Neovim 0.5.0 and later. Ensure you are
using a compatible version of Neovim to take advantage of Tree-sitter's
syntax parsing capabilities.

#### Installing the C# Tree-sitter Parser

To install the C# parser, you can use the :TSInstall command
provided by the nvim-treesitter plugin. Follow these steps:

1. Open Neovim.
2. Enter the following command:

```lua
:TSInstall c_sharp
```

### Lazy

```lua
return {
    "Cozidian/nvim-dotnet-cli",
    config = function()
        require("nvim-dotnet-cli").setup_key_mappings() -- to setup default key mappings
    end,
}
```
