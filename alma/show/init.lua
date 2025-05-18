local show_detect_circular
show_detect_circular = function(x, seen)
  if x == nil then
    return 'nil'
  end
end
local show
show = function(x)
  return show_detect_circular(x, { })
end
return {
  show = show
}
