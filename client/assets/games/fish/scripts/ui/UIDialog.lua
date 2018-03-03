----------------------------------------------------------------------
-- 作者：Cai
-- 日期：2017-12-24
-- 描述：对话框界面
----------------------------------------------------------------------

local M = class("UIDialog", wls.UIGameObject)

function M:getZorder()
    return 100
end

function M:onCreate(bDelete)
    self.bDelete = bDelete
    self:createMask()
    self:loadCenterNode(self:fullPath("ui/common/uiMessageDialog.csb"), true)

    self.node_middle:setVisible(false)
    self.node_min:setVisible(false)
    self.node_hook:setVisible(false)
    self.btn_hook:getChildByName("spr_hook"):setVisible(false)  
    self.btn_min_only_OK:setVisible(false)  
    self.btn_middle_only_OK:setVisible(false)
    self.btn_middle_OK:setVisible(false)  
    self.btn_middle_CANCEL:setVisible(false)

    self.btn_min_only_OK:setTag(0)  
    self.btn_middle_only_OK:setTag(1)
    self.btn_middle_OK:setTag(2)
    self.btn_middle_CANCEL:setTag(3)
    self.btn_hook:setTag(4)

    self.firstPos = {}
    self.firstPos.x = self.text_middle_data:getPositionX()
    self.firstPos.y = self.text_middle_data:getPositionY()
    self.textSize = self.text_middle_data:getContentSize()
    self.text_middle_data:ignoreContentAdaptWithSize(true)
    self.text_middle_data:setTextAreaSize({width = 0, height = 0})
    self.text_middle_desc:ignoreContentAdaptWithSize(true)
    self.text_middle_desc:setTextAreaSize({width = 0, height = 0})
    self:setVisible(false)
end

function M:updateView(modeType, strmsg, strhook)
    self:setVisible(true)
    self.node_hook:setVisible(false)
    if modeType == wls.DialogStyle.MODE_MIN_OK_ONLY then
        self.node_min:setVisible(true) 
        self.btn_min_only_OK:setVisible(true)  
    elseif modeType == wls.DialogStyle.MODE_MIDDLE_OK_ONLY then
        self.node_middle:setVisible(true)
        self.btn_middle_only_OK:setVisible(true)     
    elseif modeType == wls.DialogStyle.MODE_MIDDLE_OK_CLOSE then
        self.node_middle:setVisible(true)
        self.btn_middle_OK:setVisible(true)
        self.btn_middle_CANCEL:setVisible(true)
    elseif modeType == wls.DialogStyle.MODE_MIDDLE_OK_CLOSE_HOOK then
        self.node_middle:setVisible(true)
        self.btn_middle_OK:setVisible(true)
        self.btn_middle_CANCEL:setVisible(true)
        self.node_hook:setVisible(true)
        self.btn_hook:getChildByName("spr_hook"):setVisible(false)
    end

    if strhook == nil then strhook = "本次登录不再提示！" end
    self.text_notice:setString(strhook)

    if strmsg then self:setTextData(strmsg) end
end

--==============================--
-- 文本设置
--==============================--
function M:setTextData(str)
    local back = self:splitTextStr(str)
    self:updateText(self.text_middle_data, back[1], self.textSize.width)
    self:updateText(self.text_middle_desc, back[2], self.textSize.width)
    self.text_min_data:setString(back[1])   
    self:updateTextPos()
end

function M:splitTextStr(str)
    local result = string.split(str, "$")
    return result
end

function M:updateTextPos()
    local size1 = self.text_middle_data:getContentSize()
    local size2 = self.text_middle_desc:getContentSize()
    if size2.width > 0 then
        local newPosY1 = self.firstPos.y + self.textSize.height/2 - size1.height/2
        self.text_middle_data:setPositionY(newPosY1)
        local newPosY2 = self.firstPos.y + self.textSize.height/2 - size1.height - size2.height/2
        self.text_middle_desc:setPositionY(newPosY2)
    else
        self.text_middle_data:setPositionY(self.firstPos.y)
    end
end

--设置中提示界面的提示数据
function M:updateText(text, str, sizeWidth)
    text:setTextAreaSize({width = 0, height = 0})
    text:setString(str)
    local size = text:getContentSize()
    if size.width > sizeWidth then
        text:setTextAreaSize({width = sizeWidth, height = 0})
        text:setTextHorizontalAlignment(0)
    else
        text:setTextHorizontalAlignment(1)
    end  
end

--==============================--
-- 按钮回调事件
--==============================--
function M:setCallback(callback)
    self._callback = callback
end

function M:doClose(idx)
    local bool = self.btn_hook:getChildByName("spr_hook"):isVisible()
    if self._callback then self._callback(idx, bool) end
    if self.bDelete then
        wls.SafeRemoveNode(self)
    else
        self:setVisible(false)
    end
end

function M:click_btn_min_only_OK()
    self:doClose(1)
end

function M:click_btn_middle_only_OK()
    self:doClose(1)
end

function M:click_btn_middle_OK()
    self:doClose(1)
end

function M:click_btn_middle_CANCEL()
    self:doClose(2)
end

function M:click_btn_hook()
    local sprHook = self.btn_hook:getChildByName("spr_hook")
    sprHook:setVisible(not sprHook:isVisible())
end

return M