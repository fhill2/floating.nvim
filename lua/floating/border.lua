--local tbl = require('plenary.tbl')

local Border = {}

Border.__index = Border



function Border._create_lines(content_win_options, border_win_options)
  -- TODO: Handle border width, which I haven't right here.
  local thickness = border_win_options.border_thickness

  local top_enabled = thickness.top == 1
  local right_enabled = thickness.right == 1
  local bot_enabled = thickness.bot == 1
  local left_enabled = thickness.left == 1

  local border_lines = {}

  local topline = nil

  local topleft = (left_enabled and border_win_options.topleft) or ''
  local topright = (right_enabled and border_win_options.topright) or ''

  if content_win_options.row > 0 then
    if border_win_options.title then
      local title = border_win_options.title
      if title ~= '' then
        title = string.format(" %s ", title)
      end
      local title_len = string.len(title)

      local midpoint = math.floor(content_win_options.width / 2)
      local left_start = midpoint - math.floor(title_len / 2)

      topline = string.format("%s%s%s%s%s",
        topleft,
        string.rep(border_win_options.top, left_start),
        title,
        string.rep(border_win_options.top, content_win_options.width - title_len - left_start),
        topright
      )
    else
      if top_enabled then
        topline = topleft
          .. string.rep(border_win_options.top, content_win_options.width)
          .. topright
      end
    end
  end

  if topline then
    table.insert(border_lines, topline)
  end

  local middle_line = string.format(
    "%s%s%s",
    (left_enabled and border_win_options.left) or '',
    string.rep(' ', content_win_options.width),
    (right_enabled and border_win_options.right) or ''
  )

  for _ = 1, content_win_options.height do
    table.insert(border_lines, middle_line)
  end

  if bot_enabled then
    table.insert(border_lines,
      string.format(
        "%s%s%s",
        (left_enabled and border_win_options.botleft) or '',
        string.rep(border_win_options.bot, content_win_options.width),
        (right_enabled and border_win_options.botright) or ''
      )
    )
  end

  return border_lines
end


local function transform_content_win_to_border_win_opts(content_win_opts, border_opts)
  local thickness = border_opts.border_thickness

local border_win_opts = {
    anchor = content_win_opts.anchor,
    relative = content_win_opts.relative,
    style = "minimal",
    row = content_win_opts.row - thickness.top,
    col = content_win_opts.col - thickness.left,
    width = content_win_opts.width + thickness.left + thickness.right,
    height = content_win_opts.height + thickness.top + thickness.bot,
    focusable = false
  }
return border_win_opts
end




function Border:new()
local obj = setmetatable({}, Border)
return obj
end





function Border:open(win_self, one_two, single_dual)
local border_opts = win_self[one_two .. '_border_opts']


local content_win_opts
if single_dual == false then
content_win_opts = win_self[one_two .. '_opts']
elseif single_dual == true then
content_win_opts = win_self.total_opts
end

 local bufnr_border = vim.api.nvim_create_buf(false, true)
 win_self.bufnr[one_two .. '_border'] = bufnr_border

 -- assert(obj.bufnr, "Failed to create border buffer")
  vim.api.nvim_buf_set_option(bufnr_border, "bufhidden", "wipe")

 local border_contents = Border._create_lines(content_win_opts, border_opts)
  vim.api.nvim_buf_set_lines(bufnr_border, 0, -1, false, border_contents)



-- lo('border content win opts: ')
-- lo(content_win_options.relative)

local border_win_opts = transform_content_win_to_border_win_opts(content_win_opts, border_opts)


win_self.winnr[one_two .. '_border'] = vim.api.nvim_open_win(bufnr_border, false, border_win_opts)


--win_self.winnr[objorlog .. '_border'] = vim.api.nvim_open_win(win_self.bufnr[objorlog .. '_border'], false, win_self[objorlog .. '_opts'])





end

function Border:refresh(win_self, one_two)

--  obj.contents = Border._create_lines(content_win_options, border_win_options)
--  vim.api.nvim_buf_set_lines(obj.bufnr, 0, -1, false, obj.contents)
-- then nvim win set config instead of nvim win open

end


return Border
