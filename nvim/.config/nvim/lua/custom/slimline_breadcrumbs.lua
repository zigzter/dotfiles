local M = {}

function M.get_navic_breadcrumbs()
  -- Check if nvim-navic is loaded and active
  if not pcall(require, 'nvim-navic') then
    return ''
  end

  local navic = require('nvim-navic')

  local breadcrumbs_string = navic.get_location()
  if breadcrumbs_string == nil or breadcrumbs_string == '' then
    return ''
  end

  -- Limit breadcrumbs to max characters (adjust this value as needed)
  local max_length = 80
  if #breadcrumbs_string > max_length then
    breadcrumbs_string = '...' .. breadcrumbs_string:sub(-(max_length - 3))
  end

  return breadcrumbs_string
end

return M
