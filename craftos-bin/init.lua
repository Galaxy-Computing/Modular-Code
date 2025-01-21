-- SPDX-FileCopyrightText: 2017 Daniel Ratcliffe
--
-- SPDX-License-Identifier: LicenseRef-CCPL

module.path("craftos-bin")

local completion = require "cc.shell.completion"

-- Setup completion functions

local function completePastebinPut(shell, text, previous)
    if previous[2] == "put" then
        return fs.complete(text, shell.dir(), true, false)
    end
end

local function completeConfigPart2(shell, text, previous)
    if previous[2] == "get" or previous[2] == "set" then
        return completion.choice(shell, text, previous, config.list(), previous[2] == "set")
    end
end

local function completeConfigPart3(shell, text, previous)
    if previous[2] == "set" then
        if config.getType(previous[3]) == "boolean" then return completion.choice(shell, text, previous, {"true", "false"})
        elseif previous[3] == "mount_mode" then return completion.choice(shell, text, previous, {"none", "ro", "ro_strict", "rw"}) end
    end
end

shell.setCompletionFunction("modular/modules/craftos-bin/alias.lua", completion.build(nil, completion.program))
shell.setCompletionFunction("modular/modules/craftos-bin/cd.lua", completion.build(completion.dir))
shell.setCompletionFunction("modular/modules/craftos-bin/clear.lua", completion.build({ completion.choice, { "screen", "palette", "all" } }))
shell.setCompletionFunction("modular/modules/craftos-bin/copy.lua", completion.build(
    { completion.dirOrFile, true },
    completion.dirOrFile
))
shell.setCompletionFunction("modular/modules/craftos-bin/delete.lua", completion.build({ completion.dirOrFile, many = true }))
shell.setCompletionFunction("modular/modules/craftos-bin/drive.lua", completion.build(completion.dir))
shell.setCompletionFunction("modular/modules/craftos-bin/edit.lua", completion.build(completion.file))
shell.setCompletionFunction("modular/modules/craftos-bin/eject.lua", completion.build(completion.peripheral))
shell.setCompletionFunction("modular/modules/craftos-bin/gps.lua", completion.build({ completion.choice, { "host", "host ", "locate" } }))
shell.setCompletionFunction("modular/modules/craftos-bin/help.lua", completion.build(completion.help))
shell.setCompletionFunction("modular/modules/craftos-bin/id.lua", completion.build(completion.peripheral))
shell.setCompletionFunction("modular/modules/craftos-bin/label.lua", completion.build(
    { completion.choice, { "get", "get ", "set ", "clear", "clear " } },
    completion.peripheral
))
shell.setCompletionFunction("modular/modules/craftos-bin/list.lua", completion.build(completion.dir))
shell.setCompletionFunction("modular/modules/craftos-bin/mkdir.lua", completion.build({ completion.dir, many = true }))

local complete_monitor_extra = { "scale" }
shell.setCompletionFunction("modular/modules/craftos-bin/monitor.lua", completion.build(
    function(shell, text, previous)
        local choices = completion.peripheral(shell, text, previous, true)
        for _, option in pairs(completion.choice(shell, text, previous, complete_monitor_extra, true)) do
            choices[#choices + 1] = option
        end
        return choices
    end,
    function(shell, text, previous)
        if previous[2] == "scale" then
            return completion.peripheral(shell, text, previous, true)
        else
            return completion.programWithArgs(shell, text, previous, 3)
        end
    end,
    {
        function(shell, text, previous)
            if previous[2] ~= "scale" then
                return completion.programWithArgs(shell, text, previous, 3)
            end
        end,
        many = true,
    }
))

shell.setCompletionFunction("modular/modules/craftos-bin/move.lua", completion.build(
    { completion.dirOrFile, true },
    completion.dirOrFile
))
shell.setCompletionFunction("modular/modules/craftos-bin/redstone.lua", completion.build(
    { completion.choice, { "probe", "set ", "pulse " } },
    completion.side
))
shell.setCompletionFunction("modular/modules/craftos-bin/rename.lua", completion.build(
    { completion.dirOrFile, true },
    completion.dirOrFile
))
shell.setCompletionFunction("modular/modules/craftos-bin/type.lua", completion.build(completion.dirOrFile))
shell.setCompletionFunction("modular/modules/craftos-bin/set.lua", completion.build({ completion.setting, true }))
