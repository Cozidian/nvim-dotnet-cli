# nvim-dotnet-cli

Add dotnet cli support into Neovim!

## What is this plugin for?

This plugin is for dotnet cli users who want to use Neovim as their IDE.
I have made this primarily for myself, but I hope that it will be useful for others too. Keep in mind that this plugin is still in development as a side project, next to my day job. So it may take some time between updates and bug fixes.

But feel free to open issues, pull requests, or even fork this repo and
make your own version!

## Installation

### Lazy

```lua
return {
    "Cozidian/nvim-dotnet-cli",
    config = function()
        require("nvim-dotnet-cli").setup_key_mappings() -- to setup default key mappings
    end,
}
```
