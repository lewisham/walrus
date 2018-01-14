----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-3-31
-- 描述：工具场景
----------------------------------------------------------------------

local STools = class("STools", GameScene)

function STools:ctor()
    STools.super.ctor(self)
    self.mRootZorder = SCENE_ZORDER.tools
end

function STools:createAutoPath()
    self:autoRequire("src\\utils\\tools")
end

function STools:onCreate()
    self:getRoot():setTouchEnabled(false)
    --self:createGameObject("UIToolsPanel")
end

return STools