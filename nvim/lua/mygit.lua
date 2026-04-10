

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

---Commits staged changes, pushes to remote, and optionally creates a PR
---If there are no staged changes, skips the commit step
---@param opts table|nil Options table with optional fields: create_pr (boolean, default true)
local print_unstaged_and_untracked = function ()
  -- Get unstaged changes
  local unstaged = vim.fn.system('git diff --name-only')
  -- Get untracked files
  local untracked = vim.fn.system('git ls-files --others --exclude-standard')

  -- Don't print anything if both lists are empty
  if unstaged == '' and untracked == '' then
    return
  end

  print('=== Unstaged files ===')
  if unstaged == '' then
    print('(none)')
  else
    print(unstaged)
  end

  print('\n=== Untracked files ===')
  if untracked == '' then
    print('(none)')
  else
    print(untracked)
  end
end

local commit_push_and_pr = function (opts)
  opts = opts or {}
  local should_create_pr = opts.create_pr
  if should_create_pr == nil then
    should_create_pr = true
  end

  local github_cli = should_create_pr and require('github_cli') or nil

  -- Check if there are staged changes
  local staged = vim.fn.system('git diff --cached --name-only')

  if staged ~= '' then
    -- Prompt for commit message
    vim.ui.input(
      { prompt = 'Enter commit message: ' },
      function (commit_message)
        if not commit_message or commit_message == '' then
          print('Commit cancelled - no message provided')
          return
        end

        -- Commit the staged changes
        local commit_cmd = 'git commit -m ' .. vim.fn.shellescape(commit_message)
        local commit_result = vim.fn.system(commit_cmd)
        print(commit_result)

        -- Check if commit was successful
        if vim.v.shell_error ~= 0 then
          print('Commit failed, aborting')
          return
        end

        -- Push to remote
        local branch = get_branch_name()
        local push_cmd = 'git push -u origin ' .. branch
        print('Pushing to remote...')
        local push_result = vim.fn.system(push_cmd)
        print(push_result)

        -- Check if push was successful
        if vim.v.shell_error ~= 0 then
          print('Push failed, aborting')
          return
        end

        -- Create PR if requested
        if should_create_pr then
          github_cli.create_pull_request()
        end
      end
    )
  else
    -- No staged changes, just push and optionally create PR
    local branch = get_branch_name()
    local push_cmd = 'git push -u origin ' .. branch
    print('Pushing to remote...')
    local push_result = vim.fn.system(push_cmd)
    print(push_result)

    -- Check if push was successful
    if vim.v.shell_error ~= 0 then
      print('Push failed, aborting')
      return
    end

    -- Create PR if requested
    if should_create_pr then
      github_cli.create_pull_request()
    end
  end
end

local M = {
  create_pr_from_branch = create_pr_from_branch,
  get_branch_name = get_branch_name,
  commit_push_and_pr = commit_push_and_pr,
  print_unstaged_and_untracked = print_unstaged_and_untracked,
}

return M
