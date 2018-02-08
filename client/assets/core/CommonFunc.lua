----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-3-31
-- 描述：通用函数
----------------------------------------------------------------------
--------------------------------
-- TableToString
--------------------------------

local function MultiString(s,n)
	local r=""
	for i=1,n do
		r=r..s
	end
	return r
end
--o ,obj;b use [];n \n;t num \t;
function TableToString(o,n,b,t)
	if type(o) == "function" then return  "" end
	if type(b) ~= "boolean" and b ~= nil then
		print("expected third argument %s is a boolean", tostring(b))
	end
	if(b==nil)then b=true end
	t=t or 1
	local s=""
	if type(o) == "number" or 
		type(o) == "function" or
		type(o) == "boolean" or
		type(o) == "nil" then
		s = s..tostring(o)
	elseif type(o) == "string" then
		s = s..string.format("%q",o)
	elseif type(o) == "table" then
		s = s.."{"
		if(n)then
			s = s.."\n"..MultiString("  ",t)
		end
		for k,v in pairs(o) do
			if b then
				s = s.."["
			end

			s = s .. TableToString(k,n, b,t+1)

			if b then
				s = s .."]"
			end

			s = s.. " = "
			s = s.. TableToString(v,n, b,t+1)
			s = s .. ","
			if(n)then
				s=s.."\n"..MultiString("  ",t)
			end
		end
		s = s.."}"

	end
	return s
end

function SaveTabletoFile(tb, file)
    local str = TableToString(tb, 1, true, 1)
    str = "return "..str
    local path = cc.FileUtils:getInstance():getWritablePath()
	local file = io.open(path..file, "w")
	file:write(str, "\n")
	file:flush()
	file:close()
end

-- 功  能：生成多重排序规则
function MakeSortRule(...)
	local fnList = {...}
	local fnMore = function(x, y)
		for i = 1, #fnList do
			local fn = fnList[i]
			if fn(x, y) then
				return true
			elseif fn(y, x) then
				return false
			end

		end
		return false
	end
	return fnMore
end

-- 移除某个结点
function SafeRemoveNode(node)
    if node == nil or tolua.isnull(node) then return end
    node:removeFromParent(true)
end

-- 弹出消息框
function MsgBox(content)
    content = content or ""
    CCMessageBox(content, "")
end

-- 调用
function Invoke(target, name, ...)
    if target == nil then return end
    local func = target[name]
    if func == nil then return end
    return func(target, ...)
end

-- 重新加载lua文件
function ReloadLuaModule(name)
    if not device:isWindows() then return require(name) end
    package.loaded[name] = nil
    return require(name)
end

-- 对象是否还存活
function IsObjectAlive(obj)
	if obj == nil then return false end
	local t = type(obj)
	if t == "userdate" then
		return not tolua.isnull(obj)
	elseif obj.getSelf then
		return obj:getSelf()
	end
	return false
end


-- 把node里的子控件挂载在ui对象上
function BindToUI(widget, obj)
    -- 按钮事件
    local function buttonEventHandler(child)
        local name = child:getName()
        local func = obj["click_"..name]
        if func then 
            func(obj, child)
        else
            print("no function", obj.__cname, "click_"..name)
        end
    end

    local function visitChild(child)
        local name = child:getName()
		if (not name) or name == '' then
			return
		end
        --print(name)
		obj[name] = child -- 
		if tolua.iskindof(child, 'ccui.Button') or tolua.iskindof(child, 'ccui.CheckBox') then
			child:onClicked(function() buttonEventHandler(child) end)
		end
    end
    widget:visitAll(visitChild)
end

-- 加载csb
function LoadCsb(filename, obj, bShield)
    local widget = ccui.Widget:create()
    local node = cc.CSLoader:createNode(filename)
 	widget:setContentSize(node:getContentSize())
 	widget:setTouchEnabled(bShield) --
    widget:setPosition(0, 0)
    widget:setAnchorPoint(0, 0)
	for k, v in pairs(node:getChildren()) do
		v:changeParentNode(widget)
	end
	if obj then
		BindToUI(widget, obj)
	end
    return widget
end

local mustExtendFunc = {}
mustExtendFunc["require"] = true
mustExtendFunc["getComponent"] = true
mustExtendFunc["getScene"] = true

-- 继承类
function ExtendClass(obj, cls)
    local parent = cls.new()
    if parent.super then
        ExtendClass(obj, parent.super)
    end

    -- 继承变量
    for name, val in pairs(parent) do
        if obj[name] == nil and name ~= "class" then
            --print("value", name, obj[name], val)
            obj[name] = val
        end
    end

    -- 继承方法
	for name, val in pairs(cls) do
        if obj[name] == nil then
            --print("function", name, obj[name], val)
            obj[name] = val
        end

		if mustExtendFunc[name] then
			--print(parent.__cname, name, obj.__cname)
            obj[name] = val
        end
    end
end

-- 是否属于某个类
function IsKindOf(cls, name)
    if cls.__cname == name then return true end
    if cls.super then
        return IsKindOf(cls.super, name)
    end
    return false
end


-- 调试对象
function DebugGameObject(obj)
    local path = obj.__path
    local cls = ReloadLuaModule(path)
    --print("DebugGameObject", name)
    for key, val in pairs(cls) do
        if type(val) == "function" then
            obj[key] = val
        end
    end
end

function PlaySound(filename)
    if DISABLE_SOUND then return end
    cc.SimpleAudioEngine:getInstance():playEffect(filename)
end

function PlayMusic(filename)
    if DISABLE_MUSIC then return end
    cc.SimpleAudioEngine:getInstance():playMusic(filename, true)
end
