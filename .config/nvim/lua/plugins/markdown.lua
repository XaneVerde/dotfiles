return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      opts.spec = opts.spec or {}

      table.insert(opts.spec, {
        -- Group tools cleanly under <leader>m
        { "<leader>m", group = "convert to pdf" },

        -- 1. Convert Markdown or Code files to PDF via WeasyPrint
        {
          "<leader>mm",
          function()
            vim.cmd("silent! write")
            local infile = vim.fn.expand("%")
            local outfile = vim.fn.expand("%:r") .. ".pdf"
            local ftype = vim.bo.filetype

            local cmd
            if ftype == "markdown" or ftype == "pandoc" then
              -- Regular markdown rendering
              cmd = string.format("pandoc '%s' -o '%s' --pdf-engine=weasyprint", infile, outfile)
            else
              -- If it's a code file (like Lua), treat it as a highlighted block
              cmd = string.format(
                "pandoc '%s' -f commonmark -o '%s' --pdf-engine=weasyprint --metadata title='%s'",
                infile,
                outfile,
                vim.fn.expand("%:t")
              )
            end

            vim.notify("Converting file to PDF...", vim.log.levels.INFO)
            vim.fn.jobstart(cmd, {
              on_exit = function(_, code)
                if code == 0 then
                  vim.notify("PDF created: " .. outfile, vim.log.levels.INFO)
                else
                  vim.notify("Pandoc failed. Check if weasyprint is installed via dnf.", vim.log.levels.ERROR)
                end
              end,
            })
          end,
          desc = "Convert Current File to PDF",
        },

        -- 2. Convert Plain Text (.txt) or Code files to PDF via enscript
        {
          "<leader>mt",
          function()
            vim.cmd("silent! write")
            local infile = vim.fn.expand("%")
            local outfile = vim.fn.expand("%:r") .. ".pdf"

            -- Uses enscript to generate PostScript, then pipes to ghostscript (ps2pdf)
            local cmd = string.format("enscript -p - '%s' | ps2pdf - '%s'", infile, outfile)

            vim.notify("Converting Text file to PDF...", vim.log.levels.INFO)
            vim.fn.jobstart(cmd, {
              on_exit = function(_, code)
                if code == 0 then
                  vim.notify("PDF created: " .. outfile, vim.log.levels.INFO)
                else
                  vim.notify("Text conversion failed. Check enscript/ghostscript.", vim.log.levels.ERROR)
                end
              end,
            })
          end,
          desc = "Convert Plain Text (.txt) to PDF",
        },
      })
    end,
  },
}
