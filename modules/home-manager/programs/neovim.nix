{
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  home.packages = with pkgs; [
    # formatters
    #alejandra # nix
    black # python
    codespell # generalized spelling errors
    #rustfmt # rust
    prettierd
    #vscode-langservers-extracted # language servers for HTML/CSS/JSON/ESLint
    #kdePackages.qtdeclarative

    ctags # required for tagbar
    ripgrep # required for live grep
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    luaLoader.enable = true;

    colorschemes.one.enable = true;

    #globals.mapleader = "Space";

    globals = {
      neovide_scale_factor = 0.75;
      neovide_transparency = 0.85;
      neovide_fullscreen = false;
      neovide_unlink_border_highlights = false;
      neovide_remember_window_size = false;
    };

    options = {
      number = true;
      relativenumber = true;
      tabstop = 4;
      softtabstop = 4;
      shiftwidth = 4;
      expandtab = true;
      smartindent = true;
      wrap = false;
      #swapfile = false;
      backup = false;
      undodir = "${config.xdg.configHome}/.vim/undodir";
      hlsearch = false;
      incsearch = true;
      termguicolors = true;
      scrolloff = 12;
      signcolumn = "yes";
      updatetime = 50;
      colorcolumn = "120";
      guicursor = "i:ver25-iCursor";
      foldopen = "all";
      foldmethod = "manual";

      completeopt = [
        "menuone"
        "noselect"
        "noinsert"
      ];
    };

    extraConfigLua = ''
      local sign = function(opts)
        vim.fn.sign_define(opts.name, {
          texthl = opts.name,
          text = opts.text,
          numhl = ""
        })
      end

      sign({name = "DiagnosticSignError", text = ""})
      sign({name = "DiagnosticSignWarn", text = ""})
      sign({name = "DiagnosticSignHint", text = ""})
      sign({name = "DiagnosticSignInfo", text = ""})

      vim.diagnostic.config({
          virtual_text = false,
          signs = true,
          update_in_insert = true,
          underline = true,
          severity_sort = false,
          float = {
              border = "rounded",
              source = "always",
              header = "",
              prefix = "",
          },
      })

      vim.cmd('highlight Normal guibg=#171717 ctermbg=none')
    '';

    extraPlugins = with pkgs.vimPlugins; [
      nvim-scrollview
      #ChatGPT-nvim
    ];
    # Can be used for extra plugins
    #++ [
    #  (pkgs.vimUtils.buildVimPlugin {
    #    pname = "";
    #    version = "";
    #    src = pkgs.fetchFromGitHub {
    #      owner = "";
    #      repo = "";
    #      rev = "";
    #      sha256 = "";
    #    };
    #  })
    #];

    plugins = {
      alpha = {
        enable = true; # greeter
        theme = "dashboard";
      };
      emmet = {
        enable = true;
        settings = {
          mode = "n";
          leader_key = ",";
        };
      };
      #auto-save.enable = true;
      auto-session.enable = true;
      barbar.enable = true;
      barbecue.enable = true; # vscode navigation
      better-escape.enable = true;
      #conform-nvim = {
      #  enable = true;
      #  formatOnSave = {};
      #  formattersByFt = {
      #    nix = ["alejandra"];
      #    python = ["black"];
      #    #javascript = [["prettierd" "prettier"]];
      #    rust = ["rustfmt"];
      #    qml = { "qmlformat" };
      #    #"*" = ["codespell"];
      #    "_" = ["trim_whitespace"];
      #  };
      #};
      codeium-nvim.enable = true;

      notify.enable = true;
      floaterm.enable = true;
      wilder.enable = true;
      #hardtime.enable = true;

      crates-nvim.enable = true;
      nix.enable = true;
      nix-develop.enable = true;
      lualine.enable = true;
      telescope.enable = true;
      nvim-lightbulb.enable = true;
      nvim-tree = {
        enable = true;
        openOnSetup = true;
        diagnostics.enable = true;
      };
      undotree.enable = true;
      noice.enable = true;

      none-ls = {
        enable = true;
        sources = {
          diagnostics = {
            qmllint.enable = true;
          };

          formatting = {
            alejandra.enable = true;
            qmlformat.enable = true;
          };
        };
      };

      lsp = {
        enable = true;
        servers = {
          rust-analyzer = {
            enable = true;
            package = null;
            installCargo = false;
            installRustc = false;
          };
          html.enable = true;
          clangd.enable = true;
          lua-ls.enable = true;
          nil-ls.enable = true;
        };
      };
      lsp-format.enable = true;

      cmp-buffer.enable = true;
      cmp-calc.enable = true;
      cmp-git.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-nvim-lsp-signature-help.enable = true;
      cmp-path.enable = true;
      cmp-vsnip.enable = true;

      fugitive.enable = true;
      gitsigns.enable = true;

      # configs todo or made
      tagbar.enable = true;
      todo-comments.enable = true;
      trouble.enable = true;
      indent-blankline.enable = true;
      nvim-autopairs.enable = true;
      surround.enable = true;
      illuminate.enable = true;
      comment.enable = true;

      treesitter = {
        enable = true;
        settings.indent.enable = true;
      };

      cmp = {
        enable = true;
        settings = {
          experimental = {
            ghost_text = true;
          };

          snippet.expand = "vsnip";
          mapping = {
            "<C-p>" = "cmp.mapping.select_prev_item()";
            "<C-n>" = "cmp.mapping.select_next_item()";
            # add tab support
            "<S-Tab>" = "cmp.mapping.select_prev_item()";
            "<Tab>" = "cmp.mapping.select_next_item()";
            "<C-S-f>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.close()";
            "<CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true, })";
          };

          sources = [
            {name = "path";} # file paths
            {name = "codeium";} # source for codeium ai
            {name = "nvim_lsp";} # from language server
            {name = "nvim_lsp_signature_help";} # display function signatures with current parameter emphasized
            {name = "buffer";} # source current buffer
            {name = "vsnip";} # nvim-cmp source for vim-vsnip
            {name = "calc";} # source for math calculation
          ];

          window = {};

          formatting = {
            fields = [
              "menu"
              "abbr"
              "kind"
            ];

            format = ''
              function(entry, item)
                local menu_icon ={
                    nvim_lsp = 'λ',
                    vsnip = '⋗',
                    buffer = 'Ω',
                    path = '🖫',
                    codeium = '',
                }
                item.menu = menu_icon[entry.source.name]
                return item
              end,
            '';
          };
        };
      };
    };

    keymaps = [
      # primeagen mappings
      {
        # keep cursor still when folding lines
        mode = "n";
        key = "J";
        action = "mzJ`z";
      }
      {
        # move selected lines up
        mode = "v";
        key = "J";
        action = ":m '>+1<CR>gv=gv";
      }
      {
        # move selected lines down
        mode = "v";
        key = "K";
        action = ":m '<-2<CR>gv=gv";
      }
      {
        # keep cursor centered while scrolling up
        mode = "n";
        key = "<C-u>";
        action = "<C-u>zz";
      }
      {
        # keep cursor centered while scrolling down
        mode = "n";
        key = "<C-d>";
        action = "<C-d>zz";
      }
      {
        # keep cursor centered when searching next
        mode = "n";
        key = "n";
        action = "nzzzv";
      }
      {
        # keep cursor centered when searching previous
        mode = "n";
        key = "N";
        action = "Nzzzv";
      }

      # tab buffers
      {
        mode = "n";
        key = "<C-h>";
        action = ":BufferFirst<CR>";
      }
      {
        mode = "n";
        key = "<C-l>";
        action = ":BufferLast<CR>";
      }
      {
        mode = "n";
        key = "<C-k>";
        action = ":BufferNext<CR>";
      }
      {
        mode = "n";
        key = "<C-S-K>";
        action = ":BufferMoveNext<CR>";
      }
      {
        mode = "n";
        key = "<C-j>";
        action = ":BufferPrevious<CR>";
      }
      {
        mode = "n";
        key = "<C-S-J>";
        action = ":BufferMovePrevious<CR>";
      }
      {
        mode = "n";
        key = "<C-Tab>";
        action = ":BufferClose<CR>";
      }
      {
        mode = "n";
        key = "<C-e>";
        action = ":NvimTreeToggle<CR>";
      }
      {
        mode = "n";
        key = "<leader>ff";
        action = ":Telescope find_files<CR>";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = ":Telescope live_grep<CR>";
      }
      {
        mode = "n";
        key = "<F8>";
        action = ":TagbarToggle<CR>";
      }
      {
        mode = "n";
        key = "<leader>xx";
        action = "<cmd>Trouble diagnostics toggle<CR>";
      }
      {
        mode = "n";
        key = "<leader>xX";
        action = "<cmd>Trouble diagnostics toggle filter.buf=0<CR>";
      }
      {
        mode = "n";
        key = "<leader>cs";
        action = "<cmd>Trouble symbols toggle focus=false<CR>";
      }
      {
        mode = "n";
        key = "<leader>cl";
        action = "<cmd>Trouble lsp toggle focus=false win.position=r<CR>";
      }
      {
        mode = "n";
        key = "<leader>xL";
        action = "<cmd>Trouble loclist toggle<CR>";
      }
      {
        mode = "n";
        key = "<leader>xQ";
        action = "<cmd>Trouble qflist toggle<CR>";
      }
      {
        mode = "n";
        key = "<F5>";
        action = ":UndotreeToggle<CR>";
      }
      {
        mode = "n";
        key = "<C-t>";
        action = ":FloatermToggle<CR>";
      }
    ];
  };
}
