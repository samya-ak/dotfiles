local status, _ = pcall(require, "onedark")
if not status then
	return
end
vim.cmd.colorscheme("onedark")
