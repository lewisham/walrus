----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2016-2-15
-- 描述：碰撞检测体
----------------------------------------------------------------------
local function perp(v)
	return cc.p(v.y,-v.x)
end

local function dot(v1, v2)
	return v1.x * v2.x + v1.y * v2.y
end

local function contains(n, range)
	local a, b = range[1], range[2]
	if b < a then a = b; b = range[1] end
	return n >= a and n <= b
end

local projectA = {0, 0}
local projectB = {0, 0}

-- 是否重叠
local function overlap()
	if contains(projectA[1], projectB) then return true
	elseif contains(projectA[2], projectB) then return true
	elseif contains(projectB[1], projectA) then return true
	elseif contains(projectB[2], projectA) then return true
	end
	return false
end

-- 投影
local function project(tb, points, axis)
	local min = dot(points[1],axis)
	local max = min
	for i,v in ipairs(points) do
		local proj =  dot(v, axis) -- projection
		if proj < min then min = proj end
		if proj > max then max = proj end
    end
    tb[1] = min
    tb[2] = max
end

local MOVE_TAG = 101

local M = class("FishObject", function() return cc.Node:create() end)

function M:initCollider()
    self.alive = false
    self.bOutOfScreen = true
    self:createCollider()
    self.points = {}
    self.position = cc.p(self:getPosition())
    -- 法向量
    self.axis = {}
    local total = #self.vertices
    for i = 1, total do
        local next = i + 1 > total and 1 or i + 1
        local axis = perp(cc.pNormalize(cc.pSub(self.vertices[i], self.vertices[next])))
        table.insert(self.axis, axis)
    end
end

function M:setOutOfScreen(bo)
    self.bOutOfScreen = bo
end

function M:isOutOfScreen()
    return self.bOutOfScreen
end

function M:setAlive(bo)
    self.alive = bo
end

function M:isAlive()
    return self.alive
end

-- 创建显示碰撞区
function M:createCollider()
    if not self:getScene():get("enble_collider") then return end
    local filledVertices = self.vertices
    local glNode  = gl.glNodeCreate()
    self:addChild(glNode)
    local function primitivesDraw(transform, transformUpdated)
        kmGLPushMatrix()
        kmGLLoadMatrix(transform)
        gl.lineWidth( 1.0 )
        gl.lineWidth(1)
        cc.DrawPrimitives.drawSolidPoly(filledVertices, #filledVertices, cc.c4f(1, 0.3, 0.5, 0.5))
        kmGLPopMatrix()
    end
    glNode:registerScriptDrawHandler(primitivesDraw)
end

-- 更新多边型点的位置
function M:updatePoints()
    self.position.x, self.position.y = self:getPosition()
    -- 更新顶点
    self.points = {}
    for key, vec in ipairs(self.vertices) do
        self.points[key] = self:convertToWorldSpaceAR(vec)
    end
end

-- 更新法向量
function M:updateAxis()
    local ratation = self:getRotation()
    if self.ratation == ratation then return end
    self.ratation = ratation
    self.axis = {}
    -- 更新单位法向量
    local total = #self.vertices
    for i = 1, total do
        local next = i + 1 > total and 1 or i + 1
        local axis = perp(cc.pNormalize(cc.pSub(self.points[next], self.points[i])))
        table.insert(self.axis, axis)
        --TEST_COUNT = TEST_COUNT + 1
    end
    --print("更新单位法向量")
    --Log(self.points)
end

-- 分离轴算法
function M:sat(go)
    local offsetx = self.position.x - go.position.x
    local offsety = self.position.y - go.position.y
    if offsetx * offsetx + offsety * offsety > self.raduis_2 + go.raduis_2 then
        return false
    end
    for k, v in ipairs(self.points) do
        local axis = self.axis[k]
        project(projectA, self.points, axis)
        project(projectB, go.points, axis)
		if not overlap() then return false end
	end
	for k, v in ipairs(go.points) do
        local axis = go.axis[k]
        project(projectA, go.points, axis)
        project(projectB, self.points, axis)
		if not overlap() then return false end
    end
	return true
end

function M:moveTo(pos, duration)
    local mov = cc.MoveTo:create(duration, pos)
    mov:setTag(MOVE_TAG)
    self:runAction(mov)
end

function M:stopMove()
    self:stopActionByTag(MOVE_TAG)
end

function M:onCollsion()
end

return M