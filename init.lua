-- Author: Emanuel Ramirez Alsina
-- Date Created: 04/07/2020


--TODO: Add variable that let the user decide: Mode alerts ON/OFF

--Scrolling speed
local SPEED = 2

--Current Modes; Start in NORMAL mode.
--Possible MODES: 'NORMAL', 'INSERT', 'VISUAL'
local MODE = 'NORMAL'

--Normal Mode
normal = hs.hotkey.modal.new()
normalPDF = hs.hotkey.modal.new()

--Insert Mode
--local insert = hs.hotkey.modal.new()

--Visual Mode
local visual = hs.hotkey.modal.new()

--List of supported Applications
--The user could add or remove applications as desired.
APPS = {'Preview', 'Slack', 'Discord', 'Notes'}


function init()
    appsWatcher = hs.application.watcher.new(applicationWatcher)
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

function applicationWatcher(name, event, app)

    --If we are readign a PDF
    if name == 'Preview' then
        --If the is begin focused
        if event == hs.application.watcher.activated then
            --insertMode:enable()
            visualMode:enable()
            normalMode:disable()
            normalModePDF:enable()
            normalPDF:enter()
        end
        --We lost focus of the PDF window
        if event == hs.application.watcher.deactivated then
            --If the focused window is one where we don't want VIM keybinds
            --restriction (i.e Terminal)
            if not contains(APPS, hs.window.frontmostWindow():application():name()) then
                --insertMode:disable()
                visualMode:disable()
                normalModePDF:disable()
            end
            normalPDF:exit()
        end
    end

    --For apps like Slack, Discord, Notes, etc.
    --We dont want scrolling features like in Preview. We want 'hjkl' to behave
    --like arrows to edit text.
    if contains(APPS, name) and name ~= 'Preview' then
        if event == hs.application.watcher.activated then
            --insertMode:enable()
            visualMode:enable()
            normalModePDF:disable()
            normalMode:enable()
            normal:enter()
        end
        if event == hs.application.watcher.deactivated then
            if not contains(APPS, hs.window.frontmostWindow():application():name()) then
                --normal:exit()
                --insertMode:disable()
                visualMode:disable()
                normalModePDF:disable()
                normalMode:disable()
            end
            normal:exit()
        end
    end
end


    --------------------MODE'S KEYBINDS--------------------

--Bind Normal Mode for regular apps like Slack, Discord, Notes
normalMode = hs.hotkey.bind({"ctrl"}, "J",
function()
    --Do this ONLY if we are in 'Insert' or 'Visual' mode.
    if MODE ~= 'NORMAL' then
        normal:enter() 
        hs.alert.show('Normal mode')
        MODE = 'NORMAL'
    end
end)

--Bind Normal mode for PDF's key
normalModePDF = hs.hotkey.bind({"ctrl"}, "J",
function()
    --Do this ONLY if we are in 'Insert' or 'Visual' mode.
    if MODE ~= 'NORMAL' then
        normalPDF:enter() 
        hs.alert.show('Normal mode')
        MODE = 'NORMAL'
    end
end)

--Bind Insert mode key
--insertMode = hs.hotkey.bind({}, "I",
--function()
    --Do this ONLY if we are in 'Normal' mode.
    --if MODE == 'NORMAL' then
        --normalPDF:exit()
        --insert:enter() 
        --hs.alert.show('Insert mode')
        --MODE = 'INSERT'
    --end
--end)

--Bind Visual mode key
visualMode = hs.hotkey.bind({}, "V",
function()
    --Do this ONLY if we are in 'Normal' mode.
    if MODE == 'NORMAL' then
        normalPDF:exit()
        visual:enter() 
        hs.alert.show('Visual mode')
        MODE = 'VISUAL'
    end
end)

-------------------------------------------------------



-------------NORMAL MODE PDF NAVIGATION KEYBINDS-------------

normalPDF:bind({}, 'I',
    function()
        if MODE == 'NORMAL' then
            normalPDF:exit()
            hs.alert.show('Insert mode')
            MODE = 'INSERT'
        end
    end)

--Enable: Scroll UP --> 'K'
function scrollUP() hs.eventtap.scrollWheel({0, SPEED}, {}) end
normalPDF:bind({}, 'K', scrollUP, nil, scrollUP)

--Enable: Scroll DOWN --> 'J'
function scrollDOWN() hs.eventtap.scrollWheel({0, -SPEED}, {}) end
normalPDF:bind({}, 'J', scrollDOWN, nil, scrollDOWN)

--Enable: Scroll LEFT --> 'H'
function scrollLEFT() hs.eventtap.scrollWheel({SPEED, 0}, {}) end
normalPDF:bind({}, 'H', scrollLEFT, nil, scrollLEFT)

--Enable: Scroll RIGHT --> 'L'
function scrollRIGHT() hs.eventtap.scrollWheel({-SPEED, 0}, {}) end
normalPDF:bind({}, 'L', scrollRIGHT, nil, scrollRIGHT)

--Enable: Go to TOP --> 'G'
function goTOP() hs.eventtap.keyStroke({'cmd'}, 'Up') end
normalPDF:bind({}, 'G', goTOP)

--Enable: Go to BOTTOM --> 'SHIFT+G'
function goBOTTOM() hs.eventtap.keyStroke({'cmd'}, 'Down') end
normalPDF:bind({'shift'}, 'G', goBOTTOM)

--Enable: Scroll one page foward --> 'Ctrl+f'
function nextPAGE() hs.eventtap.keyStroke({}, 'Right') end
normalPDF:bind({'ctrl'}, 'F', nextPAGE)

--Enable: Scroll one page backwards --> 'Ctrl+b'
function previousPAGE() hs.eventtap.keyStroke({}, 'Left') end
normalPDF:bind({'ctrl'}, 'B', previousPAGE)

-------------------------------------------------------


-------------NORMAL MODE MOVEMENT KEYBINDS-------------

normal:bind({}, 'I',
    function()
        if MODE == 'NORMAL' then
            normal:exit()
            hs.alert.show('Insert mode')
            MODE = 'INSERT'
        end
end)

function moveUP() hs.eventtap.keyStroke({}, 'up') end
normal:bind({}, 'K', moveUP, nil, moveUP)

function moveDOWN() hs.eventtap.keyStroke({}, 'down') end
normal:bind({}, 'J', moveDOWN, nil, moveDOWN)

function moveLEFT() hs.eventtap.keyStroke({}, 'left') end
normal:bind({}, 'H', moveLEFT, nil, moveLEFT)

function moveRIGHT() hs.eventtap.keyStroke({}, 'right') end
normal:bind({}, 'l', moveRIGHT, nil, moveRIGHT)

--normal:bind({}, 'l',
--    function()
--        hs.eventtap.keyStroke({}, 'Right')
--    end,nil,
--    function()
--        hs.eventtap.keyStroke({}, 'Right')
--end)





init()
