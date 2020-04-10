-- Author: Emanuel Ramirez Alsina
-- Date Created: 04/07/2020

--The idea of this project is for it to be really good at just one thing:
-- Provide VIM-Keybinds support ONLY where the user desire the VIM-keybinds
--I've tried using 'system-wide' VIM-Keybinds and more often than not; It ends
--with me disabling the VIM-keybinds.

--Normal Mode
local normalMode = hs.hotkey.modal.new()

--Insert Mode
local insertMode = hs.hotkey.modal.new()

--Visual Mode
local visualMode = hs.hotkey.modal.new()

--List of supported Applications
--The user could add or remove applications as desired.
APPS = {'Preview', 'Slack', 'Discord', 'Notes'}


function init()
    appsWatcher = hs.application.watcher.new(slackWatcher)
    appsWatcher:start()
end

--Checks if the currently focused applications is in the list of supported apps
function contains(APPS, name)
    for i, app in ipairs(APPS) do
        if APPS[i] == name then
            return true
        end
    end
    return false
end


function slackWatcher(name, event, app)
    if (contains(APPS, name) and event == hs.application.watcher.activated) then
        hs.alert.show(name .. ' Focused')
    end


end
init()
