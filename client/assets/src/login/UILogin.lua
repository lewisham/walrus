----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2017-12-24
-- 描述：登录主界面
----------------------------------------------------------------------

local M = class("UILogin", UIBase)

function M:onCreate()
    self:loadCsb("ui/login/login_layer.csb", true)
    self.node_logo:setPositionY(display.height - 250)
    self:createBtn()
end

function M:createBtn()
    local node = LoadCsb("ui/login/login_button.csb")
    self.panel_bg:addChild(node)
    node:setPosition(display.width / 2, 60)
    BindToUI(node, node)
    cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/login.plist")
    node.btn:loadTextureNormal("hall/login/first/btn_wl.png",1)
    node.btn:loadTexturePressed("hall/login/first/btn_wl.png",1)
    node.click_btn = function() self:click_login() end
end

function M:click_login()
    --ShowBroadcast("你好")
    self:post("onMsgLoginSuccess")
end

return M