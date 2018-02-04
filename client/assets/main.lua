-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 1
CC_USE_FRAMEWORK = true
CC_SHOW_FPS = true
CC_DISABLE_GLOBAL = false
CC_DESIGN_RESOLUTION = {
    width = 1280,
    height = 720,
    autoscale = "SHOW_ALL",
    callback = function(framesize)
        local ratio = framesize.width / framesize.height
        if ratio <= 1.34 then --4:3 屏幕 单独适配
            return { autoscale = "FIXED_HEIGHT" }
        end
    end
}

-- 场景zorder顺序
SCENE_ZORDER =
{
    normal = 0, -- 普通
    net = 2,    -- 网络层
    syterm = 5, -- 系统(对话框,提示信息)
    tools = 4,
}

cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("res/")

CC_USE_FRAMEWORK = true
require "cocos.init"
print = release_print -- 打印函数
old_require = require

-- 开始内存回收
function StartCollectGarbage()
	collectgarbage("restart")
	collectgarbage("collect")
    collectgarbage("setpause", 150)
    collectgarbage("setstepmul", 5000)
end

-- 停止垃圾回收
function StopCollectGarbage()
	collectgarbage("stop")
end

-- 主函数
local function main()
    require "core.init"
    math.randomseed(os.clock())
    cc.Director:getInstance():setAnimationInterval(1.0 / 60)
    require("src.platform.init")
	-- 下载目录
	DOWD_LOAD_DIR = cc.FileUtils:getInstance():getWritablePath() .. "download/"
	cc.FileUtils:getInstance():createDirectory(DOWD_LOAD_DIR)
	print("写入地址", cc.FileUtils:getInstance():getWritablePath())
	print("下载地址", DOWD_LOAD_DIR)
    cc.Director:getInstance():setDisplayStats(CC_SHOW_FPS)

	-- 开始lua内存回收
    StartCollectGarbage()
	-- 创建场景
    local scene = cc.Scene:create()
    if cc.Director:getInstance():getRunningScene() then
	    cc.Director:getInstance():replaceScene(scene)
    else
	    cc.Director:getInstance():runWithScene(scene)
    end
    g_RootNode = scene

	-- 添加搜索(自动更新的在前)
    local arr = cc.FileUtils:getInstance():getSearchPaths()
	table.insert(arr, 1, cc.FileUtils:getInstance():getWritablePath())
    -- 非开发环境下，
    if not DEVELOPER_ENV then
        table.insert(arr, 1, DOWD_LOAD_DIR)
		table.insert(arr, 1, DOWD_LOAD_DIR .. "res/")
    end
    cc.FileUtils:getInstance():setSearchPaths(arr)
	require("src.global.Channel")
	Log("搜索目径:", arr)
    Log("渠道信息", GetChannelInfo())
	-- 开始自动更新
	require("src.GameApp"):run()
end

local function testFish()
    print("+++++++++++++++++++++testFish")
    math.randomseed(os.clock())
    cc.Director:getInstance():setAnimationInterval(1.0 / 60)
    require("src.platform.init")
	-- 下载目录
	DOWD_LOAD_DIR = cc.FileUtils:getInstance():getWritablePath() .. "download/"
	cc.FileUtils:getInstance():createDirectory(DOWD_LOAD_DIR)
	print("写入地址", cc.FileUtils:getInstance():getWritablePath())
	print("下载地址", DOWD_LOAD_DIR)
    cc.Director:getInstance():setDisplayStats(CC_SHOW_FPS)
    StartCollectGarbage()
	-- 创建场景
    local scene = cc.Scene:create()
    if cc.Director:getInstance():getRunningScene() then
	    cc.Director:getInstance():replaceScene(scene)
    else
	    cc.Director:getInstance():runWithScene(scene)
    end
    g_RootNode = scene
    require("games.fish.fish_client")
end

function __G__TRACKBACK__(msg)
    local msg = debug.traceback(msg, 3)
    print(msg)
    require("core.TrackbackLayer"):show("error", msg)
    return msg
end


xpcall(testFish, __G__TRACKBACK__)
