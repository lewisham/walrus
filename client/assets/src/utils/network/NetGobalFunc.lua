----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-3-31
-- 描述：网络场景全局方法
----------------------------------------------------------------------

function ReceiveData(sock)
    local fullData, status, tailData = sock:receive(256)
    if status == "closed" then
        sock:close() 
        return status
    end
    local function fnConvertData(dt)
		if not dt then
			return nil
		end
		if dt:len() == 0 then
			return nil
		end
		return dt
	end
    local sData = fnConvertData(fullData) or fnConvertData(tailData)
    return sData, status
end

-- 发送网络消息
function SendAndWait(req, sWait, fnReply, bWait)
    if mInstance == nil then return end
    fnReply = fnReply or function() end
    bWait = bWait == nil and true or bWait
    if mInstance:getSelf() == nil then return end
    local ret = mInstance:send(req, sWait, fnReply, bWait)
    return ret ~= "closed"
end

-- 等待网络消息
function WaitForNetMessage(req, sWait)
    local resp = {}
    local function callback(msg)
        resp = msg
        co:resume("WaitForNetMessage")
    end
    if not SendAndWait(req, sWait, callback) then return resp end
    co:pause("WaitForNetMessage")
    return resp
end