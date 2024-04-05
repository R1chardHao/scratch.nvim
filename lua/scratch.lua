local filetype_alias = {
  js = "javascript"
}

local Scratch = {};

Scratch.buffers = nil;

local function close_scratch_window()
  require("scratch").close_window();
end

function Scratch.create_buffer(filetype)
  local name = "__scratch__";
  if filetype ~= nil then
    name = "__scratch_" .. filetype .. "__";
  end

  if Scratch.buffers[name] ~= nil then
    return Scratch.buffers[name];
  end

  local buf = vim.api.nvim_create_buf(false, true);
  Scratch.buffers[name] = buf;
  vim.api.nvim_buf_set_name(buf, name);
  vim.api.nvim_buf_set_var(buf, "scratch_name", name);
  if filetype ~= nil then
    local ft = filetype;
    if filetype_alias[filetype] ~= nil then
      ft = filetype_alias[filetype];
    end
    vim.api.nvim_set_option_value("filetype", ft, { buf = buf });
  end

  vim.keymap.set("n", "q", function ()
    close_scratch_window();
  end, {buffer = buf});

  vim.keymap.set("n", "<Esc>", function ()
    close_scratch_window();
  end, {buffer = buf});

  vim.api.nvim_create_autocmd("BufUnload", {
    buffer = buf,
    callback = function ()
      Scratch.buffers[name] = nil;
    end,
  })

  return buf;
end

function Scratch.create_window(bufnr)
  local screen_width = vim.opt.columns:get()
  local screen_height = vim.opt.lines:get() - vim.opt.cmdheight:get()
  local width_ratio = 0.7;
  local height_ratio = 0.6;
  local width = math.floor(screen_width * width_ratio);
  local height = math.floor(screen_height * height_ratio);
  local win_opt = {
    title = "Scratch",
    relative = "win",
    style = "minimal",
    border = "single",
    width = width,
    height = height,
    row = (screen_height - height) / 2 - 1,
    col = (screen_width - width) / 2,
  }
  Scratch.win_id = vim.api.nvim_open_win(bufnr, true, win_opt);
end

function Scratch.close_window()
  vim.api.nvim_win_close(Scratch.win_id, {});
  Scratch.win_id = nil;
end

function Scratch.create_scratch(filetype)
  local buf = Scratch.create_buffer(filetype);
  Scratch.create_window(buf);
end

---In case of any accident the plugin is reloaded, find all existing scratch buffers.
local function init_buffers()
  Scratch.buffers = {};
  local handlers = vim.api.nvim_list_bufs();
  for _, bufnr in ipairs(handlers) do
    local success, scratch_name = pcall(vim.api.nvim_buf_get_var, bufnr, "scratch_name");
    if success then
      Scratch.buffers[scratch_name] = bufnr;
    end
  end
end

local function create_autocmd()
  vim.api.nvim_create_user_command("Scratch", function (opts)
    local filetype = opts.fargs[1];
    Scratch.create_scratch(filetype);
  end, { nargs = "?" });
end

function Scratch.setup()
  init_buffers();
  create_autocmd();
end


return Scratch;
