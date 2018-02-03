-- 执行dos命令
local function runDosCmd(cmdStr)
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

function CreateLuaPath(dir)
    local workDir = runDosCmd("cd")[1]
    local tail = ".lua"
    local files = {}
    local refs = {}
    for _, val in pairs(runDosCmd("dir " .. dir .. " /b/s")) do
        local path = string.sub(val, #workDir + 2)
        if string.sub(path, -4) == tail then
            path = string.gsub(path, ".lua", "")
            path = string.gsub(path, "\\", ".")
                
            -- 引用自身
            local fields = {}
            string.gsub(path, '[^.]+', function(sRet) table.insert(fields, sRet) end)
            local name = fields[#fields]
            refs[name] = path
        end
    end
    local str = "local tb = {\n"
    for k, v in pairs(refs) do
        local item = string.format("\t[\"%s\"] = \"%s\", \n", k, v)
        str = str .. item
    end
    str = str .."} \n return tb"
    local f = assert(io.open(dir .. "/AutoPath.lua", "wb"))
	if f then
		f:write(str)
		io.close(f)
	end
end

-- 加载本地配置脚本
if cc.FileUtils:getInstance():isFileExist("src/platform/CustomScript.lua") then
    require("src.platform.CustomScript")
end

function RunTestScript()
    ReloadLuaModule("TestScript")
end

-- 单文件更新方式
function PulishToCurrent()
    local workDir = runDosCmd("cd")[1]
    local list = {}
    local sDir = ""
    local tb = {"CheckFileList.txt"}
    local skips = {}
    for _, val in ipairs(tb) do
        skips[val] = 1
    end
    for key, _ in io.popen('dir ' .. sDir .. ' /a-D/b/s'):lines() do
        local filename = string.match(key, ".+\\([^\\]*%.%w+)$")
        if skips[filename] then
		    print("skil file", key)
        else
            local path = string.sub(key, #workDir + 2)
            local pos = #path - #filename
            local dir = string.sub(path, 1, pos)
            local content = FileRead(path)
            content = EncryptFile(filename, content)
            local md5 = content:md5() or "0bytes"
            local size = #content
            local path1 = string.gsub(path, "\\", "/")
            local abcd = {1, md5, path1, size}     
            table.insert(list, abcd)
        end
    end
	SaveFileList("CheckFileList.txt", list)
    print("PulishToCurrent success")
    Toast("发布本地md5成功")
end

cc.FileUtils:getInstance():setWritablePath("../../write/")

--LuaDebug配置
if cc.FileUtils:getInstance():isFileExist("src/platform/win32/LuaDebugjit1.lua") then
    local breakInfoFun, xpcallFun = require("src.platform.win32.LuaDebugjit")("localhost", 7003)
    cc.Director:getInstance():getScheduler():scheduleScriptFunc(breakInfoFun, 0.01, false)
end