local M = { }
M.Useless = setmetatable({ }, {
  ['@@type'] = 'alma.useless/Useless@1',
  ['@@show'] = function()
    return 'Useless'
  end
})
return M
