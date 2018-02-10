local _M = {}

function _M:init(protoString)

    -- 名称到类型映射
    self.nameToTypes = {}
    print(protoString)
    -- id到类型映射，注意id为字符串
    self.idToTypes = {}
    for typeName, typeId, typeContent in string.gmatch(protoString, "(%a+[%a%d]*)%s*=%s*(%d+)%s*;?[^%c]*%c([^}]*)}") do
        local jmsgType = {}
       
        jmsgType.typeName = typeName
        jmsgType.typeId = typeId

        -- 名称到字段信息映射
        jmsgType.nameToFields = {}

        -- id到字段信息映射
        jmsgType.idToFields = {}

        for fieldName, fieldType, fieldId in string.gmatch(typeContent, "(%a+[%a%d]*)%s*:%s*([%[%]]*[%d%a]+)%s*=%s*(%d+)") do
            local jmsgField = {}

            local posStart, posEnd = string.find(fieldType, "%[%]")

            if posStart == nil then
                jmsgField.fieldType = fieldType
                jmsgField.isArray = false
            else
                jmsgField.fieldType = string.sub(fieldType, 3)
                jmsgField.isArray = true
            end
            jmsgField.fieldName = fieldName
            jmsgField.fieldId = fieldId
            jmsgType.nameToFields[fieldName] = jmsgField
            jmsgType.idToFields[fieldId] = jmsgField
        end
        self.nameToTypes[typeName] = jmsgType
        self.idToTypes[typeId] = jmsgType
    end

    dump(_M)
end

local function getIntPart(x)
    if x <= 0 then
    return math.ceil(x)
    end

    if math.ceil(x) == x then
    x = math.ceil(x)
    else
    x = math.ceil(x) - 1
    end
    return x
end

local function readEncodedInt(msg)
    local data1 = msg:ReadByte()
    local len = 1
    if data1 < 128 then
        return data1
    else
        data1 = data1 - 128
    end
    local data2 = msg:ReadByte()
    local data3 = msg:ReadByte()
    local data4 = msg:ReadByte()

    return data1 * 256 * 256 * 256 + data2 * 256 * 256 + data3 *256  + data4

end

local function writeEncodedInt(msg, data)
    local ret = 1
    if data < 128 then
        msg:WriteByte(data)
        ret = 1
    else
        local data1 = getIntPart(data / 256 / 256 / 256) + 128
        local data2 = getIntPart(data / 256 / 256) - data1 * 256
        local data3 = getIntPart(data / 256)  - data2 * 256 - data1 * 256 * 256
        local data4 = data  - data3 *256 - data2 * 256 * 256 - data1 * 256 * 256 * 256

        msg:WriteByte(data1)
        msg:WriteByte(data2)
        msg:WriteByte(data3)
        msg:WriteByte(data4)
        ret = 4
    end
    return ret
end

local function readBytes(msg, len)
    local ret = ""
    for i = 1, len do
        ret = ret .. string.char(msg:ReadByte())
    end
    return ret
end

local function writeBytes(msg, data) 
    for i = 1 , len(data) do
        msg:WriteByte(string.byte(data, i))
    end
end

local function readInt(msg)
    local data1 = msg:ReadByte()
    local  data2 = msg:ReadByte()
    local data3 = msg:ReadByte()
    local data4 = msg:ReadByte()

    return data1 * 256 * 256 * 256 + data2 * 256 * 256 + data3 *256  + data4
end

local function writeInt(msg, data)
    local data1 = getIntPart(data / 256 / 256 / 256)
    local data2 = getIntPart(data / 256 / 256) - data1 * 256
    local data3 = getIntPart(data / 256)  - data2 * 256 - data1 * 256 * 256
    local data4 = data - data3 *256 - data2 * 256 * 256 - data1 * 256 * 256 * 256

    msg:WriteByte(data1)
    msg:WriteByte(data2)
    msg:WriteByte(data3)
    msg:WriteByte(data4)
end

local function readString(msg)
    local len = readEncodedInt(msg)

    local ret = ""

    for i = 1, len do
        ret = ret .. string.char(msg:ReadByte())
    end
    return ret
end

local function writeString(msg, data)
    local strLen = string.len(data)
    local headerLen = writeEncodedInt(msg, strLen)

    for i = 1, strLen do
        msg:WriteByte(string.byte(data, i))
    end
    return strLen + headerLen
end

local function writeNString(msg, data, len)
    for i = 1, len do
        msg:WriteByte(string.byte(data, i))
    end
end

local function readBool(msg)
    if msg:ReadByte() == 1 then
        return true
    else
        return false
    end
end

local function writeBool(msg, data)
    if data then
        msg:WriteByte(1)
    else
        msg:WriteByte(0)
    end
end

function _M:getFieldValueFromMsg(msg, fieldInfo)
    if fieldInfo.fieldType == "int" then
        return readInt(msg)
    elseif fieldInfo.fieldType == "string" then
        return readString(msg)
    elseif fieldInfo.fieldType == "bool" then
        return readBool(msg)
    else
        local typeName, data =  self:decode(msg, fieldInfo.typeName)
        return data
    end
end

local function printMsgData(msg, start, count)
    local oldPosition = msg.position
    msg.position = start
    print("printMsgData start")
    for i = 1, count do
        local data = msg:ReadByte()
        print("byte ".. (i + start - 1) .. ":"..data)
    end
    msg.position = oldPosition
    print("printMsgData end")
end

function _M:setFieldValueToMsg(msg, fieldInfo, data)
    -- 记录原来的位置
    local oldPos = msg.position
    --print("setFieldValueToMsg,name="..fieldInfo.fieldName..",pos="..oldPos)

    -- 写入字段id
    writeEncodedInt(msg, tonumber(fieldInfo.fieldId))

    -- 写入数据
    if fieldInfo.fieldType == "int" then
        writeInt(msg, data)
    elseif fieldInfo.fieldType == "string" then
        writeString(msg, data)
    elseif fieldInfo.fieldType == "bool" then
        writeBool(msg, data)
    else
        self:encode(fieldInfo.fieldType, msg, data)
    end
    --print("after encode pos="..msg.position)

    --编码后的数据长度=最新位置-原来的位置
    local encodedLen = msg.position - oldPos
    --print("encoded len="..encodedLen)

    -- 回退到开始位置
    msg.position = oldPos

    -- 读取编码后的数据
    local encodedData = msg:ReadStringAEx(encodedLen)
    --print("after new pos="..msg.position)

    -- 重置位置和长度
    msg.position = oldPos

    -- 写入数据长度
    writeEncodedInt(msg, encodedLen)

    -- 写入编码后的数据
    writeNString(msg, encodedData, encodedLen)
    --print("setFieldValueToMsg,new pos="..msg.position)
    --printMsgData(msg, oldPos, encodedLen)
end

function _M:getFieldArrayFromMsg(msg, fieldInfo)
    local len = readEncodedInt(msg)
    local ret = {}
    if fieldInfo.fieldType == "int" then
        for i = 1, len do
            ret[i] = readInt(msg)
        end
    elseif fieldInfo.fieldType == "string" then
        for i = 1, len do
            ret[i] = readString(msg)
        end
    elseif fieldInfo.fieldType == "bool" then
        for i = 1, len do
            ret[i] = readBool(msg)
        end
    else
        for i = 1, len do
            local typeName, data = self:decode(msg, fieldInfo.fieldType)
           ret[i] = data
        end
        
    end
    return ret
end

function _M:setFieldArrayToMsg(msg, fieldInfo, data)
    local oldPos = msg.position
    local len = #data

    -- 写入字段id
    writeEncodedInt(msg, tonumber(fieldInfo.fieldId))
    writeEncodedInt(msg, #data)
    if fieldInfo.fieldType == "int" then
        for i = 1, len do
            writeInt(msg, data[i])
        end
    elseif fieldInfo.fieldType == "string" then
        for i = 1, len do
            writeString(msg, data[i])
        end
        
    elseif fieldInfo.fieldType == "bool" then
        for i = 1, len do
            writeBool(msg, data[i])
        end        
    else
        local typeInfo = self.nameToTypes[fieldInfo.fieldName]
        for i = 1, len do
            self:encode(fieldInfo.fieldType, msg, data[i])
        end
    end
    local lenEncoded = msg.position - oldPos
    msg.position = oldPos
    local encodedData = msg:ReadStringAEx(lenEncoded)
    msg.position = oldPos
    writeEncodedInt(msg, lenEncoded)
    writeNString(msg, encodedData, lenEncoded)
end

function _M:fillTypeFieldsFromMsg(msg, typeInfo, ret)
    while(true)
    do
        local fieldLen = readEncodedInt(msg)       
        --print("read field len:"..fieldLen)
        if fieldLen == 0 then
            break
        end

        local fieldId = readEncodedInt(msg)
        local fieldIdString = tostring(fieldId)
            
        local fieldInfo = typeInfo.idToFields[fieldIdString]
        
        --print("read field id:"..fieldId)
        if fieldInfo == nil then
            --print("field not found")
            readBytes(msg, fieldLen)
        elseif fieldInfo.isArray ~= true then
            --print("reading value field:"..fieldInfo.fieldName..",type:"..fieldInfo.fieldType)
            ret[fieldInfo.fieldName] = self:getFieldValueFromMsg(msg, fieldInfo)
        else
            --print("reading array field:"..fieldInfo.fieldName..",type:"..fieldInfo.fieldType)
            ret[fieldInfo.fieldName] = self:getFieldArrayFromMsg(msg, fieldInfo)
        end
    end
end


function _M:fillTypeFieldsToMsg(msg, typeInfo, data)
    for fieldName, fieldValue in pairs(data) do
        local fieldInfo = typeInfo.nameToFields[fieldName]

        if fieldInfo == nil then
        elseif fieldInfo.isArray ~= true then
            --print("encoding value field:"..fieldInfo.fieldName)
            self:setFieldValueToMsg(msg, fieldInfo, fieldValue)
        else
            --print("encoding array field:"..fieldInfo.fieldName)
            self:setFieldArrayToMsg(msg, fieldInfo, fieldValue)
        end
    end
    writeEncodedInt(msg, 0)
end

-- 输入参数，消息
-- 输出：消息名，解码后的table
function _M:decode(msg)
    local msgId = tostring(readEncodedInt(msg))
    local ret = {}
    --print("read msg id:")
    -- 消息不存在
    local typeInfo = self.idToTypes[msgId]
    if  typeInfo == nil then
        return "", ret
    end
    --print("find type:"..typeInfo.typeName)
    self:fillTypeFieldsFromMsg(msg, typeInfo, ret)
    return typeInfo.typeName, ret
end

-- 输入参数：消息名，messageHeader对象，需要编码的table
-- 输出参数:无
function _M:encode(typeName, msg, data)
    local typeInfo = self.nameToTypes[typeName]

    if typeInfo == null then
        return
    end
    writeEncodedInt(msg, tonumber(typeInfo.typeId))
   -- print("encoding type:"..typeInfo.typeName)
    self:fillTypeFieldsToMsg(msg, typeInfo, data)
end

return _M