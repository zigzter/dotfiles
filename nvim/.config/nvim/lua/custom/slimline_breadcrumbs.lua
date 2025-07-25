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

  -- Simply return the plain text without any highlights
  -- This should blend with slimline's background completely
  return breadcrumbs_string
end

return M
