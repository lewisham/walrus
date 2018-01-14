----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-3-31
-- 描述：系统场景
----------------------------------------------------------------------

local M = class("SSystem", GameScene)

-- 构造函数
function M:ctor()
    M.super.ctor(self)
    self.mRootZorder = SCENE_ZORDER.syterm
end

function M:createAutoPath()
    self:autoRequire("src\\utils\\sys")
end

function M:onCreate()
    self:getRoot():setTouchEnabled(false)
    self:require("SYSGobalFunc")
    self:createGameObject("UIToast")
    self:createGameObject("UIBroadcast")
end

return M