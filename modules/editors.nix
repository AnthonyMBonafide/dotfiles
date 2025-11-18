{ config, pkgs, lib, ... }:

{
  # Import Neovim configuration
  imports = [
    ./nixvim.nix
  ];

  # Editor and writing tools
  home.packages = with pkgs; [
    # Lua package manager (for Neovim)
    luarocks

    # Linters and formatters
    markdownlint-cli
    # markdown-toc  # May need to be installed via npm
    nodePackages.prettier
    sqlfluff
  ];

  # Helix Editor Configuration
  programs.helix = {
    enable = true;

    settings = {
      theme = lib.mkDefault "onedark";

      keys.insert.j.k = "normal_mode";  # Maps `jk` to exit insert mode
      keys.insert.k.j = "normal_mode";  # Maps `kj` to exit insert mode

      editor = {
        line-number = "relative";
        mouse = false;

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        file-picker = {
          hidden = false;
        };
      };
    };

    languages = {
      language = [
        {
          name = "zig";
          scope = "source.zig";
          injection-regex = "zig";
          file-types = ["zig" "zon"];
          roots = ["build.zig"];
          auto-format = true;
          comment-tokens = ["//" "///" "//!"];
          language-servers = ["zls"];
          indent = { tab-width = 4; unit = "    "; };
          formatter = { command = "zig"; args = ["fmt" "--stdin"]; };
        }
        {
          name = "go";
          scope = "source.go";
          injection-regex = "go";
          file-types = ["go"];
          roots = ["go.work" "go.mod"];
          auto-format = true;
          comment-token = "//";
          block-comment-tokens = { start = "/*"; end = "*/"; };
          language-servers = ["gopls" "golangci-lint-lsp"];
          indent = { tab-width = 4; unit = "\t"; };
        }
        {
          name = "gomod";
          scope = "source.gomod";
          injection-regex = "gomod";
          file-types = [{ glob = "go.mod"; }];
          auto-format = true;
          comment-token = "//";
          language-servers = ["gopls"];
          indent = { tab-width = 4; unit = "\t"; };
        }
        {
          name = "gotmpl";
          scope = "source.gotmpl";
          injection-regex = "gotmpl";
          file-types = ["gotmpl"];
          comment-token = "//";
          block-comment-tokens = { start = "/*"; end = "*/"; };
          language-servers = ["gopls"];
          indent = { tab-width = 2; unit = " "; };
        }
        {
          name = "gowork";
          scope = "source.gowork";
          injection-regex = "gowork";
          file-types = [{ glob = "go.work"; }];
          auto-format = true;
          comment-token = "//";
          language-servers = ["gopls"];
          indent = { tab-width = 4; unit = "\t"; };
        }
      ];

      grammar = [
        { name = "zig"; source = { git = "https://github.com/tree-sitter-grammars/tree-sitter-zig"; rev = "6479aa13f32f701c383083d8b28360ebd682fb7d"; }; }
        { name = "go"; source = { git = "https://github.com/tree-sitter/tree-sitter-go"; rev = "12fe553fdaaa7449f764bc876fd777704d4fb752"; }; }
        { name = "gomod"; source = { git = "https://github.com/camdencheek/tree-sitter-go-mod"; rev = "6efb59652d30e0e9cd5f3b3a669afd6f1a926d3c"; }; }
        { name = "gotmpl"; source = { git = "https://github.com/dannylongeuay/tree-sitter-go-template"; rev = "395a33e08e69f4155156f0b90138a6c86764c979"; }; }
        { name = "gowork"; source = { git = "https://github.com/omertuc/tree-sitter-go-work"; rev = "6dd9dd79fb51e9f2abc829d5e97b15015b6a8ae2"; }; }
        { name = "go-format-string"; source = { git = "https://codeberg.org/kpbaks/tree-sitter-go-format-string"; rev = "06587ea641155db638f46a32c959d68796cd36bb"; }; }
      ];
    };
  };
}
