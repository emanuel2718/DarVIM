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
    --normalMode:disable()
    --normalModePDF:disable()

    --If we are readign a PDF
    if name == 'Preview' then
        --If the is begin focused
        if event == hs.application.watcher.activated then
            --insertMode:enable()
            --visualMode:enable()
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
                --visualMode:disable()
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
            --visualMode:enable()
            normalModePDF:disable()
            normalMode:enable()
            normal:enter()
        end
        if event == hs.application.watcher.deactivated then
            if not contains(APPS, hs.window.frontmostWindow():application():name()) then
                --normal:exit()
                --insertMode:disable()
                --visualMode:disable()
                normalModePDF:disable()
                normalMode:disable()
            end
            normal:exit()
        end
    --end
    elseif not contains(APPS, hs.window.frontmostWindow():application():name()) then
        --TODO: This is throwing nil values.
        normalModePDF:disable()
        normalMode:disable()
    end
end


    --------------------MODE'S KEYBINDS--------------------

--Bind Normal Mode for regular apps like Slack, Discord, Notes
normalMode = hs.hotkey.bind({}, 'Escape',
function()
    --Do this ONLY if we are in 'Insert' or 'Visual' mode.
    if MODE ~= 'NORMAL' then
        normal:enter() 
        hs.alert.show('Normal mode')
        MODE = 'NORMAL'
    end
end)

--Bind Normal mode for PDF's key
normalModePDF = hs.hotkey.bind({}, 'Escape',
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
--visualMode = hs.hotkey.bind({}, "V",
--function()
--    --Do this ONLY if we are in 'Normal' mode.
--    if MODE == 'NORMAL' then
--        normalPDF:exit()
--        visual:enter() 
--        hs.alert.show('Visual mode')
--        MODE = 'VISUAL'
--    end
--end)

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

--Bind: Scroll UP --> 'K'
function scrollUP() hs.eventtap.scrollWheel({0, SPEED}, {}) end
normalPDF:bind({}, 'K', scrollUP, nil, scrollUP)

--Bind: Scroll DOWN --> 'J'
function scrollDOWN() hs.eventtap.scrollWheel({0, -SPEED}, {}) end
normalPDF:bind({}, 'J', scrollDOWN, nil, scrollDOWN)

--Bind: Scroll LEFT --> 'H'
function scrollLEFT() hs.eventtap.scrollWheel({SPEED, 0}, {}) end
normalPDF:bind({}, 'H', scrollLEFT, nil, scrollLEFT)

--Bind: Scroll RIGHT --> 'L'
function scrollRIGHT() hs.eventtap.scrollWheel({-SPEED, 0}, {}) end
normalPDF:bind({}, 'L', scrollRIGHT, nil, scrollRIGHT)

--Bind: Go to TOP --> 'G'
function goTOP() hs.eventtap.keyStroke({'cmd'}, 'Up') end
normalPDF:bind({}, 'G', goTOP)

--Bind: Go to BOTTOM --> 'SHIFT+G'
function goBOTTOM() hs.eventtap.keyStroke({'cmd'}, 'Down') end
normalPDF:bind({'shift'}, 'G', goBOTTOM)

--Bind: Scroll one page foward --> 'Ctrl+f'
function nextPAGE() hs.eventtap.keyStroke({}, 'Right', 200) end
normalPDF:bind({'ctrl'}, 'F', nextPAGE, nil, nextPAGE)

--Bind: Scroll one page backwards --> 'Ctrl+b'
function previousPAGE() hs.eventtap.keyStroke({}, 'Left', 200) end
normalPDF:bind({'ctrl'}, 'B', previousPAGE, nil, previousPAGE)

-------------------------------------------------------


-------------NORMAL MODE MOVEMENT KEYBINDS-------------

--Bind: 'I' for insert mode
normal:bind({}, 'I',
    function()
        if MODE == 'NORMAL' then
            normal:exit()
            hs.alert.show('Insert mode')
            MODE = 'INSERT'
        end
end)


--Bind: Move UP --> 'K'
function moveUP() hs.eventtap.keyStroke({}, 'Up', 200) end
normal:bind({}, 'k', nil, moveUP, moveUP)

--Bind: Move DOWN --> 'J'
function moveDOWN() hs.eventtap.keyStroke({}, 'Down', 200) end
normal:bind({}, 'j', nil, moveDOWN, moveDOWN)

--Bind: Move LEFT --> 'L'
function moveLEFT() hs.eventtap.keyStroke({}, 'Left', 200) end
normal:bind({}, 'h', nil, moveLEFT, moveLEFT)

--Bind: Move RIGHT --> 'R'
function moveRIGHT() hs.eventtap.keyStroke({}, 'Right', 200) end
normal:bind({}, 'l', nil, moveRIGHT, moveRIGHT)

--Bind: Move to the NEXT word --> 'E' or 'W'
function moveNextWord() hs.eventtap.keyStroke({'alt'}, 'right') end
normal:bind({}, 'E', moveNextWord, nil, moveNextWord)
normal:bind({}, 'W', moveNextWord, nil, moveNextWord)

--Bind: Move to the PREVIOUS word --> 'B'
function movePrevWord() hs.eventtap.keyStroke({'alt'}, 'left') end
normal:bind({}, 'B', movePrevWord, nil, movePrevWord)

--Bind: Placebo key
normal:bind({}, 'Q',
    function()
end)


--Bind: Move to the top of the page --> 'G'
normal:bind({}, 'G',
    function()
        hs.eventtap.keyStroke({'cmd'}, 'Up')
        if hs.eventtap.event:getKeyCode() == 87 then
            hs.alert.show('CW')
        end
    end)

--Bind: Move to the bottom of the page --> 'Shift + G'
normal:bind({'shift'}, 'G',
    function()
        hs.eventtap.keyStroke({'cmd'}, 'Down')
    end)

--Bind: Move to the end of the line --> '$'
normal:bind({'shift'}, '4',
    function()
        hs.eventtap.keyStroke({'ctrl'}, 'e')
    end)


--Bind: Move to the end of the line in Insert mode --> 'Shift + A'
normal:bind({'shift'}, 'A',
    function()
        normal:exit()
        MODE = 'INSERT'
        hs.eventtap.keyStroke({'cmd'}, 'right')
    end)


--Bind: Move cursor foward one space in Insert mode --> 'A'
normal:bind({}, 'A',
    function()
        normal:exit()
        MODE = 'INSERT'
        hs.eventtap.keyStroke({}, 'Right')
    end)

--Bind: Move to the beginning of the line in Insert mode --> 'Shift + I'
normal:bind({'shift'}, 'I',
    function()
        normal:exit()
        MODE = 'INSERT'
        hs.eventtap.keyStroke({'cmd'}, 'left')
    end)


--Bind: Open a new line BELOW the current cursor line --> 'O'
normal:bind({}, 'O', nil,
    function()
        hs.eventtap.keyStroke({'cmd'}, 'Right', 0)
        normal:exit()
        MODE = 'INSERT'
        hs.eventtap.keyStroke({}, 'Return')
    end)

--Bind: Open a new line ABOVE the current cursor line --> 'Shift + O'
normal:bind({'shift'}, 'O', nil,
    function()
        hs.eventtap.keyStroke({'cmd'}, 'Left', 0)
        hs.eventtap.keyStroke({}, 'Return')
        hs.eventtap.keyStroke({}, 'Up')
        normal:exit()
        MODE = 'INSERT'
    end)


    -----------DELETE-----------
--Bind: Delete character in front of cursor --> 'X'
normal:bind({}, 'X',
    function()
        hs.eventtap.keyStroke({'ctrl'}, 'D')
    end)


--Bind: Delete until end of line --> 'Shift + D'
normal:bind({'shift'}, 'D',
    function()
        hs.eventtap.keyStroke({'ctrl'}, 'K')
    end)

--Bind: Delete until end of line and put us in Insert Mode--> 'Shift + C'
normal:bind({'shift'}, 'C',
    function()
        normal:exit()
        MODE = 'INSERT'
        hs.eventtap.keyStroke({'ctrl'}, 'K')
    end)

--move to the next word without delay and delte backwards
function jumpNextWord() hs.eventtap.keyStroke({'alt'}, 'right', 50) end

--Bind: Delete word next to cursor --> 'd'
normal:bind({}, 'D',
    function()
        --normal:exit()
        --MODE = 'INSERT'
        jumpNextWord()
        hs.eventtap.keyStroke({'option'}, 'delete')
    end)

--Bind: Delete word next to cursor and put us in insert mode --> 'c'
normal:bind({}, 'C',
    function()
        normal:exit()
        MODE = 'INSERT'
        jumpNextWord()
        hs.eventtap.keyStroke({'option'}, 'delete')
    end)

-------------------------------------------------

--Bind: Undo --> 'U'
normal:bind({}, 'U',
    function()
        hs.eventtap.keyStroke({'cmd'}, 'Z')
    end)

--Bind: Redo --> 'ctrl-u'
normal:bind({'ctrl'}, 'R',
    function()
        hs.eventtap.keyStroke({'shift', 'cmd'}, 'Z')
    end)


--Bind: Paste --> 'P'
normal:bind({}, 'Y',
    function()
        hs.eventtap.keyStroke({'cmd'}, 'C')
    end)

--Bind: Paste --> 'P'
normal:bind({}, 'P',
    function()
        hs.eventtap.keyStroke({'cmd'}, 'V')
    end)


--Bind: Paste ABOVE the current cursor line --> 'Shift + P'
normal:bind({'shift'}, 'P', nil,
    function()
        hs.eventtap.keyStroke({'cmd'}, 'Left', 1)
        hs.eventtap.keyStroke({}, 'Return')
        hs.eventtap.keyStroke({}, 'Up')
        hs.eventtap.keyStroke({'cmd'}, 'v')
    end)



--Bind: Find --> '/'
normal:bind({}, '/',
    function()
        if MODE == 'NORMAL' then
            hs.eventtap.keyStroke({'cmd'}, 'F')
        end
    end)

--Bind: Find: Go to NEXT ocurrence --> 'n'
normal:bind({}, 'n',
    function()
        hs.eventtap.keyStroke({'cmd'}, 'G')
    end)

--Bind: Find: Go to PREVIOUS ocurrence --> 'Shift + n'
normal:bind({'shift'}, 'n',
    function()
        hs.eventtap.keyStroke({'shift', 'cmd'}, 'G')
    end)






init()
