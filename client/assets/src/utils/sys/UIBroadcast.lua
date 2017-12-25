----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-3-31
-- 描述：广播消息
----------------------------------------------------------------------

local M = class("UIBroadcast", UIBase)

function M:onCreate()
	self:setVisible(false)
end

return M