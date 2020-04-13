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


---------------------------------------------------------------------
--                  MODE'S KEYBINDS                                --
---------------------------------------------------------------------


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



---------------------------------------------------------------------
--                NORMAL MODE PDF NAVIGATION KEYBINDS              --
---------------------------------------------------------------------

normalPDF:bind({}, 'I',
    function()
        if MODE == 'NORMAL' then
            normalPDF:exit()
            hs.alert.show('Insert mode')
            MODE = 'INSERT'
        end
    end)

--SCROLL UP --> 'k'
function scrollUP() hs.eventtap.scrollWheel({0, SPEED}, {}) end
normalPDF:bind({}, 'K', scrollUP, nil, scrollUP)

--SCROLL DOWN --> 'j'
function scrollDOWN() hs.eventtap.scrollWheel({0, -SPEED}, {}) end
normalPDF:bind({}, 'J', scrollDOWN, nil, scrollDOWN)

--SCROLL LEFT --> 'h'
function scrollLEFT() hs.eventtap.scrollWheel({SPEED, 0}, {}) end
normalPDF:bind({}, 'H', scrollLEFT, nil, scrollLEFT)

--SCROLL RIGHT --> 'l'
function scrollRIGHT() hs.eventtap.scrollWheel({-SPEED, 0}, {}) end
normalPDF:bind({}, 'L', scrollRIGHT, nil, scrollRIGHT)

--GO TO TOP OF PAGE --> 'g'
function goTOP() hs.eventtap.keyStroke({'cmd'}, 'Up') end
normalPDF:bind({}, 'G', goTOP)

--GO TO BOTTOM OF PAGE --> 'g'
function goBOTTOM() hs.eventtap.keyStroke({'cmd'}, 'Down') end
normalPDF:bind({'shift'}, 'G', goBOTTOM)

--SCROLL ONE PAGE FOWARD --> 'ctrl + f'
function nextPAGE() hs.eventtap.keyStroke({}, 'Right', 200) end
normalPDF:bind({'ctrl'}, 'F', nextPAGE, nil, nextPAGE)

--SCROLL ONE PAGE BACKWARD --> 'ctrl + b'
function previousPAGE() hs.eventtap.keyStroke({}, 'Left', 200) end
normalPDF:bind({'ctrl'}, 'B', previousPAGE, nil, previousPAGE)


--INVERT DISPLAY COLORS --> 'ctrl + b'
normalPDF:bind({}, 'S',
    function()
        hs.eventtap.keyStroke({'ctrl', 'option', 'cmd'}, '8')
    end)
--To enable this shortcut, choose Apple menu  > System Preferences, then click Keyboard.
--In the Shortcuts tab, select Accessibility on the left, then select ”Invert colours” on the right.




---------------------------------------------------------------------
--                     NORMAL MODE KEYBINDS                        --
---------------------------------------------------------------------



--MOVE UP --> 'k'
function moveUP() hs.eventtap.keyStroke({}, 'Up', 200) end
normal:bind({}, 'k', nil, moveUP, moveUP)


--MOVE DOWN --> 'j'
function moveDOWN() hs.eventtap.keyStroke({}, 'Down', 200) end
normal:bind({}, 'j', nil, moveDOWN, moveDOWN)


--MOVE LEFT --> 'h'
function moveLEFT() hs.eventtap.keyStroke({}, 'Left', 200) end
normal:bind({}, 'h', nil, moveLEFT, moveLEFT)


--MOVE RIGHT --> 'l'
function moveRIGHT() hs.eventtap.keyStroke({}, 'Right', 200) end
normal:bind({}, 'l', nil, moveRIGHT, moveRIGHT)


--MOVE TO PREVIOUS WORD --> 'b'
function movePrevWord() hs.eventtap.keyStroke({'alt'}, 'left') end
normal:bind({}, 'B', movePrevWord, nil, movePrevWord)


--MOVE TO TOP OF PAGE --> 'g'
normal:bind({}, 'G',
    function()
        hs.eventtap.keyStroke({'cmd'}, 'Up')
    end)


--MOVE TO NEXT WORD --> 'e', 'w'
function moveNextWord() hs.eventtap.keyStroke({'alt'}, 'right') end
normal:bind({}, 'E', moveNextWord, nil, moveNextWord)
normal:bind({}, 'W', moveNextWord, nil, moveNextWord)




--MOVE TO BOTTOM OF PAGE --> 'Shift + g'
normal:bind({'shift'}, 'G',
    function()
        hs.eventtap.keyStroke({'cmd'}, 'Down')
    end)



--MOVE TO END OF LINE --> '$'
normal:bind({'shift'}, '4',
    function()
        hs.eventtap.keyStroke({'ctrl'}, 'e')
    end)


--MOVE CURSOR ONE SPACE FOWARD + INSERT MODE --> 'a'
normal:bind({}, 'A',
    function()
        normal:exit()
        MODE = 'INSERT'
        hs.eventtap.keyStroke({}, 'Right')
    end)


--MOVE TO END OF LINE + INSERT MODE --> 'Shift + a'
normal:bind({'shift'}, 'A',
    function()
        normal:exit()
        MODE = 'INSERT'
        hs.eventtap.keyStroke({'cmd'}, 'right')
    end)


--MOVE TO BEGINNING OF LINE + INSERT MODE --> 'Shift + i'
normal:bind({'shift'}, 'I',
    function()
        normal:exit()
        MODE = 'INSERT'
        hs.eventtap.keyStroke({'cmd'}, 'left')
    end)


--OPEN A NEW LINE ABOVE CURRENT CURSOR LINE + INSERT MODE --> 'o'
normal:bind({'shift'}, 'O', nil,
    function()
        hs.eventtap.keyStroke({'cmd'}, 'Left', 0)
        hs.eventtap.keyStroke({}, 'Return')
        hs.eventtap.keyStroke({}, 'Up')
        normal:exit()
        MODE = 'INSERT'
    end)


--OPEN A NEW LINE BELOW CURRENT CURSOR LINE + INSERT MODE --> 'Shift + o'
normal:bind({}, 'O', nil,
    function()
        hs.eventtap.keyStroke({'cmd'}, 'Right', 0)
        normal:exit()
        MODE = 'INSERT'
        hs.eventtap.keyStroke({}, 'Return')
    end)


--DELETE CHARACTER IN FRONT OF CURSOR --> 'x'
normal:bind({}, 'X',
    function()
        hs.eventtap.keyStroke({'ctrl'}, 'D')
    end)

--move to the next word without delay
function jumpNextWord() hs.eventtap.keyStroke({'alt'}, 'right', 50) end


--DELETE WORD NEXT TO CURSOR --> 'd'
normal:bind({}, 'D',
    function()
        --normal:exit()
        --MODE = 'INSERT'
        jumpNextWord()
        hs.eventtap.keyStroke({'option'}, 'delete')
    end)


--DELETE WORD NEXT TO CURSOR + INSERT MODE --> 'c'
normal:bind({}, 'C',
    function()
        normal:exit()
        MODE = 'INSERT'
        jumpNextWord()
        hs.eventtap.keyStroke({'option'}, 'delete')
    end)


--DELETE UNITIL END OF LINE --> 'Shift + d'
normal:bind({'shift'}, 'D',
    function()
        hs.eventtap.keyStroke({'ctrl'}, 'K')
    end)


--DELETE UNITIL END OF LINE + INSERT MODE --> 'Shift + c'
normal:bind({'shift'}, 'C',
    function()
        normal:exit()
        MODE = 'INSERT'
        hs.eventtap.keyStroke({'ctrl'}, 'K')
    end)


--UNDO --> 'u'
normal:bind({}, 'U',
    function()
        hs.eventtap.keyStroke({'cmd'}, 'Z')
    end)


--REDO --> 'Ctrl + r'
normal:bind({'ctrl'}, 'R',
    function()
        hs.eventtap.keyStroke({'shift', 'cmd'}, 'Z')
    end)


--YANK --> 'y'
normal:bind({}, 'Y',
    function()
        hs.eventtap.keyStroke({'cmd'}, 'C')
    end)

--PASTE --> 'p'
normal:bind({}, 'P',
    function()
        hs.eventtap.keyStroke({'cmd'}, 'V')
    end)


--PASTE ABOVE CURRENT CURSOR LINE --> 'Shift + p'
normal:bind({'shift'}, 'P', nil,
    function()
        hs.eventtap.keyStroke({'cmd'}, 'Left', 1)
        hs.eventtap.keyStroke({}, 'Return')
        hs.eventtap.keyStroke({}, 'Up')
        hs.eventtap.keyStroke({'cmd'}, 'v')
    end)


--Search --> '/'
normal:bind({}, '/',
    function()
        if MODE == 'NORMAL' then
            hs.eventtap.keyStroke({'cmd'}, 'F')
        end
    end)


--SEARCH FOWARD --> 'n'
normal:bind({}, 'n',
    function()
        hs.eventtap.keyStroke({'cmd'}, 'G')
    end)


--SEARCH BACKWARDS --> 'n'
normal:bind({'shift'}, 'n',
    function()
        hs.eventtap.keyStroke({'shift', 'cmd'}, 'G')
    end)


--ENTER INSERT MODE --> 'n'
normal:bind({}, 'I',
    function()
        if MODE == 'NORMAL' then
            normal:exit()
            hs.alert.show('Insert mode')
            MODE = 'INSERT'
        end
end)

--Bind: Placebo key
normal:bind({}, 'Q',
    function()
end)




init()
