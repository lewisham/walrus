--[[

Copyright (c) 2011-2015 chukong-incc.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

]]

--------------------------------
-- Log
--------------------------------
local function LogTable(obj,parentDic,indent,deep)
	if not deep then
		deep = 10
	end
	deep = deep - 1 
	if deep < 0 then
		return
	end
	parentDic = parentDic or {}
	parentDic[obj] = true
	indent = indent or ""
	local oldIndent = indent
	print(indent.."{")
	indent = indent.."    "

	for k, v in pairs(obj) do
		local kType = type(k)
		local kStr = indent
		if kType == "number" then
			kStr = kStr.."["..k.."]"
		else
			kStr = kStr..tostring(k)
		end
		local sType = type(v)
		if sType == "table" then
			if parentDic[v] then
				print(kStr,"=","table is nest in parent")
			else
				print(kStr,"=")
				LogTable(v,parentDic,indent,deep)
			end
		elseif sType == "string" then
			print(kStr,"=", "'"..tostring(v).."'")
		else
			print(kStr,"=", tostring(v))
		end
	end

	print(oldIndent.."}")
	parentDic[obj] = nil
end

function LogKeys(obj, sFind)
	if not sFind then
		Log(obj)
		return 
	end

	sFind = sFind:upper()
	local t = {}
	for k,v in pairs(obj) do
		if type(k) == "string" and k:upper():find(sFind) then
			t[k] = v
		end
	end
	Log(t)
end

-- Log 支持多参数
function Log(...)
	local args = {...}
	if #args == 0 then
		print("nil")
		return 
	end

	for _, v in ipairs(args) do
		local sType = type(v)
		if sType == "table" then
			LogTable(v)
		else
			print(tostring(v))
		end
	end
end

-- Log 支持加打印的层数
function LogSimple(tab,n)
	if not n then
		n = 2
	end
	if not tab then
		print("nil")
		return
	end
	LogTable(tab,nil,nil,n)
end


-- 显示图片占用内存
function LogPicMem()
	cc.TextureCache:getInstance():dumpCachedTextureInfo()
end

require "cocos.cocos2d.Cocos2d"
require "cocos.cocos2d.Cocos2dConstants"
require "cocos.cocos2d.functions"

-- opengl
require "cocos.cocos2d.Opengl"
require "cocos.cocos2d.OpenglConstants"
-- audio
require "cocos.cocosdenshion.AudioEngine"
-- cocosstudio
if nil ~= ccs then
    require "cocos.cocostudio.CocoStudio"
end
-- ui
if nil ~= ccui then
    require "cocos.ui.GuiConstants"
    require "cocos.ui.experimentalUIConstants"
end

-- extensions
require "cocos.extension.ExtensionConstants"
-- network
require "cocos.network.NetworkConstants"
-- Spine
if nil ~= sp then
    require "cocos.spine.SpineConstants"
end

require "cocos.cocos2d.deprecated"
require "cocos.cocos2d.DrawPrimitives"

-- Lua extensions
require "cocos.cocos2d.bitExtend"

-- CCLuaEngine
require "cocos.cocos2d.DeprecatedCocos2dClass"
require "cocos.cocos2d.DeprecatedCocos2dEnum"
require "cocos.cocos2d.DeprecatedCocos2dFunc"
require "cocos.cocos2d.DeprecatedOpenglEnum"

-- register_cocostudio_module
if nil ~= ccs then
    require "cocos.cocostudio.DeprecatedCocoStudioClass"
    require "cocos.cocostudio.DeprecatedCocoStudioFunc"
end


-- register_cocosbuilder_module
require "cocos.cocosbuilder.DeprecatedCocosBuilderClass"

-- register_cocosdenshion_module
require "cocos.cocosdenshion.DeprecatedCocosDenshionClass"
require "cocos.cocosdenshion.DeprecatedCocosDenshionFunc"

-- register_extension_module
require "cocos.extension.DeprecatedExtensionClass"
require "cocos.extension.DeprecatedExtensionEnum"
require "cocos.extension.DeprecatedExtensionFunc"

-- register_network_module
require "cocos.network.DeprecatedNetworkClass"
require "cocos.network.DeprecatedNetworkEnum"
require "cocos.network.DeprecatedNetworkFunc"

-- register_ui_moudle
if nil ~= ccui then
    require "cocos.ui.DeprecatedUIEnum"
    require "cocos.ui.DeprecatedUIFunc"
end

-- cocosbuilder
require "cocos.cocosbuilder.CCBReaderLoad"

-- physics3d
require "cocos.physics3d.physics3d-constants"

if CC_USE_FRAMEWORK then
    require "cocos.framework.init"
end
