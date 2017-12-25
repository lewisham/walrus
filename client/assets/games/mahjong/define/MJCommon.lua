VIEW_ID_DEF =
{
    down = 1,
    right = 2,
    up = 3,
    left = 4
}

function MFullPath(fm, ...)
    local str = string.format(fm, ...)
    return string.format("games/mahjong/assets/%s", str)
end