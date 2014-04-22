-- Very simple Equator, WIP
-- Made by vifino
equator = {}
function equator.basic(raw)
    if raw:match("*") then
        local first,last = raw:match("(%d+)*(%d+)")
        if first and last then
            local result = tonumber(first) * tonumber(last)
            if result then
                return result
            else
                return nil
            end
        else
            return nil
        end
    elseif raw:match("/") then
        local first,last = raw:match("(%d+)/(%d+)")
        if first and last then
            local result = tonumber(first) / tonumber(last)
            if result then
                return result
            else
                return nil
            end
        else
            return nil
        end
    elseif raw:match("+") then
        local first,last = raw:match("(%d+)+(%d+)")
        if first and last then
            local result = tonumber(first) + tonumber(last)
            if result then
                return result
            else
                return nil
            end
        else
            return nil
        end
    elseif raw:match("^") then
        local first,last = raw:match("(%d+)^(%d+)")
        if first and last then
            local result = tonumber(first)^tonumber(last)
            if result then
                return result
            else
                return nil
            end
        else
            return nil
        end
    end
end