
local function branch_name()
	local branch = vim.fn.system("git branch --show-current 2> /dev/null | tr -d '\n'")
	if branch ~= "" then
		return branch
	else
		return ""
	end
end

local function branch_tail()
  local branch_terms = vim.split(branch_name(), "/")

  return branch_terms[#branch_terms]
end

local function copy_branch_tail()
  local tail = branch_tail()

  if tail ~= "" then
    vim.fn.setreg('+', tail)
  end
end

local M = {
  branch_name = branch_name,
  branch_tail = branch_tail,
  copy_branch_tail = copy_branch_tail,
}

return M
