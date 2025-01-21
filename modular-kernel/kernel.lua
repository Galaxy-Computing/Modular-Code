-- modular-kernel module
-- Copyright (C) 2025 Galaxy Computing/eli310

-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.

_G.module = {}

function module.getPath(name)
    return "/modular/modules/"..name
end
function module.run(name)
    return shell.run(module.getPath(name).."/main.lua")
end

function module.isExecutable(name)
    return fs.exists(module.getPath(name).."/main.lua")
end

function module.list()
    return fs.list("/modular/modules")
end

function module.exists(name)
    return fs.isDir(module.getPath(name))
end

function module.meta(name)
    return dofile(module.getPath(name).."/meta.lua")
end

function module.version(name)
    return module.meta(name)[3]
end

function module.sysversion()
    return "Modular OS modular-kernel "..module.version("modular-kernel")
end

function os.version()
    return module.sysversion()
end

function module.loadConfig()
    _G.module.config = {}
    for _,path in ipairs(fs.list("/modular/config")) do
        local f = fs.open("/modular/config/"..path,"r")
        local fstring = f.readAll()
        f.close()
        module.config[path] = textutils.unserialise(fstring)
    end
end

function module.saveConfig()
    fs.delete("/modular/config/*")
    for key,data in pairs(module.config) do
        local f = fs.open("/modular/config/"..key,"w")
        local fstring = textutils.serialize(data)
        f.write(fstring)
        f.close()
    end
end

function module.createConfig(name)
    module.config[name] = {}
    module.saveConfig()
end

-- This is so modules can have more than one program
function module.path(name)
    shell.setPath(".:/modular/modules/"..name..string.sub(shell.path(),2))
end

_G.logger = {}
logger.enabled = false

function logger.ok(text)
    if logger.enabled then
        write("[ ")
        term.setTextColor(colors.lime)
        write("OK")
        term.setTextColor(colors.white)
        print(" ] "..text)
    end
end
function logger.info(text)
    if logger.enabled then
        print("[INFO] "..text)
    end
end
function logger.err(text)
    if logger.enabled then
        write("[")
        term.setTextColor(colors.red)
        write("ERR")
        term.setTextColor(colors.white)
        print(" ] "..text)
    end
end
function logger.warn(text)
    if logger.enabled then
        write("[")
        term.setTextColor(colors.yellow)
        write("WARN")
        term.setTextColor(colors.white)
        print("] "..text)
    end
end

os.forcereboot = os.reboot
os.forceshutdown = os.shutdown

function os.reboot()
    module.saveConfig()
    os.forcereboot()
end

function os.shutdown()
    module.saveConfig()
    os.forceshutdown()
end

if not fs.exists("/modular/config") then
    fs.makeDir("/modular/config")
end

module.loadConfig()

module.currentUser = ""

if not fs.exists("/modular/config/modular-kernel") then
    module.createConfig("modular-kernel")
    module.config["modular-kernel"]["cmdline"] = "/modular/modules/shell/main.lua multishell"
end
if not fs.exists("/modular/config/users") then
    module.createConfig("users")
    module.config.users["root"] = {"",0}
end

module.saveConfig()

os.pullEventOld = os.pullEvent
os.pullEvent = os.pullEventRaw

term.clear()
term.setCursorPos(1,1)

logger.enabled = true

-- Initialize modules that have a startup.lua file
for _,name in ipairs(module.list()) do
    if fs.exists(module.getPath(name).."/init.lua") then
        logger.info("Initializing module "..name)
        shell.run(module.getPath(name).."/init.lua")
    end
end

logger.enabled = false

print()
print(module.sysversion())
print()

while module.currentUser == "" do
    write("login: ")
    local login = read()
    write("password: ")
    local pass = read("")
    if module.config.users[login] then if module.config.users[login][1] == pass then
        module.currentUser = login
    end end
    if module.currentUser == "" then
        print("login incorrect")
    end
end

os.pullEvent = os.pullEventOld
os.pullEventOld = nil

shell.run(module.config["modular-kernel"]["cmdline"])
