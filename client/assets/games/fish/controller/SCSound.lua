----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：数据配置
----------------------------------------------------------------------

local M = class("SCSound", u3a.GameObject)

function M:onCreate()

end

function M:fullPath(str)
    return "games/fish/assets/sound/" .. str .. ".mp3"
end

function M:playSound(filename)
    do return end
    filename = self:fullPath(filename)
    cc.SimpleAudioEngine:getInstance():playEffect(filename)
end

function M:playMusic(filename)
    do return end
    filename = self:fullPath(filename)
    cc.SimpleAudioEngine:getInstance():playMusic(filename, true)
end

return M