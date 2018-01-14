----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：数据配置
----------------------------------------------------------------------

local M = class("SCSound", GameObject)

function M:onCreate()

end

function M:fullPath(str)
    return "games/fish/assets/sound/" .. str .. ".mp3"
end

function M:playSound(filename)
    filename = self:fullPath(filename)
    PlaySound(filename)
end

function M:playMusic(filename)
    filename = self:fullPath(filename)
    PlayMusic(filename)
end

return M