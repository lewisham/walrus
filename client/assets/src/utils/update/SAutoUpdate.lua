----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-3-31
-- 描述：自动更新
----------------------------------------------------------------------

local SAutoUpdate = class("SAutoUpdate", GameScene)

function SAutoUpdate:createAutoPath()
    self:autoRequire("src\\utils\\update")
end

-- 执行自动更新逻辑
function SAutoUpdate:play(url)
    url = "https://raw.githubusercontent.com/lewisham/mahjong/master/assets/"
	-- 不进进行自动更新
    if not NOT_AUTO_UPDATE then
        self:createGameObject("UIAutoUpdate")
		self:createGameObject("SCUpdateOneByOne", url):play()
	end
    self:destroy()
end

return SAutoUpdate