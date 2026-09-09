-- Stable ASCII anchors avoid PDF named-destination length warnings.
local header_number = 0
function Header(h)
  header_number = header_number + 1
  h.identifier = string.format('section-%02d', header_number)
  return h
end
function Table(t)
  local n = 0
  for _, body in ipairs(t.bodies) do n = n + #body.body + #body.head end
  if n <= 8 then t.classes:insert('keep-table') end
  -- Let content determine column widths; pipe separator length is not a design choice.
  for _, col in ipairs(t.colspecs) do col[2] = 0 end
  local heading = pandoc.utils.stringify(t.head.rows[1].cells[1].contents)
  if heading == '설명용 사례' then
    t.classes:insert('numeric-examples')
    local widths = {0.37, 0.37, 0.13, 0.13}
    for i, col in ipairs(t.colspecs) do col[2] = widths[i] end
  elseif heading == 'ID' then
    t.classes:insert('source-index')
    local widths = {0.07, 0.40, 0.53}
    for i, col in ipairs(t.colspecs) do col[2] = widths[i] end
  end
  return t
end
