local TEST_GAME_ID = 226
local M = class("SCSelectRoom", wls.GameObject)

function M:onCreate()
    self.rooms = self:getBuyuRooms()
end

function M:getBuyuRooms()
    if hallmanager == nil then
        return
    end
    local rooms = {}
    for key, val in pairs(hallmanager.rooms) do
        if val.gameid == TEST_GAME_ID then
            rooms[key] = val
        end
    end
    return rooms
end

function M:getRoomId()
    local limitDownNum = 500	--下限 小于这个数量就优先导入玩家
	local limitUpNum = 5000 	--上限 大于这个数就不导入玩家

	local limitDownMax = 0
	local index = 0
	for key, val in pairs(self.rooms) do
        local playerNum = val.players
        if playerNum <= limitDownNum and playerNum >= limitDownMax then
            limitDownMax = playerNum
            index = key
        end
	end

	if limitDownMax == 0 and index == 0 then
		--没有低于500的房间
		--排除大于5000的房间
		local selectTab = {}
		local limitUpMin = 0
		for key, val in pairs(self.rooms) do
			local playerNum = val.players
			if playerNum < limitUpNum then
				table.insert(selectTab, key)
			end
		end

		if table.maxn(selectTab) == 0 then
			return nil
		else
			return self:randomSelectRoom(selectTab)
		end

	else
		return index
	end
end

function M:randomSelectRoom(roomIndexTab)
	local roomIndex = math.random(1,table.maxn(roomIndexTab))
	return roomIndexTab[roomIndex]
end

return M