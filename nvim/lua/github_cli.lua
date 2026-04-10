local M = {}

---@class GithubPROptions
---@field title? string Custom title for the PR. If not provided, uses the first commit message that diverged from the default branch.

---Creates a GitHub pull request using the gh CLI
---@param opts? GithubPROptions Options for creating the PR
function M.create_pull_request(opts)
  opts = opts or {}

  -- Get current branch
  local current_branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("\n", "")

  -- Detect the default/main branch
  local default_branch = vim.fn.system("git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@'"):gsub("\n", "")
  if default_branch == "" then
    -- Fallback: try to detect main or master
    default_branch = vim.fn.system("git branch -r | grep -o 'origin/main\\|origin/master' | head -n1 | sed 's@origin/@@'"):gsub("\n", "")
  end
  if default_branch == "" then
    default_branch = "main" -- final fallback
  end

  if current_branch == default_branch then
    print(string.format("Error: Cannot create PR from %s branch", default_branch))
    return
  end

  local pr_title

  if opts.title then
    -- Use the provided title
    pr_title = opts.title
  else
    -- Get the first commit message that diverged from the default branch
    pr_title = vim.fn.system(
      string.format("git log %s..HEAD --format=%%s --reverse | head -n1", default_branch)
    ):gsub("\n", "")

    if pr_title == "" then
      print(string.format("Error: No commits found that diverged from %s", default_branch))
      return
    end
  end

  -- Ask for confirmation
  local confirm = vim.fn.input(string.format(
    "Create PR with title: '%s'? (y/n): ",
    pr_title
  ))

  if confirm:lower() ~= "y" then
    print("PR creation cancelled")
    return
  end

  -- Create the PR with empty body
  local cmd = string.format(
    "gh pr create --title %s --body ''",
    vim.fn.shellescape(pr_title)
  )

  print("Creating PR...")
  local result = vim.fn.system(cmd)
  print(result)
end

---Creates a GitHub pull request with a custom title prompt
---Prompts the user to enter a custom title before creating the PR
function M.create_pull_request_with_custom_title()
  local title = vim.fn.input("Enter PR title: ")

  if title == "" then
    print("PR creation cancelled - no title provided")
    return
  end

  M.create_pull_request({ title = title })
end

return M
