----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-3-31
-- 描述：大厅网络处理模块 
----------------------------------------------------------------------

local M = class("SCNetWork", GameObject)

function M:onCreate()
end

-- 连接
function M:connect()
    Toast("开始连接...")
    WaitForSeconds(1.0)
    for i = 1, 1 do
        local error = FindScene("SNetWork"):createTCP("hall", "127.0.0.1", "9527", 1)
        if error == "" then
            FindObject("SNetWork", "hall"):set("delegate", self)
            WaitForSeconds(1.0)
            Toast("连接成功...")
            return true
        end
        Toast("连接失败...")
    end
    return false
end

-- 接收请求
function M:onRecvMsg(str)
    local tb = json.decode(str)
    for key, val in pairs(tb) do
        local eventName = "onMsg" .. key
        self:post(eventName, val)
    end
end

function M:addNetEventListener(listener, id)
end

-- 发送字符串
function M:sendString(str)
    local byteArr = ByteArray()
    byteArr.write_string(str)
    local go = FindObject("SNetWork", "hall")
    if go == nil then return end
    go:sendString(byteArr.getBytes())
end

-- 发送请求
function M:startRequest(id, tb)
    local msg = {}
    msg[id] = tb
    local str = json.encode(msg)
    return self:sendString(str)
end

function M:test()
    local idx = 1
    while true do
        local tb = {}
        tb.Acc = "xxx"
        tb.Psw = "123456"
        tb.Pid = 0
        self:startRequest("Msg2Login", tb)
        WaitForFrames(100)
        idx = idx + 1
    end
end

-- 等待大厅网络消息
function WaitForHallNetMsg(listener, id)
    local go = FindObject("SHall", "SCNetWork")
    if go == nil then return end
    
end

return M