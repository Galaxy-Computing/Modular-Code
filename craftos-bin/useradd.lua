local tArgs = {...}
if module.config.users[module.currentUser][2] == 0 then
    write("password for "..tArgs[1]..": ")
    local pass = read("")
    module.config.users[tArgs[1]] = {pass,1}
    module.saveConfig()
else
    print("useradd: must be ran as root")
end