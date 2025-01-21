fs.delete("/out")
fs.makeDir("/out")
for _,mod in ipairs(module.list()) do
    print("- "..mod)
    shell.run("buildmod "..mod.." /out/"..mod..".mpk")
end