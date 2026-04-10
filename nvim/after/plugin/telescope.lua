local telescope = require('telescope')
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
  builtin.grep_string({ search = vim.fn.input("Grep > ")})
end)

vim.api.nvim_create_autocmd(
  'FileType',
  {
    pattern = 'TelescopeResults',
    callback = function (context)
      vim.api.nvim_buf_call(
        context.buf,
        function ()
          vim.fn.matchadd('TelescopeFilename', '^.*\t\t')
          vim.api.nvim_set_hl(0, 'TelescopeFilename', { link = 'Directory' })
          vim.fn.matchadd('TelescopeParent', '\t\t.*$')
          vim.api.nvim_set_hl(0, 'TelescopeParent', { link = 'Question' })
        end
      )
    end
  }
)

local reversePath = function(path)
  if path == '.' then return path end
  local tokens = {}
  for token in string.gmatch(path, '[^/]+') do
    tokens[#tokens + 1] = token
  end
  local i = #tokens
  local reversedPath = tokens[i]
  while (i > 1) do
    i = i - 1
    reversedPath = reversedPath .. '\\' .. tokens[i]
  end
  return reversedPath
end

local filenameFirst = function (order)
  return function (_, path)
    local filename = vim.fs.basename(path)
    local rest
    if order == 'reverse' then
      rest = reversePath(vim.fs.dirname(path))
    else
      local r = vim.fs.dirname(path)
      if r == '.' then
        rest = path
      else
        rest = r
      end
    end
    return string.format('%s\t\t%s', filename, rest)
  end
end

local reversedAndWidePath = {
  -- path_display = filenameFirst('reverse'),
  fname_width = 50,
}

-- Helm-style sorter: spaces match any sequence of characters
local function helm_sorter()
  local fzy = require('telescope.algos.fzy')
  local sorters = require('telescope.sorters')

  return sorters.Sorter:new {
    scoring_function = function(_, prompt, line)
      if prompt == '' then
        return 0
      end

      -- If no spaces, use regular fzy scoring (fast path)
      if not prompt:find('%s') then
        return fzy.score(prompt, line) or -1
      end

      -- Split prompt into words
      local words = {}
      for word in prompt:gmatch('%S+') do
        table.insert(words, word)
      end

      -- Quick regex pre-filter: check if all words exist in order
      -- Build a pattern like "conver.*spanner.*main"
      local pattern = table.concat(vim.tbl_map(function(w)
        return vim.pesc(w:lower())
      end, words), '.*')

      if not line:lower():find(pattern) then
        return -1
      end

      -- Now do detailed fzy scoring
      local pos = 1
      local total_score = 0

      for _, word in ipairs(words) do
        local remaining = line:sub(pos)
        local score = fzy.score(word, remaining)

        if not score or score == -1/0 then
          return -1
        end

        -- Find the actual position where the word matched
        local positions = fzy.positions(word, remaining)
        if positions and #positions > 0 then
          pos = pos + positions[#positions]
          total_score = total_score + score
        else
          return -1
        end
      end

      -- Average the scores
      return total_score / #words
    end,

    highlighter = function(_, prompt, display)
      return fzy.positions(prompt, display)
    end,
  }
end

telescope.setup {
  defaults = {
    layout_strategy = 'vertical',
  },
  extensions = {
    fzf = {},
    project = {
      base_dirs = {
        '~/projects',
      },
    },
  },
  pickers = {
    find_files = {
      follow = true,
      path_display = {'filename_first'},
      -- path_display = {'truncate'},
      -- path_display = filenameFirst(),
    },
    lsp_references = reversedAndWidePath,
    lsp_implementations = reversedAndWidePath,
    lsp_incoming_calls = reversedAndWidePath,
    lsp_outgoing_calls = reversedAndWidePath,
  },
}

-- Previews for all temporary buffers
-- telescope.load_extension('attempt')

-- Use different sorter
telescope.load_extension('fzf')

