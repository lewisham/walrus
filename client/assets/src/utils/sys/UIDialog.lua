----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-3-31
-- 描述：对话框
----------------------------------------------------------------------

local M = class("UIDialog", UIBase)

function M:onCreate()
    self:loadCsb("system/system/Dialog.csb", true)
	self:setVisible(false)
end

function M:show(title, content, yesFunc, noFunc)
    self:setVisible(true)
    self.content:setString(content)
    self.yesFunc = yesFunc
    self.noFunc = noFunc
end

function M:click_btn_yes()
    local callback = self.yesFunc
    self:removeFromScene()
    if callback then 
        callback()
    end
end

function M:click_btn_no()
    local callback = self.noFunc
    self:removeFromScene()
    if callback then 
        callback()
    end
end

return M