-- Author: Emanuel Ramirez Alsina
-- Date Created: 04/07/2020


--TODO: Add variable that let the user decide: Mode alerts ON/OFF

--Scrolling speed
local SPEED = 2

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

        --------------------MODE'S KEYBINDS--------------------

        --Bind Normal mode key
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

        --Bind Insert mode key
        insertMode = hs.hotkey.bind({}, "I",
        function()
            --Do this ONLY if we are in 'Normal' mode.
            if MODE == 'NORMAL' then
                normal:exit()
                insert:enter() 
                hs.alert.show('Insert mode')
                MODE = 'INSERT'
            end
        end)

        --Bind Visual mode key
        visualMode = hs.hotkey.bind({}, "V",
        function()
            --Do this ONLY if we are in 'Normal' mode.
            if MODE == 'NORMAL' then
                normal:exit()
                visual:enter() 
                hs.alert.show('Visual mode')
                MODE = 'VISUAL'
            end
        end)

        -------------------------------------------------------



        -------------NORMAL MODE MOVEMENT KEYBINDS-------------
        
        --Enable: Scroll UP --> 'K'
        function scrollUP() hs.eventtap.scrollWheel({0, SPEED}, {}) end
        normal:bind({}, 'K', scrollUP, nil, scrollUP)

        --Enable: Scroll DOWN --> 'J'
        function scrollDOWN() hs.eventtap.scrollWheel({0, -SPEED}, {}) end
        normal:bind({}, 'J', scrollDOWN, nil, scrollDOWN)
        
        --Enable: Scroll LEFT --> 'H'
        function scrollLEFT() hs.eventtap.scrollWheel({SPEED, 0}, {}) end
        normal:bind({}, 'H', scrollLEFT, nil, scrollLEFT)

        --Enable: Scroll RIGHT --> 'L'
        function scrollRIGHT() hs.eventtap.scrollWheel({-SPEED, 0}, {}) end
        normal:bind({}, 'L', scrollRIGHT, nil, scrollRIGHT)

        --Enable: Go to TOP --> 'G'
        function goTOP() hs.eventtap.keyStroke({'cmd'}, 'Up') end
        normal:bind({}, 'G', goTOP)

        --Enable: Go to BOTTOM --> 'SHIFT+G'
        function goBOTTOM() hs.eventtap.keyStroke({'cmd'}, 'Down') end
        normal:bind({'shift'}, 'G', goBOTTOM)

        --Enable: Scroll one page foward --> 'Ctrl+f'
        function nextPAGE() hs.eventtap.keyStroke({}, 'Right') end
        normal:bind({'ctrl'}, 'F', nextPAGE)

        --Enable: Scroll one page backwards --> 'Ctrl+b'
        function previousPAGE() hs.eventtap.keyStroke({}, 'Left') end
        normal:bind({'ctrl'}, 'B', previousPAGE)


        -------------------------------------------------------

        --Start in Normal mode.
        normalMode:enable()
        normal:enter()
        normal:entered()
    end


    --When using other app that we don't want VIM keybinds.gg
    if (contains(APPS, name) and event == hs.application.watcher.deactivated) then


        --Disable Normal mode keybind
        hs.hotkey.disableAll({"ctrl"}, "J",
        function()
            --Do this ONLY if we are in 'Insert' or 'Visual' mode.
            if MODE ~= 'NORMAL' then
            normal:enter() 
            hs.alert.show('Normal mode')
            MODE = 'NORMAL'
            end
        end)

        --Disable Insert mode keybind
        hs.hotkey.disableAll({}, "I",
        function()
            --Do this ONLY if we are in 'Normal' mode.
            if MODE == 'NORMAL' then
            insert:enter() 
            hs.alert.show('Insert mode')
            MODE = 'INSERT'
            end
        end)

        --Disable Visual mode keybind
        hs.hotkey.disableAll({}, "V",
        function()
            --Do this ONLY if we are in 'Normal' mode.
            if MODE == 'NORMAL' then
            visual:enter() 
            hs.alert.show('Insert mode')
            MODE = 'VISUAL'
            end
        end)

        --Disable: 'K'
        hs.hotkey.disableAll({}, 'K', scrollUP, nil, scrollUP)

        --Disable: 'J'
        hs.hotkey.disableAll({}, 'J', scrollDOWN, nil, scrollDOWN)

        --Disable: 'H'
        hs.hotkey.disableAll({}, 'H', scrollLEFT, nil, scrollLEFT)

        --Disable: 'L'
        hs.hotkey.disableAll({}, 'L', scrollRIGHT, nil, scrollRIGHT)

        --Disable: 'G'
        hs.hotkey.disableAll({}, 'G', goTOP)

        --Disable: 'SHIFT+G'
        hs.hotkey.disableAll({'shift'}, 'G', goBOTTOM)

        --Disable: 'Ctrl+f'
        hs.hotkey.disableAll({'ctrl'}, 'F', nextPAGE)

        --Disable: 'Ctrl+b'
        hs.hotkey.disableAll({'ctrl'}, 'B', previousPAGE)
    end


end
init()
