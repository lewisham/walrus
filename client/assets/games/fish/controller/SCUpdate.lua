----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-3-31
-- 描述：自动更新逻辑(一个文件一个文件的更新)
----------------------------------------------------------------------

-- 读文件
local function FileRead(filename)
	local f, moreInfo = io.open(filename, "rb")
	local ret
	if f then
		ret = f:read("*all")
		io.close(f)
	end
	return ret, moreInfo
end

-- 写文件
local function FileWrite(filename, str)
	local f = assert(io.open(filename, "wb"))
	if f then
		f:write(str)
		io.close(f)
	end
end

local function SaveFileList(filename, list)
    local tb = {}
	for k, abcd in pairs(list) do
		table.insert(tb, table.concat(abcd, ','))
	end
	local str = table.concat(tb, '\r\n')
    FileWrite(filename, str)
end

-- 执行dos命令
local function RunDosCmd(cmdStr)
	local cmd = io.popen(cmdStr)
	if cmd then
		local tb = {}
		for k, _v in cmd:lines() do
			table.insert(tb, k)
		end
		cmd:close()
		return tb
	end
	return nil
end

-- md5码
local function Md5Crypto(str)
    if md5_crypto then
        return md5_crypto(str, string.len(str))
    end
end

local M = class("SCUpdate", u3a.GameObject)

function M:onCreate()
    self:set("wait_cnt", 0)
    self:set("total_update_cnt", 1)       -- 总共要更新的文件
    self:set("update_cnt", 0)   
    self:set("down_load_filename", "")
    self:set("client_file_list", {})
    self:set("error_code", "")
    local root = cc.Node:create()
    self:getScene():getRoot():addChild(root)
    self:set("root", root)
end

-- 执行逻辑
function M:play(url)
    if cc.Application:getInstance():getTargetPlatform() == 0 then
        print("win32平台不自动更新")
        return
    end
    local downLoadDir = cc.FileUtils:getInstance():getWritablePath()
    if url == nil then return end
    print(url)
    self:set("url", url)
    -- 清除文件缓存
	cc.FileUtils:getInstance():purgeCachedEntries()
    self:set("down_load_dir", downLoadDir)
    self:logic()
    u3a.SafeRemoveNode(self:get("root"))
    if self:get("error_code") ~= "" then
        self:refreshTips(self:get("error_code"))
		return false
    end
	return true
end

function M:logic()
    -- 检查版本号
    if self:checkVersion() then return end
    -- 检查要更新文件
    local tb = self:checkUpdateFiles()
    if tb == nil then return end
    u3a.WaitForSeconds(0.5)
    self:refreshTips("更新中")
    -- 下载文件
    local maxThread = 3
    self:set("wait_cnt", 0)
    self:set("total_update_cnt", #tb)       -- 总共要更新的文件
    self:set("update_cnt", 0)               -- 已更新的文件
    for _, val in pairs(tb) do
        if self:get("error_code") ~= "" then return end
        self:updateFile(val)
        u3a.WaitForFuncResult(function() return self:get("wait_cnt") < maxThread end)
    end
    u3a.WaitForFuncResult(function() return self:get("wait_cnt") == 0 end)
    self:saveClientFileList()
    u3a.WaitForFrames(1)
    self:refreshTips("自动更新完成")
    u3a.WaitForSeconds(1.0)
end

-- 检查版本号
function M:checkVersion()
    do return false end
	print("检测是否要更新")
    self:refreshTips("检测是否要更新")
    local location = "0"
    local server = self:download("CheckVersion.txt")
    if server == nil then
        return true
    end
    print("检查版本号", "客户端", location, "服务端", server)
    if location == server then
        self:refreshTips("已是最新版本，无需更新") 
        return true
    end
end

-- 检查更新文件
function M:checkUpdateFiles() 
    u3a.WaitForSeconds(0.5)
    self:refreshTips("检查要更新文件")
    local str1 = self:download("CheckFileList.txt")
    if str1 == nil then return end
    local tb1 = self:parseUpdateFiles(str1)  -- 服务端文件列表
	print(cc.FileUtils:getInstance():fullPathForFilename("CheckFileList.txt"))
    local str2 = cc.FileUtils:getInstance():getStringFromFile("CheckFileList.txt")
	local tb2 = self:parseUpdateFiles(str2)  -- 客户端文件列表
    self:set("client_file_list", tb2)
    local list = {}
    local cnt = 0
    local total = 0
    for key, val in pairs(tb1) do
        if tb2[key] == nil or tb2[key][2] ~= val[2] then
            cnt = cnt + 1
            table.insert(list, val)
        end
        if total > 0 and cnt >= total then
            break
        end
    end
    print("检查要更新的文件", #list)
    --Log(list)
    return list
end

-- 更新文件
function M:updateFile(abcd)
    self:coroutine(self, "implUpdateFile", abcd)
end

function M:implUpdateFile(abcd)
    self:modify("wait_cnt", 1)
    local filename = abcd[3]
	self:refreshTips("更新文件" .. filename)
    local data = self:download(filename)
    self:modify("wait_cnt", -1)
    if data == nil then
        return
    end
    print("更新文件成功", filename)
    -- 保存文件
    self:saveFile(filename, data)
    self:get("client_file_list")[filename] = abcd
    self:modify("update_cnt", 1)
    -- 每3次保存下client file list
    if self:get("update_cnt") % 3 == 0 then
        self:saveClientFileList()
    end
    self:refreshPercent()
end

-- 解析文件列表
function M:parseUpdateFiles(str)
    local dic = {}
	local lines = str:split('\r\n')
	for k, v in pairs(lines) do
		local abcd = v:split(',') -- {dlLevel, md5, filePath, fileSize}
		local path = abcd[3]
		if path then
			dic[path] = abcd
		end
	end
	return dic
end

-- 下载文件
function M:download(filename)
    local url = self:get("url")..filename
    local ret = nil
    local bRet = false
    local function callback(bOK, resp)
        if bOK then
            ret = resp
        else
            self:set("error_code", "下载文件"..filename.."失败")
        end
        bRet = true
    end
    self:httpGet(url, callback)
    u3a.WaitForFuncResult(function() return bRet end)
    return ret
end

-- 保存client file list
function M:saveClientFileList()
	SaveFileList(cc.FileUtils:getInstance():getWritablePath().."CheckFileList.txt", self:get("client_file_list"))
end

-- 保存下载的文件
function M:saveFile(filename, data)
    local path = self:get("down_load_dir")..filename
	if true or device:isWindows() then
		local dir = string.match(filename, "(.+)/[^/]*%.%w+$") 
		if dir then
			cc.FileUtils:getInstance():createDirectory(self:get("down_load_dir") .. dir)
		end
	end
	FileWrite(path, data)
end

-- url请求下载
function M:httpGet(url, fnCallback)
	url = string.gsub(url, ' ', '%%20') -- 用urlencode 可能有问题，这里只改空格
    local xhr = cc.XMLHttpRequest:new()
	xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
	xhr:open("GET", url)
	local ndProtected = cc.Node:create()
	local function onReadyStateChange()
		if tolua.isnull(ndProtected) then
			return -- 节点已被删了, 可能是游戏被重新加载了
		end
		u3a.SafeRemoveNode(ndProtected)
		if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then -- 成功
			--print("成功 Code:"..xhr.statusText)
			fnCallback(true, xhr.response)
		else -- 失败
            print(url)
			print("失败 xhr.readyState is:", xhr.readyState, "xhr.status is: ",xhr.status)
			fnCallback(false, xhr.response)
		end
	end
	xhr:registerScriptHandler(onReadyStateChange)
	xhr:send()
	self:get("root"):addChild(ndProtected)
	return xhr
end

-- 刷新提示
function M:refreshTips(str)
    --Log(str)
    do return end
    self:find("UIAutoUpdate"):refreshTips(str)
end

-- 刷新百分比
function M:refreshPercent()
    do return end
    local go = self:find("UIAutoUpdate")
    if not go then return end
    local percent = math.floor(self:get("update_cnt") / self:get("total_update_cnt") * 100)
    go:refreshPercent(percent)
end

function M:calcFileList(tb, dir)
    local workDir = RunDosCmd("cd")[1]
	for _, val in ipairs(RunDosCmd("dir " .. dir .. " /a-D/b/s")) do
		local path = string.sub(val, #workDir + 2)
        local filename = string.match(val, ".+\\([^\\]*%.%w+)$") or ""
        if filename ~= "" then
            path = string.gsub(path, "\\", "/")
            local dir = string.sub(path, 1, #path - #filename)
            local unit = {}
            unit.dir = dir
            unit.path = path
            unit.filename = filename
            table.insert(tb, unit)
        end
	end
end

-- 发布资源
function M:publish(dir, to)
    if cc.Application:getInstance():getTargetPlatform() ~= 0 then
        print("win32平台不可发布")
        return
    end
    local tb = {}
    if type(dir) == "string" then
        self:calcFileList(tb, dir)
    elseif type(dir) == "table" then
        for _, val in pairs(dir) do
            self:calcFileList(tb, val)
        end
    end
    local list = {}
    for _, unit in ipairs(tb) do
        print(unit.path)
        local content = FileRead(unit.path)
        local md5 = Md5Crypto(content) or "0bytes"
        local size = #content
        local abcd = {1, md5, unit.path, size}
        table.insert(list, abcd)
        cc.FileUtils:getInstance():createDirectory(to .. unit.dir)
        FileWrite(to .. unit.path, content)
    end
    SaveFileList(to .. "CheckFileList.txt", list)
    SaveFileList(dir .. "/CheckFileList.txt", list)
    self:getScene():toast("发布资源成功")
end

return M