-- SPDX-FileCopyrightText: 2017 Daniel Ratcliffe
--
-- SPDX-License-Identifier: LicenseRef-CCPL

if term.isColour() then
    term.setTextColour(colours.blue)
end
print("Goodbye")
term.setTextColour(colours.white)

sleep(1)
os.reboot()
