local function parseDigits(f, s)
    local a = -1
    local b = -1
    for i = 1, #s do
        local an = f(s, i)
        local bn = f(s, #s - i + 1)
        if a == -1 and an ~= -1 then a = an end
        if b == -1 and bn ~= -1 then b = bn end
        if a ~= -1 and b ~= -1 then break end
    end
    return a * 10 + b
end

local function part1()
    local f = io.open("part_1_input.txt")
    local sum = 0
    local line = f:read("*line")
    while line ~= nil do
        sum = sum + parseDigits(
            function (s, i)
                local num = tonumber(string.sub(s, i, i))
                if num ~= nil then return num else return -1 end
            end,
            line
        )
        line = f:read("*line")
    end
    f:close()
    print(sum)
end

local function part2()
    local function findDigit(s, idx)
        local num = tonumber(string.sub(s, idx, idx))
        if num ~= nil then return num end
        local words = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine"}
        for i = 1, #words do
            local word = words[i]
            if #s - idx + 1 >= #word and string.sub(s, idx, idx + #word - 1) == word then
                return i
            end
        end
        return -1
    end
    local f = io.open("part_2_input.txt")
    local sum = 0
    local line = f:read("*line")
    while line ~= nil do
        sum = sum + parseDigits(findDigit, line)
        line = f:read("*line")
    end
    print(sum)
end

part1()
part2()
