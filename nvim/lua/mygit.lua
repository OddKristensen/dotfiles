

local create_pr = function (opts)
  if opts.branch == nil or opts.branch == '' then
    error('No branch to create PR from')
  end
  if opts.message == nil or opts.message == '' then
    error('No commit message to create PR with')
  end
  opts.base = opts.base or 'main'
  opts.body = opts.body or ''

  -- gh pr create --base main --head "$branch_name" --title "$commit_message" --body ""
  local command = 'gh pr create' ..
    ' --base ' .. opts.base ..
    " --head '" .. opts.branch ..
    "' --title '" .. opts.message ..
    "' --body '" .. opts.body .. "'"

  vim.ui.input(
    { prompt = 'OK to run (Y/n)?\n' .. command },
    function (choice)
      if choice == 'y' or choice == 'Y' then
        print(vim.fn.system(command))
        end
    end
  )

end

local escape_single_quotes = function (str)
  return str:gsub("'", "\\'")
end

local get_branch_name = function ()
  return vim.fn.system('git branch --show-current'):gsub('[\r\n]', '')
end

local get_commit_message = function ()
  local message = vim.fn.system('git log -n1 --pretty=format:%s')
  local line = message:match('[^\n]*')
  if line == nil then
    error('There was no commit message')
  end
  return string.gsub(line, '[\r\n]', '')
end

local create_pr_from_branch = function ()
  create_pr {
    branch = get_branch_name(),
    message = escape_single_quotes(get_commit_message()),
  }
end

local M = {
  create_pr_from_branch = create_pr_from_branch,
  get_branch_name = get_branch_name,
}

return M
