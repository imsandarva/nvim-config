return {
  'nvim-tree/nvim-web-devicons',
  lazy = false,
  config = function()
    require('nvim-web-devicons').setup {
      -- Enable default icons
      default = true,
      -- Enable strict mode
      strict = true,
      -- Override default icons
      override = {
        -- Python files
        py = {
          icon = "🐍",
          color = "#3776ab",
          name = "Python"
        },
        -- Image files
        jpg = {
          icon = "🖼️",
          color = "#ff6b6b",
          name = "JPG"
        },
        png = {
          icon = "🖼️",
          color = "#4ecdc4",
          name = "PNG"
        },
        -- Text files
        txt = {
          icon = "📄",
          color = "#95e1d3",
          name = "Text"
        },
        -- Git files
        gitignore = {
          icon = "📝",
          color = "#f38181",
          name = "GitIgnore"
        },
        -- Python init files
        ['__init__.py'] = {
          icon = "🐍",
          color = "#3776ab",
          name = "PythonInit"
        },
        -- Requirements files
        requirements = {
          icon = "📦",
          color = "#ffa726",
          name = "Requirements"
        },
        -- Manage files
        manage = {
          icon = "⚙️",
          color = "#42a5f5",
          name = "Manage"
        }
      }
    }
  end
}
