----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-3-31
-- 描述：socket tcp
----------------------------------------------------------------------

local M = class("DAClientTCP", GameObject)

function M:onCreate(args)
    self.t1 = 0
    self.mSendBuf = ""
    self.mRecvBuf = ""
	self.mSock = nil
	self:set("delegate", nil)
end

function M:onUpdate(dt)
    if nil == self.mSock then
		return
	end
	-- 发送数据
	local err = self:doSendBuf()
	if "closed" == err then
		return
	end
	-- 接收数据并缓存起来
	self:doRecvBuf()

	-- 处理一条消息
	for i = 1, 20 do
		local bool = self:dealOneMsg()
		if not bool then break end
    end
end

-- 处理一条消息(返回false，代表没有消息要处理了)
function M:dealOneMsg()
	local sTmp = self.mRecvBuf
	local HEAD_SIZE = 2						-- 包头大小,固定4个字节
	if sTmp:len() < HEAD_SIZE then
		return false
	end
	-- 读包头长度(2字节)
	local byteArr = ByteArray()
    byteArr.setBytes(sTmp)
	local msgLen = byteArr:read_uint16()
	if sTmp:len() < msgLen then
		return false
    end
	self.mRecvBuf = sTmp:sub(msgLen + 1 + HEAD_SIZE)
    sTmp = sTmp:sub(HEAD_SIZE + 1)
    local body = sTmp:sub(1, msgLen)
	Invoke(self:get("delegate"), "onRecvMsg", body)
    return true
end

-- 连接
function M:connect(host, port, timeout)
	timeout = timeout or 3
    local sock = self:createSocket(host)
    sock:settimeout(0)
    local duration = 0.2
    local tm = os.clock()
	while true do
		local t2 = os.clock() - tm
        if t2 > timeout then
			sock:close()
			return "timeout"
		end
        local a, b = sock:connect(host, port)
	    if a == 1 or b == "already connected" then
		    break
	    end
		WaitForSeconds(duration)
	end
	self.mSock = sock
	return ""
end

-- 创建socket
function M:createSocket(host)
	if not device:isIos()then -- 判断ios提审
        return socket.tcp()
    end
	-- 判断是否ipv6环境
	local isipv6 = false
	local addrifo, err = socket.dns.getaddrinfo(host)
	for k, v in pairs(addrifo or {}) do
		if v.family == "inet6" then
			isipv6 = true
			break
		end
	end
    local sock = nil
	if isipv6 then
		sock = socket.tcp6()
	else
		sock = socket.tcp()
	end
    return sock
end


-- 发送字符串
function M:sendString(str)
	if nil == self.mSock then return "closed" end
	if nil == str then return end
	self.mSendBuf = self.mSendBuf .. str
    return self:doSendBuf()
end

-- 发送被缓存的数据
function M:doSendBuf()
	if self.mSendBuf:len() <= 0 then
		return nil
	end
	local nSend, err, retC = self.mSock:send(self.mSendBuf)
	nSend = nSend or 0
    --print(nSend)
	self.mSendBuf = self.mSendBuf:sub(nSend+1)
	if err == "closed" then
		self:clear()
	end
    self.t1 = os.clock()
	return err
end

-- 接收数据并缓存起来
function M:doRecvBuf()
	local function fnConvertData(dt)
		if not dt then
			return nil
		end
		if dt:len() == 0 then
			return nil
		end
		return dt
	end

	local fullData, status, tailData = self.mSock:receive(1024)
    local sData = fnConvertData(fullData) or fnConvertData(tailData)
	if not sData then
		return
	end
	self.mRecvBuf = self.mRecvBuf .. sData
end

function M:clear()
end

return M