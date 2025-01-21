local tArgs = {...}
local command = table.concat(tArgs, ' ', 1, #tArgs)
local originaluser = module.currentUser
if module.config.users[module.currentUser][2] >= 1 then
    module.currentUser = "root"
    shell.run(command)
    module.currentUser = originaluser
else
    print("sudo: no permission")
end