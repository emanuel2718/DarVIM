-- Author: Emanuel Ramirez Alsina
-- Date Created: 04/07/2020

--The idea of this project is for it to be really good at just one thing:
-- Provide VIM-Keybinds support ONLY where the user desire the VIM-keybinds
--I've tried using 'system-wide' VIM-Keybinds and more often than not; It ends
--with me disabling the VIM-keybinds.

--Current Modes; Start in NORMAL mode.
--Possible MODES: 'NORMAL', 'INSERT', 'VISUAL'
local MODE = 'NORMAL'

--Normal Mode
local normal = hs.hotkey.modal.new()

--Insert Mode
local insert = hs.hotkey.modal.new()

--Visual Mode
local visual = hs.hotkey.modal.new()

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
        --is.alert.show(name .. ' Focused') --Application with focus.


        --Bind normal mode key
        --TODO: Think about a better 'ESC' key. I think is not wise to use ESC
        normalMode = hs.hotkey.bind({"ctrl"}, "J",
        function()
            --Do this ONLY if we are in 'Insert' or 'Visual' mode.
            if MODE ~= 'NORMAL' then
            normal:enter() 
            hs.alert.show('Normal mode')
            MODE = 'NORMAL'
            end
        end)
    end


end
init()
