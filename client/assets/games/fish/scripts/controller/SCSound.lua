----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：声音
----------------------------------------------------------------------

local PATH = "games/fish/assets/sound/"

local M = class("SCSound", wls.GameObject)

function M:onCreate()
    self.bEnableSound = cc.Application:getInstance():getTargetPlatform() == 0
    self.bEnableSound = true
end

function M:preload(filename)
    filename = self:fullPath(filename)
    cc.SimpleAudioEngine:getInstance():preloadEffect(filename)
end

function M:fullPath(str)
    return PATH .. str .. ".mp3"
end

function M:playSound(filename)
    filename = self:fullPath(filename)
    self:playSoundFile(filename)
end

function M:playFishDead(filename)
    filename = PATH .. filename
    self:playSoundFile(filename)
end

function M:playSoundFile(filename)
    if self.bEnableSound then
        return
    end
    cc.SimpleAudioEngine:getInstance():playEffect(filename)
end

function M:playMusic(filename)
    filename = self:fullPath(filename)
    cc.SimpleAudioEngine:getInstance():playMusic(filename, true)
end

return M