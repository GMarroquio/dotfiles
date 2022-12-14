local Map = require("mapping")
local nnoremap = Map.nnoremap

nnoremap("<leader>.", ":BufferLineCycleNext<CR>", { silent = true })
nnoremap("<leader>,", ":BufferLineCyclePrev<CR>", { silent = true })
nnoremap("gb", ":BufferLinePick<CR>", { silent = true })
nnoremap("gD", ":BufferLinePickClose<CR>", { silent = true })
nnoremap("\\1", ":BufferLineGoToBuffer 1<CR>", { silent = true })
nnoremap("\\2", ":BufferLineGoToBuffer 2<CR>", { silent = true })
nnoremap("\\3", ":BufferLineGoToBuffer 3<CR>", { silent = true })
nnoremap("\\4", ":BufferLineGoToBuffer 4<CR>", { silent = true })
nnoremap("\\5", ":BufferLineGoToBuffer 5<CR>", { silent = true })
nnoremap("\\6", ":BufferLineGoToBuffer 6<CR>", { silent = true })
nnoremap("\\7", ":BufferLineGoToBuffer 7<CR>", { silent = true })
nnoremap("\\8", ":BufferLineGoToBuffer 8<CR>", { silent = true })
nnoremap("\\9", ":BufferLineGoToBuffer 9<CR>", { silent = true })
nnoremap("<leader>c", ":bp<bar>sp<bar>bn<bar>bd<CR>", { silent = true })
nnoremap("<leader>bh", ":BufferLineCloseLeft<CR>", { silent = true })
nnoremap("<leader>bl", ":BufferLineCloseRight<CR>", { silent = true })
nnoremap("<leader>b.", ":BufferLineMoveNext<CR>", { silent = true })
nnoremap("<leader>b,", ":BufferLineMovePrev<CR>", { silent = true })
