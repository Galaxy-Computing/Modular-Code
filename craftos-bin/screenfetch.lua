-- SPDX-FileCopyrightText: 2019 JackMacWindows
--
-- SPDX-License-Identifier: MIT

if os.pullEvent ~= nil then

    local ccart, ccart_fg, ccart_bg, ccart_adv_fg, ccart_adv_bg, ccart_width

    if ... == "--small" then

        ccart = ([[\159\143\143\143\143\143\143\143\144
\150\136\144     \150
\150\130 \131    \150
\150       \150
\150       \150
\150      \140\150
         ]]):gsub("\\130", "\130"):gsub("\\131", "\131"):gsub("\\136", "\136"):gsub("\\140", "\140"):gsub("\\143", "\143"):gsub("\\144", "\144"):gsub("\\150", "\149"):gsub("\\159", "\159")

        ccart_fg = [[ffffffff7
f00fffff7
f0f0ffff7
ffffffff8
ffffffff8
f888888f8
fffffffff]]

        ccart_bg = [[77777777f
7ffffffff
7ffffffff
8ffffffff
8ffffffff
88888888f
fffffffff]]

        ccart_adv_fg = [[ffffffffb
f00fffffb
f0f0ffffb
ffffffffb
ffffffffb
f444444db
fffffffff]]

        ccart_adv_bg = [[bbbbbbbbf
bffffffff
bffffffff
bffffffff
bffffffff
bbbbbbbbf
fffffffff]]

        ccart_width = 10

    else
        ccart = [[------------------------
|                      |
| -------------------- |
| | \                | |
| | / __             | |
| |                  | |
| |                  | |
| |                  | |
| |                  | |
| |                  | |
| |                  | |
| -------------------- |
|                      |
|                  [=] |
|                      |
------------------------]]

        ccart_fg = [[ffffffffffffffffffffffff
f7777777777777777777777f
f7ffffffffffffffffffff7f
f7ff0fffffffffffffffff7f
f7ff0f00ffffffffffffff7f
f7ffffffffffffffffffff7f
f7ffffffffffffffffffff7f
f7ffffffffffffffffffff7f
f8ffffffffffffffffffff8f
f8ffffffffffffffffffff8f
f8ffffffffffffffffffff8f
f8ffffffffffffffffffff8f
f8888888888888888888888f
f888888888888888888fff8f
f8888888888888888888888f
ffffffffffffffffffffffff]]

        ccart_bg = [[ffffffffffffffffffffffff
f7777777777777777777777f
f7ffffffffffffffffffff7f
f7ffffffffffffffffffff7f
f7ffffffffffffffffffff7f
f7ffffffffffffffffffff7f
f7ffffffffffffffffffff7f
f7ffffffffffffffffffff7f
f8ffffffffffffffffffff8f
f8ffffffffffffffffffff8f
f8ffffffffffffffffffff8f
f8ffffffffffffffffffff8f
f8888888888888888888888f
f888888888888888888fff8f
f8888888888888888888888f
ffffffffffffffffffffffff]]

        ccart_adv_fg = [[ffffffffffffffffffffffff
f4444444444444444444444f
f4ffffffffffffffffffff4f
f4ff0fffffffffffffffff4f
f4ff0f00ffffffffffffff4f
f4ffffffffffffffffffff4f
f4ffffffffffffffffffff4f
f4ffffffffffffffffffff4f
f4ffffffffffffffffffff4f
f4ffffffffffffffffffff4f
f4ffffffffffffffffffff4f
f4ffffffffffffffffffff4f
f4444444444444444444444f
f444444444444444444ddd4f
f4444444444444444444444f
ffffffffffffffffffffffff]]

        ccart_adv_bg = [[ffffffffffffffffffffffff
fbbbbbbbbbbbbbbbbbbbbbbf
fbffffffffffffffffffffbf
fbffffffffffffffffffffbf
fbffffffffffffffffffffbf
fbffffffffffffffffffffbf
fbffffffffffffffffffffbf
fbffffffffffffffffffffbf
fbffffffffffffffffffffbf
fbffffffffffffffffffffbf
fbffffffffffffffffffffbf
fbffffffffffffffffffffbf
fbbbbbbbbbbbbbbbbbbbbbbf
fbbbbbbbbbbbbbbbbbbdddbf
fbbbbbbbbbbbbbbbbbbbbbbf
ffffffffffffffffffffffff]]

        ccart_width = 25

    end

    local function fg(l) if term.isColor() then return string.rep("b", l) else return string.rep("8", l) end end
    local function text(title, str) return {title .. str, fg(string.len(title)) .. string.rep("0", string.len(str)), string.rep("f", string.len(title .. str))} end

    local function time(n)
        local h = math.floor(n / 3600)
        local m = math.floor(n / 60) % 60
        local s = n % 60
        local retval = s .. "s"
        if m > 0 or h > 0 then retval = m .. "m " .. retval end
        if h > 0 then retval = h .. "h " .. retval end
        return retval
    end

    local function ext(retval)
        if debug ~= nil then table.insert(retval, text("    ", "Debug enabled")) end
        if http ~= nil then table.insert(retval, text("    ", "HTTP enabled")) 
        if http.websocket ~= nil then table.insert(retval, text("    ", "CC: Tweaked")) end end
        if mounter ~= nil then table.insert(retval, text("    ", "CraftOS-PC")) end
        if term.setGraphicsMode ~= nil then table.insert(retval, text("    ", "CraftOS-PC GFX")) end
        if term.screenshot ~= nil then table.insert(retval, text("    ", "CraftOS-PC 2")) end
        if ccemux ~= nil then table.insert(retval, text("    ", "CCEmuX")) end
        if fs.exists(".mbs") or fs.exists("rom/.mbs") then table.insert(retval, text("    ", "MBS")) end
        if type(kernel) == "table" then table.insert(retval, text("    ", "CCKernel2")) end
        return retval
    end

    local function getRuntime()
        if os.about ~= nil then return string.sub(os.about(), 1, string.find(os.about(), "\n"))
        elseif ccemux ~= nil then return ccemux.getVersion()
        elseif _MC_VERSION ~= nil then return _MC_VERSION
        else return "Unknown" end
    end

    local sysinfo = {
        text(os.getComputerLabel() or "Untitled Computer", ""),
        text("Type: ", commands ~= nil and "Command Computer" or term.isColor() and "Advanced Computer" or "Standard Computer"),
        text("OS: ", os.version()),
        text("Runtime: ", getRuntime()),
        text("Lua: ", _VERSION),
        text("Host: ", _HOST),
        text("Uptime: ", time(os.clock())),
        text("Extensions: ", "")
    }
    ext(sysinfo)
    local lines, sw, sh = 2, term.getSize()
    term.clear()
    term.setCursorPos(1, 2)
    for i = 1, string.len(ccart), ccart_width do 
        term.blit(string.sub(ccart, i, i+ccart_width-2), string.sub(term.isColor() and ccart_adv_fg or ccart_fg, i, i+ccart_width-2), string.sub(term.isColor() and ccart_adv_bg or ccart_bg, i, i+ccart_width-2))
        write("  ")
        if sysinfo[((i-1)/ccart_width)+1] ~= nil then term.blit(table.unpack(sysinfo[((i-1)/ccart_width)+1])) end
        print("")
        lines = lines + 1
    end
    for i = lines - 1, #sysinfo do
        write(string.rep(" ", ccart_width + 1))
        term.blit(table.unpack(sysinfo[i]))
        print("")
    end
    print("")
    if term.screenshot ~= nil then term.screenshot() end
    sleep(0.25)

else print("Unknown computer type") end