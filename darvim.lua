-- Author  : Emanuel Ramirez Alsina
-- Project : DarVIM


--TODO: Add variable that let the user decide: Mode alerts ON/OFF

--Scrolling speed
local SPEED = 3

--Key press delay in ms.
local delay = 1

local barIcon = hs.menubar.new()


--Normal Mode
local normal = hs.hotkey.modal.new()
local normalPDF = hs.hotkey.modal.new()


--Visual Mode
local visual = hs.hotkey.modal.new()


--List of supported Applications
--The user could add or remove applications as desired.
local APPS = {'Preview', 'Slack', 'Discord', 'Notes', 'Acrobat Reader', 'Anki', 'Xcode'}
local PDF = {'Preview', 'Acrobat Reader'}


-- If you have the dock showing at all time and in the bottom, having
-- notification on the bottom might be an issue. To change their placement:
--      Center of screen: atScreenEdge=0
--      Top of screen: atScreenEdge=1
--      Bottom of screen: atScreenEdge=2
local alertStyle = {
                textSize    = 18,
                strokeWidth = 2,
                strokeColor = { white = 0, alpha = 1 },
                fillColor   = { white = 0, alpha = 0.85 },
                textColor   = { white = 1, alpha = 1 },
                textFont    = '.AppleSystemUIFont',
                radius      = 10,
                atScreenEdge= 0}



--Mode's notification text
local normalNotification = 'NORMAL'
local insertNotification = 'INSERT'
local visualNotification = 'VISUAL'

local keys = {}
local mods = {}

--In charge of keeping track if a whole line was yanked or a portion (i.e word)
--When this is true; paste will open a new line (above or below) and paste line
--When this is false; paste will paste in place
local wholeLineYanked = false


function init()
    appsWatcher = hs.application.watcher.new(applicationWatcher)
    appsWatcher:start()
end

--Checks if the currently focused applications is in the list of supported apps
function contains(APP, name)
    for i, app in ipairs(APP) do
        if APP[i] == name then
            return true
        end
    end
    return false
end

function setBarIcon(state)
    if state == 'VISUAL' then
        barIcon:setTitle('V')
    elseif state == 'INSERT' then
        barIcon:setTitle('I')
    elseif state == 'NORMAL' then
        barIcon:setTitle('N')
    else
        barIcon:setTitle('')
    end
end

--function barIconClicked()
--    setBarIcon(hs.caffeinate.toggle('CLICKED'))
--end
--
--if barIcon then
--    barIcon:setClickCallback(barIconClicked)
--    setBarIcon(hs.caffeinate.get('CLICKED'))
--end



--Saves the last modifiers and/or key used by the user.
function lastOperation(mod, command)
    keys[0] = command
    mods[0] = mod
end




function applicationWatcher(name, event, app)

    --If we are readign a PDF
    if contains(PDF, name) then
        --If the is begin focused
        if event == hs.application.watcher.activated then
            normalMode:disable()
            normalModePDF:enable()
            normalPDF:enter()
            setBarIcon('NORMAL')
        end
        --We lost focus of the PDF window
        if event == hs.application.watcher.deactivated then
            --If the focused window is one where we don't want VIM keybinds
            --restriction (i.e Terminal)
            if not contains(APPS, hs.window.frontmostWindow():application():name()) then
                normalModePDF:disable()
                setBarIcon('')
            end
            normalPDF:exit()
            visual:exit()
        end
    end

    --For apps like Slack, Discord, Notes, etc.
    --We dont want scrolling features like in Preview. We want 'hjkl' to behave
    --like arrows to edit text.
    if contains(APPS, name) and not(contains(PDF, name)) then
        if event == hs.application.watcher.activated then
            normalModePDF:disable()
            normalMode:enable()
            normal:enter()
            setBarIcon('NORMAL')
        end
        if event == hs.application.watcher.deactivated then
            if not contains(APPS, hs.window.frontmostWindow():application():name()) then
                normalModePDF:disable()
                normalMode:disable()
                setBarIcon('')
            end
            normal:exit()
            visual:exit()
        end
    --end
    elseif not contains(APPS, hs.window.frontmostWindow():application():name()) then
        --TODO: This is throwing nil values.
        normalModePDF:disable()
        normalMode:disable()
        setBarIcon('')
    end
end


---------------------------------------------------------------------
--                  MODE'S KEYBINDS                                --
---------------------------------------------------------------------


--NORMAL: ENABLE NORMAL MODE --> 'Escape'
normalMode = hs.hotkey.bind({}, 'Escape',
function()
    normal:enter() 
    --hs.alert.closeAll()
    setBarIcon('NORMAL')
    --hs.alert.show(normalNotification, alertStyle)
end)

--NORMAL: ENABLE NORMAL MODE IN PDF'S --> 'Escape'
normalModePDF = hs.hotkey.bind({}, 'Escape',
function()
    normalPDF:enter() 
    setBarIcon('NORMAL')
    --hs.alert.closeAll()
    --hs.alert.show(normalNotification, alertStyle)
end)

--NORMAL: ENABLE VISUAL MODE --> 'v'
normal:bind({}, 'v',
    function()
        setBarIcon('VISUAL')
        normal:exit()
        visual:enter()
        --hs.alert.closeAll()
        --hs.alert.show(visualNotification, alertStyle)
    end)

--NORMAL: ENTER INSERT MODE --> 'n'
normal:bind({}, 'I',
    function()
        normal:exit()
        --hs.alert.closeAll()
        --hs.alert.show(insertNotification, alertStyle)
        setBarIcon('INSERT')
    end)



---------------------------------------------------------------------
--                NORMAL MODE PDF NAVIGATION KEYBINDS              --
---------------------------------------------------------------------


--NORMAL PDF: ENABLE INSERT MODE --> 'i'
normalPDF:bind({}, 'I',
    function()
        normalPDF:exit()
        setBarIcon('INSERT')
        --hs.alert.show(insertNotification, alertStyle)
    end)


--NORMALPDF: SCROLL UP --> 'k'
function scrollUP() hs.eventtap.scrollWheel({0, SPEED}, {}) end
normalPDF:bind({}, 'K', scrollUP, nil, scrollUP)


--NORMALPDF: SCROLL DOWN --> 'j'
function scrollDOWN() hs.eventtap.scrollWheel({0, -SPEED}, {}) end
normalPDF:bind({}, 'J', scrollDOWN, nil, scrollDOWN)


--NORMALPDF: SCROLL LEFT --> 'h'
function scrollLEFT() hs.eventtap.scrollWheel({SPEED, 0}, {}) end
normalPDF:bind({}, 'H', scrollLEFT, nil, scrollLEFT)


--NORMALPDF: SCROLL RIGHT --> 'l'
function scrollRIGHT() hs.eventtap.scrollWheel({-SPEED, 0}, {}) end
normalPDF:bind({}, 'L', scrollRIGHT, nil, scrollRIGHT)


--NORMALPDF: GO TO TOP OF PAGE --> 'g'
function goTOP() hs.eventtap.keyStroke({'cmd'}, 'Up') end
normalPDF:bind({}, 'G', goTOP)


--NORMALPDF: GO TO BOTTOM OF PAGE --> 'g'
function goBOTTOM() hs.eventtap.keyStroke({'cmd'}, 'Down') end
normalPDF:bind({'shift'}, 'G', goBOTTOM)


--NORMALPDF: SCROLL ONE PAGE FOWARD --> 'ctrl + f'
function nextPAGE() hs.eventtap.keyStroke({}, 'Right', delay) end
normalPDF:bind({'ctrl'}, 'F', nextPAGE, nil, nextPAGE)


--NORMALPDF: SCROLL ONE PAGE BACKWARD --> 'ctrl + b'
function previousPAGE() hs.eventtap.keyStroke({}, 'Left', delay) end
normalPDF:bind({'ctrl'}, 'B', previousPAGE, nil, previousPAGE)


--NORMALPDF: INVERT DISPLAY COLORS --> 't'
normalPDF:bind({}, 's',
    function()
        hs.eventtap.keyStroke({'ctrl', 'option', 'cmd'}, '8')
    end)
--To enable this shortcut, choose Apple menu  > System Preferences, then click Keyboard.
--In the Shortcuts tab, select Accessibility on the left, then select ”Invert colours” on the right.




---------------------------------------------------------------------
--                     NORMAL MODE KEYBINDS                        --
---------------------------------------------------------------------



--NORMAL: MOVE UP --> 'k'
function moveUP() hs.eventtap.keyStroke({}, 'Up', delay) end
normal:bind({}, 'k', nil, moveUP, moveUP)


--NORMAL: MOVE DOWN --> 'j'
function moveDOWN() hs.eventtap.keyStroke({}, 'Down', delay) end
normal:bind({}, 'j', nil, moveDOWN, moveDOWN)


--NORMAL: MOVE LEFT --> 'h'
function moveLEFT() hs.eventtap.keyStroke({}, 'Left', delay) end
normal:bind({}, 'h', nil, moveLEFT, moveLEFT)


--NORMAL: MOVE RIGHT --> 'l'
function moveRIGHT() hs.eventtap.keyStroke({}, 'Right', delay) end
normal:bind({}, 'l', nil, moveRIGHT, moveRIGHT)


--NORMAL: SCROLL UP --> 'ctrl + y'
function scrollUP() hs.eventtap.scrollWheel({0, SPEED}, {}) end
normal:bind({'ctrl'}, 'y', scrollUP, nil, scrollUP)


--NORMAL: SCROLL DOWN --> 'ctrl + e'
function scrollDOWN() hs.eventtap.scrollWheel({0, -SPEED}, {}) end
normal:bind({'ctrl'}, 'e', scrollDOWN, nil, scrollDOWN)


--NORMAL: MOVE TO PREVIOUS WORD --> 'b'
function movePrevWord() hs.eventtap.keyStroke({'alt'}, 'left', delay) end
normal:bind({}, 'B', movePrevWord, nil, movePrevWord)


--NORMAL: MOVE TO TOP OF PAGE --> 'g'
normal:bind({}, 'G',
    function()
        hs.eventtap.keyStroke({'cmd'}, 'Up', delay)
    end)


--NORMAL: MOVE TO BOTTOM OF PAGE --> 'Shift + g'
normal:bind({'shift'}, 'G',
    function()
        hs.eventtap.keyStroke({'cmd'}, 'Down', delay)
    end)


--NORMAL: MOVE TO NEXT WORD --> 'w'
function moveNextWord() hs.eventtap.keyStroke({'alt'}, 'right', delay) end
normal:bind({}, 'w', moveNextWord, nil, moveNextWord)


--NORMAL: MOVE TO END OF WORD --> 'e'
function moveEndOfWord()
    hs.eventtap.keyStroke({'alt'}, 'right', delay)
    --hs.eventtap.keyStroke({}, 'left', 50)
end
normal:bind({}, 'e', moveEndOfWord, nil, moveEndOfWord)


--NORMAL: MOVE TO END OF LINE --> '$'
normal:bind({'shift'}, '4',
    function()
        hs.eventtap.keyStroke({'ctrl'}, 'e', delay)
    end)


--NORMAL: MOVE CURSOR ONE SPACE FOWARD + INSERT MODE --> 'a'
normal:bind({}, 'A',
    function()
        normal:exit()
        hs.eventtap.keyStroke({}, 'Right', delay)
        setBarIcon('INSERT')
    end)


--NORMAL: MOVE TO END OF LINE + INSERT MODE --> 'Shift + a'
normal:bind({'shift'}, 'A',
    function()
        normal:exit()
        --MODE = 'INSERT'
        hs.eventtap.keyStroke({'cmd'}, 'right', delay)
        setBarIcon('INSERT')
    end)


--NORMAL: MOVE TO BEGINNING OF LINE + INSERT MODE --> 'Shift + i'
normal:bind({'shift'}, 'I',
    function()
        normal:exit()
        hs.eventtap.keyStroke({'cmd'}, 'left', delay)
        setBarIcon('INSERT')
    end)


--NORMAL: OPEN A NEW LINE ABOVE CURRENT CURSOR LINE + INSERT MODE --> 'o'
normal:bind({'shift'}, 'O', nil,
    function()
        hs.eventtap.keyStroke({'cmd'}, 'Left', delay)
        hs.eventtap.keyStroke({'shift'}, 'Return', delay)
        hs.eventtap.keyStroke({}, 'Up', delay)
        normal:exit()
        setBarIcon('INSERT')
        lastOperation('shift', 'o')
    end)


--NORMAL: OPEN A NEW LINE BELOW CURRENT CURSOR LINE + INSERT MODE --> 'Shift + o'
normal:bind({}, 'O', nil,
    function()
        hs.eventtap.keyStroke({'cmd'}, 'Right', delay)
        hs.eventtap.keyStroke({'shift'}, 'Return', delay)
        normal:exit()
        setBarIcon('INSERT')
        lastOperation('', 'o')
    end)


--NORMAL: DELETE CHARACTER IN FRONT OF CURSOR --> 'x'
function deleteNextChar()
    hs.eventtap.keyStroke({}, 'forwarddelete', delay)
    lastOperation('', 'x')
end
normal:bind({}, 'x', deleteNextChar, nil, deleteNextChar)


--NORMAL: DELETE CHARACTER IN FRONT OF CURSOR + INSERT MODE--> 's'
normal:bind({}, 's',
    function()
        hs.eventtap.keyStroke({}, 'forwarddelete', delay)
        normal:exit()
        setBarIcon('INSERT')
        lastOperation('', 's')
    end)

--NORMAL: SUBSTITUTE ENTIRE LINE-DELTES LINE + INSERT MODE --> 'Shift + s'
normal:bind({'shift'}, 's',
    function()
        normal:exit()
        hs.eventtap.keyStroke({'shift', 'cmd'}, 'Right', delay)
        hs.eventtap.keyStroke({'cmd'}, 'c', delay)
        hs.eventtap.keyStroke({'fn'}, 'delete', delay)
        setBarIcon('INSERT')
        lastOperation('shift', 's')
        wholeLineYanked = true
    end)


--TODO: Need to fix this like in native VIM: Replace -> Get Char -> Type Char--(While still in Normal Mode)
--NORMAL: REPLACE CHARACTER IN FRONT OF CURSOR + INSERT MODE--> 'x'
normal:bind({}, 'r',
    function()
        deleteNextChar()
        normal:exit()
        setBarIcon('INSERT')
        --TODO: Add correct repetition...
    end)


--NORMAL: move to the next word without delay
function jumpNextWord() hs.eventtap.keyStroke({'alt'}, 'right', delay) end


--TODO: Fix bug: If there is empty space between the cursor position and the
--next character...it will jump to that next word and delete it instead of
--deleting the space in betwen like in Native VIM.
--Make 'D' behave like 'dw' or 'dd'?
--For 'dw' we have 'C', do I want both? Do I have something that does 'dd'?


--NORMAL: DELETE WORD --> 'd'
normal:bind({}, 'd',
    function()
        hs.eventtap.keyStroke({'shift', 'option'}, 'Right', delay)
        hs.eventtap.keyStroke({'cmd'}, 'c', delay)
        hs.eventtap.keyStroke({''}, 'delete', delay)
        lastOperation('', 'd')
        wholeLineYanked = false
    end)


--NORMAL: DELETE WHOLE LINE --> 'Ctrl + d'
normal:bind({'ctrl'}, 'd',
    function()
        hs.eventtap.keyStroke({'cmd'}, 'Left', delay)
        hs.eventtap.keyStroke({'shift', 'cmd'}, 'Right', delay)
        hs.eventtap.keyStroke({'cmd'}, 'c', delay)
        hs.eventtap.keyStroke({''}, 'delete', delay)
        lastOperation('ctrl', 'd')
        wholeLineYanked = true
    end)


--NORMAL: CHANGE WORD --> 'c'
normal:bind({}, 'c',
    function()
        normal:exit()
        jumpNextWord()
        --TODO: implement copy to clipboard
        hs.eventtap.keyStroke({'option'}, 'delete', delay)
        setBarIcon('INSERT')
        lastOperation('', 'c')
        wholeLineYanked = false
    end)


--NORMAL: CHANGE WORD --> 'ctrl + d'
normal:bind({'ctrl'}, 'c',
    function()
        normal:exit()
        hs.eventtap.keyStroke({'cmd'}, 'Left', delay)
        hs.eventtap.keyStroke({'shift', 'cmd'}, 'Right', delay)
        hs.eventtap.keyStroke({''}, 'delete', delay)
        setBarIcon('INSERT')
        lastOperation('ctrl', 'c')
        wholeLineYanked = false
    end)


--NORMAL: DELETE UNITIL END OF LINE --> 'Shift + d'
normal:bind({'shift'}, 'd',
    function()
        hs.eventtap.keyStroke({'shift', 'cmd'}, 'Right', delay)
        hs.eventtap.keyStroke({'cmd'}, 'c', delay)
        hs.eventtap.keyStroke({'fn'}, 'delete', delay)
        lastOperation('shift', 'd')
        wholeLineYanked = false
    end)


--NORMAL: DELETE UNITIL END OF LINE + INSERT MODE --> 'Shift + c'
normal:bind({'shift'}, 'C',
    function()
        normal:exit()
        hs.eventtap.keyStroke({'shift', 'cmd'}, 'Right', delay)
        hs.eventtap.keyStroke({'cmd'}, 'c', delay)
        hs.eventtap.keyStroke({'fn'}, 'delete', delay)
        setBarIcon('INSERT')
        lastOperation('shift', 'c')
        wholeLineYanked = false
    end)


--NORMAL: UNDO --> 'u'
normal:bind({}, 'U',
    function()
        hs.eventtap.keyStroke({'cmd'}, 'Z', delay)
    end)


--NORMAL: REDO --> 'Ctrl + r'
normal:bind({'ctrl'}, 'R',
    function()
        hs.eventtap.keyStroke({'shift', 'cmd'}, 'Z', delay)
    end)


normal:bind({}, 'Y',
    function()
        hs.eventtap.keyStroke({'cmd'}, 'Left', delay)
        hs.eventtap.keyStroke({'shift', 'cmd'}, 'Right', delay)
        hs.eventtap.keyStroke({'cmd'}, 'c', delay)
        wholeLineYanked = false
    end)


--NORMAL: YANK WHOLE LINE --> 'Shift + y'
normal:bind({'shift'}, 'y',
    function()
        hs.eventtap.keyStroke({'shift', 'cmd'}, 'Right', delay)
        hs.eventtap.keyStroke({'cmd'}, 'c', delay)
        wholeLineYanked = true
    end)


--NORMAL: PASTE BELOW CURRENT CURSOR LINE --> 'p'
normal:bind({}, 'P',
    function()
        if wholeLineYanked then
            hs.eventtap.keyStroke({'cmd'}, 'Right', delay)
            hs.eventtap.keyStroke({}, 'Return', delay)
            hs.eventtap.keyStroke({'cmd'}, 'v', delay)
            lastOperation('', 'p')
        else
            hs.eventtap.keyStroke({'cmd'}, 'v', delay)
            lastOperation('', 'p')
        end
    end)


--NORMAL: PASTE ABOVE CURRENT CURSOR LINE --> 'Shift + p'
normal:bind({'shift'}, 'P', nil,
    function()
        hs.eventtap.keyStroke({'cmd'}, 'Left', delay)
        hs.eventtap.keyStroke({}, 'Return', delay)
        hs.eventtap.keyStroke({}, 'Up', delay)
        hs.eventtap.keyStroke({'cmd'}, 'v', delay)
        lastOperation('shift', 'p')
    end)


--NORMAL: Search --> '/'
normal:bind({}, '/',
    function()
        hs.eventtap.keyStroke({'cmd'}, 'F', delay)
        normal:exit()
        hs.alert.closeAll()
        hs.alert.show(insertNotification, alertStyle)
        setBarIcon('INSERT')
    end)


--NORMAL: SEARCH FOWARD --> 'n'
normal:bind({}, 'n',
    function()
        hs.eventtap.keyStroke({'cmd'}, 'G', delay)
    end)


--NORMAL: SEARCH BACKWARDS --> 'n'
normal:bind({'shift'}, 'n',
    function()
        hs.eventtap.keyStroke({'shift', 'cmd'}, 'G', delay)
    end)


--NORMAL: INDENT FOWARD --> '>'
normal:bind({'shift'}, '.',
    function()
        hs.eventtap.keyStroke({'cmd'}, 'Left', delay)
        hs.eventtap.keyStroke({}, 'Tab', nil, 'Tab', delay)
        lastOperation('shift', '.')
    end)


--NORMAL: INDENT BACKWARDS --> '<'
normal:bind({'shift'}, ',',
    function()
        hs.eventtap.keyStroke({'cmd'}, 'Right', delay)
        hs.eventtap.keyStroke({'shift'}, 'Tab', delay)
        lastOperation('shift', ',')
    end)



--NORMAL: HIGHLIGHT COMPLETE LINE + VISUAL --> 'v'
normal:bind({'shift'}, 'v',
    function()
        normal:exit()
        visual:enter()
        hs.eventtap.keyStroke({'cmd'}, 'Left', delay)
        hs.eventtap.keyStroke({'shift', 'cmd'}, 'Right', delay)
        --hs.alert.closeAll()
        --hs.alert.show(visualNotification, alertStyle)
        setBarIcon('VISUAL')
    end)


--NORMAL: Bind: Placebo key
normal:bind({}, 'Q',
    function()
end)


--NORMAL: REPEAT LAST COMMAND
normal:bind({}, '.', 
    function()
        if keys[0] ~= nil then
            hs.eventtap.keyStroke({mods[0]}, keys[0], delay)
            hs.eventtap.keyStroke({}, 'Escape', delay) --To deal with cases that put us in Insert
        end
    end, nil,
    function()
        hs.eventtap.keyStroke({mods[0]}, keys[0], delay)
        hs.eventtap.keyStroke({}, 'Escape', delay)
    end)


--RELOADS HAMMERSPOON CONFIGURATION
hs.hotkey.bind({'shift', 'option', 'cmd'}, 'r',
    function()
        focusedWindow = hs.window.frontmostWindow():application():name()
        hammerspoonWindow = hs.window.get('Hammerspoon Console')
        hs.application.launchOrFocus('Hammerspoon')
        hs.eventtap.keyStroke({'shift', 'cmd'}, 'r', delay)
        hs.alert.show('Configuration reloaded', alertStyle)
        hs.application.launchOrFocus(focusedWindow)
    end)

---------------------------------------------------------------------
--                          VISUAL MODE                            --
---------------------------------------------------------------------


--VISUAL: MOVE UP --> 'k'
function visualUP() hs.eventtap.keyStroke('shift', 'Up', delay) end
visual:bind({}, 'k', visualUP, nil, visualUP)


--VISUAL: MOVE DOWN --> 'j'
function visualDOWN() hs.eventtap.keyStroke('shift', 'Down', delay) end
visual:bind({}, 'j', visualDOWN, nil, visualDOWN)


--VISUAL: MOVE LEFT --> 'h'
function visualLEFT() hs.eventtap.keyStroke('shift', 'Left', delay) end
visual:bind({}, 'h', visualLEFT, nil, visualLEFT)


--VISUAL: MOVE DOWN --> 'l'
function visualRIGHT() hs.eventtap.keyStroke('shift', 'Right', delay) end
visual:bind({}, 'l', visualRIGHT, nil, visualRIGHT)


--VISUAL: MOVE TO END OF WORD --> 'e'
function visualEndOfWord() 
    hs.eventtap.keyStroke({'shift', 'alt'}, 'right', delay)
    hs.eventtap.keyStroke({'shift'}, 'Left', delay)
end
visual:bind({}, 'E', visualEndOfWord, nil, visualEndOfWord)


--VISUAL: MOVE TO NEXT WORD --> 'w'
function visualNextWord() 
    hs.eventtap.keyStroke({'shift', 'alt'}, 'right', delay)
end

visual:bind({}, 'W', visualNextWord, nil, visualNextWord)


--VISUAL: YANK AND TAKE US TO NORMAL MODE --> 'y'
visual:bind({}, 'Y',
    function()
        hs.eventtap.keyStroke({'cmd'}, 'c', delay)
        hs.eventtap.keyStroke({}, 'Right', delay)
        visual:exit()
        normal:enter()
        setBarIcon('NORMAL')
    end)



--VISUAL: HIGHLIGHT FROM CURSOR UNTIL BEGINNING OF LINE --> '0'
visual:bind({}, '0',
    function()
        hs.eventtap.keyStroke({'shift', 'cmd'}, 'Left', delay)
    end)


--VISUAL: HIGHLIGHT FROM CURSOR UNTIL BEGINNING OF FILE --> 'Shift + h'
visual:bind({'shift'}, 'h',
    function()
        hs.eventtap.keyStroke({'shift', 'cmd'}, 'Up', delay)
    end)


--VISUAL: HIGHLIGHT FROM CURSOR UNTIL BEGINNING OF FILE --> 'g'
visual:bind({}, 'g',
    function()
        hs.eventtap.keyStroke({'shift', 'cmd'}, 'Up', delay)
    end)


--VISUAL: HIGHLIGHT FROM CURSOR UNTIL END OF FILE --> 'Shift + g'
visual:bind({'shift'}, 'g',
    function()
        hs.eventtap.keyStroke({'shift', 'cmd'}, 'Down', delay)
    end)


--VISUAL: HIGHLIGHT FROM CURSOR UNTIL END OF FILE --> 'Shift + l'
visual:bind({'shift'}, 'l',
    function()
        hs.eventtap.keyStroke({'shift', 'cmd'}, 'Down', delay)
    end)


--VISUAL: HIGHLIGHT FROM CURSOR UNTIL END OF Line --> '$'
visual:bind({'shift'}, '4',
    function()
        hs.eventtap.keyStroke({'shift', 'cmd'}, 'Right', delay)
    end)



--VISUAL: DELETE HIGHLIGHTED CHARACTERS --> 'x'
visual:bind({}, 'x', 
    function()
        visual:exit()
        normal:enter()
        deleteNextChar()
        setBarIcon('NORMAL')
        lastOperation('', 'x')
    end)

--VISUAL: DELETE HIGHLIGHTED CHARACTERS --> 'd'
visual:bind({}, 'd', 
    function()
        visual:exit()
        normal:enter()
        hs.eventtap.keyStroke({''}, 'delete', delay)
        setBarIcon('NORMAL')
        lastOperation('', 'd')
    end)


--VISUAL: CHANGE HIGHLIGHTED CHARACTERS --> 'c'
visual:bind({}, 'c', 
    function()
        visual:exit()
        hs.eventtap.keyStroke({''}, 'delete', delay)
        setBarIcon('INSERT')
        lastOperation('', 'c')
    end)


--VISUAL: INDENT FOWARD --> '>'
visual:bind({'shift'}, '.',
    function()
        hs.eventtap.keyStroke({'cmd'}, 'Left', delay)
        hs.eventtap.keyStroke({}, 'Tab', nil, 'Tab', delay)
        visual:exit()
        normal:enter()
        lastOperation('shift', '.')
    end)

--VISUAL: INDENT BACKWARDS --> '<'
visual:bind({'shift'}, ',',
    function()
        hs.eventtap.keyStroke({'cmd'}, 'Right', delay)
        hs.eventtap.keyStroke({'shift'}, 'Tab', delay)
        visual:exit()
        normal:enter()
        lastOperation('shift', ',')
    end)


local Darvim = {}
Darvim.init = init
return Darvim
