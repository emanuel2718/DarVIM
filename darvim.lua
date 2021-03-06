-- Author  : Emanuel Ramirez Alsina
-- Project : DarVIM


-- Scrolling speed in PDF apps
local SPEED = 4

-- Key press delay in ms.
local delay = 1

-- Keycode map:
local RETURN = 36
local ESCAPE = 53

-- Screen resolution information
local screenResolution = hs.screen.mainScreen():currentMode().desc:match('(.+)@')
local screenWidth = screenResolution:match('(.+)x')
local screenHeight = screenResolution:match('x(.+)')

-- Darkmode variable for Ex mode bar:
local isDarkMode = true --> Dark Mode
-- local isDarkMode = false --> Light Mode


-- Current VIM status menubar icon indicator
local barIcon = hs.menubar.new()

-- Customize here the menu bar mode indicator icons
local normalIcon = '[ N ]'
local insertIcon = '[ I ]'
local visualIcon = '[ V ]'


-- Mode's notification identifier
local normalNotification = 'NORMAL'
local insertNotification = 'INSERT'
local visualNotification = 'VISUAL'

-- Sets the current mode in the menu bar.
function setBarIcon(state)
  if state == 'VISUAL' then
    barIcon:setTitle(visualIcon)
  elseif state == 'INSERT' then
    barIcon:setTitle(insertIcon)
  elseif state == 'NORMAL' then
    barIcon:setTitle(normalIcon)
  else
    barIcon:setTitle('')
  end
end



--------------------MODES--------------------
-- Normal Mode --> Typing apps
local normal = hs.hotkey.modal.new()
-- Normal Mode --> PDF apps
local normalPDF = hs.hotkey.modal.new()
-- Visual Mode --> Anywhere
local visual = hs.hotkey.modal.new()
-- Replace Mode --> Typing apps
local replace = hs.hotkey.modal.new()
-- Ex Mode --> Typing apps
local exMode = hs.chooser.new(function() end)

-- Ex Mode bar customiztion
exMode:rows(0):width(50):bgDark(isDarkMode)
exMode:placeholderText(':')
---------------------------------------------


-- List of Applications VIM mode is desired
-- Append to the end of the relevant list the name of the app you want VIM suppot on.
local APPS = {'Xcode', 'Slack', 'Discord', 'Notes', 'Acrobat Reader', 'Anki',
			  'Preview', 'Mail', 'Microsoft Word', 'Microsoft OneNote'}

-- If there are applications that receives 'Escape' as the key to get you out of the
-- current text box and VIM support is desired. Put the application name
-- on this list and on the @APPS list above
local appsWithEscapeSupport = {'Xcode', 'Anki', 'Slack', 'Discord'}

-- PDF readers that VIM support is desired on.
-- Add the name of the application to the following list to include VIM support on that app.
local PDF = {'Preview', 'Acrobat Reader'}



-- Notifications styling --> hs.alert.show()
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




-- In charge of keeping track if a whole line was yanked or a portion (i.e word)
--	@isWholeLineYanked = true; paste will open a new line (above or below) and paste line
--	@isWholeLineYanked = false; paste will paste in place
local isWholeLineYanked = false

-- @findChar = true --> ';' and ',' will search forward and backwards for the
--   character beign searched in Normal mode
-- @findChar = false --> ';' and ',' will do nothing
local findChar = false

-- Initialize application watcher.
function init()
  appsWatcher = hs.application.watcher.new(applicationWatcher)
  appsWatcher:start()
end

-- Checks if the currently focused application is in the list of VIM supported apps
function contains(APP, name)
  for i, app in ipairs(APP) do
    if APP[i] == name then
      return true
    end
  end
  return false
end


-- Last operation key string
local keys = {}
-- Last operation modifier table
local mods = {}


-- Saves the last modifiers and/or key used by the user so that it can be repeated
--   with the '.' command
-- If the last operation was 'Shift + p' then it will be saved in the as:
--   @mods = {'shift'} --> If there was no modifier: @mods = {} empty table
--   @keys[0] = 'p'
function lastOperation(mod, command)
  keys[0] = command
  mods = mod
end


-- Main logic of the program. Watch to see if we are on an application that we
--   want VIM keybinds on or not.
-- There are three possible states:

-- VIM mode apps: here all VIM keybinds are activated. Everytime
--   a VIM mode app is launched of focused Normal mode gets activated.
-- PDF mode apps: here only VIM scrolling keybinds are activated.
--   Plus insert mode keybind.
-- Every other app: No VIM keybinds
function applicationWatcher(name, event, app)
  -- If the focus application is a PDF reader and it's on the @PDF list
  if contains(PDF, name) then
    -- Focused on the PDF app --> Enter PDF Normal Mode
    if event == hs.application.watcher.activated then
      normalMode:disable()
      normalModePDF:enable()
      normalPDF:enter()
      setBarIcon(normalNotification)
    end
    -- Focus is list from the PDF app --> Get out of Normal Mode
    if event == hs.application.watcher.deactivated then
      -- If the next focused window is one where we don't want VIM keybinds
      --   restriction (i.e Terminal, Web Browser)
      if not contains(APPS, hs.window.frontmostWindow():application():name()) then
        normalModePDF:disable()
        setBarIcon('')
      end
      normalPDF:exit()
      visual:exit()
      end
    end

  -- If the currently focused application is one that VIM keybinds are desired
  -- More formally; if the application is on the @APPS list
  -- For apps like Slack, Discord, Notes, etc.
  -- We dont want scrolling features like in Preview. We want 'hjkl' to behave
  --   like arrows to edit text.
  if contains(APPS, name) and not(contains(PDF, name)) then
    -- VIM keybind application focused --> Enter Normal Mode
    if event == hs.application.watcher.activated then
      normalModePDF:disable()
      normalMode:enable()
      normal:enter()
      setBarIcon(normalNotification)
    end
    -- VIM keybind application focus lost --> Leave Normal Mode
    if event == hs.application.watcher.deactivated then
      if not contains(APPS, hs.window.frontmostWindow():application():name()) then
        normalModePDF:disable()
        normalMode:disable()
        setBarIcon('')
      end
      normal:exit()
      visual:exit()
    end

  -- Curently focused app is one where VIM support is not desired
  elseif not contains(APPS, hs.window.frontmostWindow():application():name()) then
    normalModePDF:disable()
    normalMode:disable()
    setBarIcon('')
  end
end


---------------------------------------------------------------------
--                  MODE'S KEYBINDS                                --
---------------------------------------------------------------------


-- NORMAL: ENABLE NORMAL MODE --> 'Escape'
normalMode = hs.hotkey.bind({}, 'Escape',
  function()
    focusedWindow = hs.window.frontmostWindow():application():name()
    normal:enter()
    visual:exit()
    setBarIcon(normalNotification)
    if barIcon:title() == normalIcon and not contains(appsWithEscapeSupport, focusedWindow) then
      hs.eventtap.keyStroke({'shift'}, 'Escape', delay)
      hs.eventtap.keyStroke({'shift'}, 'Escape', delay)
    end
  end)

-- NORMAL: ENABLE NORMAL MODE IN PDF'S --> 'Escape'
normalModePDF = hs.hotkey.bind({}, 'Escape',
  function()
    if barIcon:title() == normalIcon then
      hs.eventtap.keyStroke({'shift'}, 'Escape', delay)
      hs.eventtap.keyStroke({'shift'}, 'Escape', delay)
    end
    normalPDF:enter()
    setBarIcon(normalNotification)
  end)

-- NORMAL: ENABLE VISUAL MODE --> 'v'
normal:bind({}, 'v',
  function()
    setBarIcon(visualNotification)
    normal:exit()
    visual:enter()
  end)

-- NORMAL: ENTER INSERT MODE --> 'i'
normal:bind({}, 'i',
  function()
    normal:exit()
    setBarIcon(insertNotification)
  end)





---------------------------------------------------------------------
--                NORMAL MODE PDF NAVIGATION KEYBINDS              --
---------------------------------------------------------------------


-- NORMAL PDF: ENABLE INSERT MODE --> 'i'
normalPDF:bind({}, 'i',
  function()
    normalPDF:exit()
    setBarIcon(insertNotification)
  end)


-- NORMALPDF: SCROLL UP --> 'k'
function scrollUP() hs.eventtap.scrollWheel({0, SPEED}, {}) end
normalPDF:bind({}, 'K', scrollUP, nil, scrollUP)


-- NORMALPDF: SCROLL DOWN --> 'j'
function scrollDOWN() hs.eventtap.scrollWheel({0, -SPEED}, {}) end
normalPDF:bind({}, 'J', scrollDOWN, nil, scrollDOWN)


-- NORMALPDF: SCROLL LEFT --> 'h'
function scrollLEFT() hs.eventtap.scrollWheel({SPEED, 0}, {}) end
normalPDF:bind({}, 'H', scrollLEFT, nil, scrollLEFT)


-- NORMALPDF: SCROLL RIGHT --> 'l'
function scrollRIGHT() hs.eventtap.scrollWheel({-SPEED, 0}, {}) end
normalPDF:bind({}, 'L', scrollRIGHT, nil, scrollRIGHT)


-- NORMALPDF: GO TO TOP OF PAGE --> 'gg'
normalPDF:bind({}, 'g',
  function()
    listener = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
      char = event:getCharacters()
      listener:stop()
      if char == 'g' then
        hs.eventtap.keyStroke({'cmd'}, 'Up', delay)
      end
      return false
  end)
    listener:start()
  end)


-- NORMALPDF: GO TO BOTTOM OF PAGE --> 'g'
function goBOTTOM() hs.eventtap.keyStroke({'cmd'}, 'Down') end
normalPDF:bind({'shift'}, 'G', goBOTTOM)


-- NORMALPDF: SCROLL ONE PAGE FOWARD --> 'ctrl + f'
function nextPAGE() hs.eventtap.keyStroke({}, 'Right', delay) end
normalPDF:bind({'ctrl'}, 'F', nextPAGE, nil, nextPAGE)


-- NORMALPDF: SCROLL ONE PAGE BACKWARD --> 'ctrl + b'
function previousPAGE() hs.eventtap.keyStroke({}, 'Left', delay) end
normalPDF:bind({'ctrl'}, 'b', previousPAGE, nil, previousPAGE)


-- Taken from Apple.com
-- To enable this shortcut, choose Apple menu  > System Preferences, then click Keyboard.
-- In the Shortcuts tab, select Accessibility on the left, then select
--   ”Invert colors” on the right.
-- NORMALPDF: INVERT DISPLAY COLORS --> 't'
normalPDF:bind({}, 's',
  function()
    hs.eventtap.keyStroke({'ctrl', 'option', 'cmd'}, '8')
  end)


-- NORMALPDF: UNDO --> 'u'
function undo() hs.eventtap.keyStroke({'cmd'}, 'z') end
normalPDF:bind({''}, 'u', undo, nil, undo)


-- NORMALPDF: REDO --> 'ctrl + r'
function redo() hs.eventtap.keyStroke({'shift', 'cmd'}, 'z') end
normalPDF:bind({'ctrl'}, 'r', redo, nil, redo)



---------------------------------------------------------------------
--                     NORMAL MODE KEYBINDS                        --
---------------------------------------------------------------------


-- NORMAL: MOVE UP --> 'k'
function moveUP() hs.eventtap.keyStroke({}, 'Up', delay) end
normal:bind({}, 'k', nil, moveUP, moveUP)


-- NORMAL: MOVE DOWN --> 'j'
function moveDOWN() hs.eventtap.keyStroke({}, 'Down', delay) end
normal:bind({}, 'j', nil, moveDOWN, moveDOWN)


-- NORMAL: MOVE LEFT --> 'h'
function moveLEFT() hs.eventtap.keyStroke({}, 'Left', delay) end
normal:bind({}, 'h', nil, moveLEFT, moveLEFT)


-- NORMAL: MOVE RIGHT --> 'l'
function moveRIGHT() hs.eventtap.keyStroke({}, 'Right', delay) end
normal:bind({}, 'l', nil, moveRIGHT, moveRIGHT)


-- NORMAL: SCROLL UP --> 'ctrl + y'
function scrollUP() hs.eventtap.scrollWheel({0, SPEED}, {}) end
normal:bind({'ctrl'}, 'y', scrollUP, nil, scrollUP)


-- NORMAL: SCROLL DOWN --> 'ctrl + e'
function scrollDOWN() hs.eventtap.scrollWheel({0, -SPEED}, {}) end
normal:bind({'ctrl'}, 'e', scrollDOWN, nil, scrollDOWN)


-- NORMAL: MOVE TO PREVIOUS WORD --> 'b'
function movePrevWord() hs.eventtap.keyStroke({'alt'}, 'left', delay) end
normal:bind({}, 'B', movePrevWord, nil, movePrevWord)


-- NORMAL: MOVE TO TOP OF PAGE --> 'gg'
normal:bind({}, 'G',
  function()
    listener = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
      char = event:getCharacters()
      listener:stop()
      if char == 'g' then
        hs.eventtap.keyStroke({'cmd'}, 'Up', delay)
      end
      return false
    end)
    listener:start()
  end)


-- NORMAL: MOVE TO BOTTOM OF PAGE --> 'Shift + g'
normal:bind({'shift'}, 'G',
  function()
    hs.eventtap.keyStroke({'cmd'}, 'Down', delay)
  end)


-- NORMAL: MOVE TO NEXT WORD --> 'w'
function moveNextWord()
  hs.eventtap.keyStroke({'alt'}, 'right', delay)
  hs.eventtap.keyStroke({'alt'}, 'right', delay)
  hs.eventtap.keyStroke({'alt'}, 'left', delay)
end
normal:bind({}, 'w', moveNextWord, nil, moveNextWord)


-- NORMAL: MOVE TO END OF WORD --> 'e'
function moveEndOfWord()
  hs.eventtap.keyStroke({'alt'}, 'right', delay)
  hs.eventtap.keyStroke({}, 'left', delay)
end
normal:bind({}, 'e', moveEndOfWord, nil, moveEndOfWord)


-- NORMAL: MOVE TO END OF LINE --> '$'
normal:bind({'shift'}, '4',
  function()
    hs.eventtap.keyStroke({'cmd'}, 'right', delay)
  end)


-- NORMAL: MOVE CURSOR ONE SPACE FOWARD + INSERT MODE --> 'a'
normal:bind({}, 'A',
  function()
    normal:exit()
    hs.eventtap.keyStroke({}, 'Right', delay)
    setBarIcon(insertNotification)
  end)


-- NORMAL: MOVE TO END OF LINE + INSERT MODE --> 'Shift + a'
normal:bind({'shift'}, 'A',
  function()
    normal:exit()
    hs.eventtap.keyStroke({'cmd'}, 'right', delay)
    setBarIcon(insertNotification)
  end)


-- NORMAL: MOVE TO BEGINNING OF LINE + INSERT MODE --> 'Shift + i'
normal:bind({'shift'}, 'I',
  function()
    normal:exit()
    hs.eventtap.keyStroke({'cmd'}, 'left', delay)
    setBarIcon(insertNotification)
  end)


-- NORMAL: OPEN A NEW LINE ABOVE CURRENT CURSOR LINE + INSERT MODE --> 'o'
normal:bind({'shift'}, 'O', nil,
  function()
    hs.eventtap.keyStroke({'cmd'}, 'Left', delay)
    hs.eventtap.keyStroke({'shift'}, 'Return', delay)
    hs.eventtap.keyStroke({}, 'Up', delay)
    normal:exit()
    setBarIcon(insertNotification)
    lastOperation({'shift'}, 'o')
  end)


-- NORMAL: OPEN A NEW LINE BELOW CURRENT CURSOR LINE + INSERT MODE --> 'Shift + o'
normal:bind({}, 'O', nil,
  function()
    hs.eventtap.keyStroke({'cmd'}, 'Right', delay)
    hs.eventtap.keyStroke({'shift'}, 'Return', delay)
    normal:exit()
    setBarIcon(insertNotification)
    lastOperation({}, 'o')
  end)


-- NORMAL: DELETE CHARACTER IN FRONT OF CURSOR --> 'x'
function deleteNextChar()
  hs.eventtap.keyStroke({}, 'forwarddelete', delay)
  lastOperation({}, 'x')
end
normal:bind({}, 'x', deleteNextChar, nil, deleteNextChar)


-- NORMAL: DELETE CHARACTER IN FRONT OF CURSOR + INSERT MODE--> 's'
normal:bind({}, 's',
  function()
    hs.eventtap.keyStroke({}, 'forwarddelete', delay)
    normal:exit()
    setBarIcon(insertNotification)
    lastOperation({}, 's')
  end)

-- NORMAL: SUBSTITUTE ENTIRE LINE-DELTES LINE + INSERT MODE --> 'Shift + s'
normal:bind({'shift'}, 's',
  function()
    normal:exit()
    hs.eventtap.keyStroke({'shift', 'cmd'}, 'Right', delay)
    hs.eventtap.keyStroke({'cmd'}, 'c', delay)
    hs.eventtap.keyStroke({'fn'}, 'delete', delay)
    setBarIcon(insertNotification)
    lastOperation({'shift'}, 's')
    isWholeLineYanked = true
  end)


-- NORMAL: REPLACE CHARACTER IN FRONT OF CURSOR--> 'r'
normal:bind({}, 'r',
  function()
    normal:exit()
    listener = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
      char = event:getCharacters()
      listener:stop()
      hs.eventtap.keyStroke({}, 'forwarddelete', delay)
      -- Check if character is a number
      if tonumber(char) ~= nil then
        hs.eventtap.keyStroke({}, char)
      -- Check if character is alphanumeric; Want to weed out charcters like '$'
      elseif string.match(char, '[^%w]') == nil and char == string.upper(char) then
        hs.eventtap.keyStroke({'shift'}, char)
      -- Character must be a symbol like '$'
      else
        hs.eventtap.keyStrokes(char)
      end
      return normal:enter()
    end)
    listener:start()
  end)



-- NORMAL: move to the next word without delay
function jumpNextWord() hs.eventtap.keyStroke({'alt'}, 'right', delay) end


-- TODO: Fix bug: If there is empty space between the cursor position and the
-- next character...it will jump to that next word and delete it instead of
-- deleting the space in betwen like in Native VIM.


-- TODO: Last operation command it's not working here.
-- Becuase when it comes back to repeat the operation it will find itself with the ifelse's

-- NORMAL: DELETE WORD OR DELETE WHOLE LINE --> 'dw' or 'dd'
normal:bind({}, 'd',
  function()
    listener = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
      char = event:getCharacters()
      listener:stop()
      if char == 'w' then
        hs.eventtap.keyStroke({'shift', 'option'}, 'Right', delay)
        hs.eventtap.keyStroke({'cmd'}, 'c', delay)
        hs.eventtap.keyStroke({''}, 'delete', delay)
        lastOperation({}, 'd')
        isWholeLineYanked = false
      elseif char == 'd' then
        hs.eventtap.keyStroke({'cmd'}, 'Left', delay)
        hs.eventtap.keyStroke({'shift', 'cmd'}, 'Right', delay)
        hs.eventtap.keyStroke({'cmd'}, 'c', delay)
        hs.eventtap.keyStroke({''}, 'delete', delay)
        lastOperation({'ctrl'}, 'd')
        isWholeLineYanked = true
      end
      return true
    end)
    listener:start()
  end)


-- NORMAL: DELETE UNITIL END OF LINE --> 'Shift + d'
normal:bind({'shift'}, 'd',
  function()
    hs.eventtap.keyStroke({'shift', 'cmd'}, 'Right', delay)
    hs.eventtap.keyStroke({'cmd'}, 'c', delay)
    hs.eventtap.keyStroke({'fn'}, 'delete', delay)
    lastOperation({'shift'}, 'd')
    isWholeLineYanked = false
  end)



-- TODO: How to set the next operation to be 'cw' isntead of 'c'. 2 element array of keys?
-- TODO: Same goes for 'cc'
-- NORMAL: CHANGE WORD OR CHANGE WHOLE LINE--> 'cw' or 'cc'
normal:bind({}, 'c',
  function()
    normal:exit()
    listener = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
      char = event:getCharacters()
      listener:stop()
      if char == 'w' then
        hs.eventtap.keyStroke({'shift', 'option'}, 'right', 200)
        hs.eventtap.keyStroke({}, 'delete', 200)
        setBarIcon(insertNotification)
        lastOperation({}, 'c')
        isWholeLineYanked = false
      elseif char == 'c' then
        hs.eventtap.keyStroke({'cmd'}, 'Left', 200)
        hs.eventtap.keyStroke({'shift', 'cmd'}, 'Right', delay)
        hs.eventtap.keyStroke({'cmd'}, 'c', delay)
        hs.eventtap.keyStroke({''}, 'delete', 200)
        setBarIcon(insertNotification)
        lastOperation({'shift'}, 'c')
        isWholeLineYanked = true
      end
      return true
    end)
    listener:start()
  end)




-- NORMAL: DELETE UNITIL END OF LINE + INSERT MODE --> 'Shift + c'
normal:bind({'shift'}, 'C',
  function()
    normal:exit()
    hs.eventtap.keyStroke({'shift', 'cmd'}, 'Right', delay)
    hs.eventtap.keyStroke({'cmd'}, 'c', delay)
    hs.eventtap.keyStroke({'fn'}, 'delete', delay)
    setBarIcon(insertNotification)
    lastOperation({'shift'}, 'c')
    isWholeLineYanked = false
  end)


-- NORMAL: UNDO --> 'u'
normal:bind({}, 'U',
  function()
    hs.eventtap.keyStroke({'cmd'}, 'Z', delay)
  end)


-- NORMAL: REDO --> 'Ctrl + r'
normal:bind({'ctrl'}, 'R',
  function()
    hs.eventtap.keyStroke({'shift', 'cmd'}, 'Z', delay)
  end)



-- NORMAL: YANK WHOLE LINE --> 'yy'
normal:bind({}, 'y',
  function()
    listener = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
      char = event:getCharacters()
      listener:stop()
      if char == 'y' then
        hs.eventtap.keyStroke({'cmd'}, 'Left', delay)
        hs.eventtap.keyStroke({'shift', 'cmd'}, 'Right', delay)
        hs.eventtap.keyStroke({'cmd'}, 'c', delay)
        hs.eventtap.keyStroke({}, 'right', delay)
        isWholeLineYanked = true
      end
      return normal:enter()
    end)
    listener:start()
  end)


-- NORMAL: YANK FROM CURSOR TO EOL --> 'Shift + y'
normal:bind({'shift'}, 'y',
  function()
    hs.eventtap.keyStroke({'shift', 'cmd'}, 'Right', delay)
    hs.eventtap.keyStroke({'cmd'}, 'c', delay)
    isWholeLineYanked = false
  end)


-- NORMAL: PASTE BELOW CURRENT CURSOR LINE --> 'p'
normal:bind({}, 'P',
  function()
    if isWholeLineYanked then
      hs.eventtap.keyStroke({'cmd'}, 'Right', delay)
      hs.eventtap.keyStroke({'shift'}, 'Return', delay)
      hs.eventtap.keyStroke({'cmd'}, 'v', delay)
      lastOperation({}, 'p')
    else
      hs.eventtap.keyStroke({'cmd'}, 'v', delay)
      lastOperation({}, 'p')
    end
  end)


-- NORMAL: PASTE ABOVE CURRENT CURSOR LINE --> 'Shift + p'
normal:bind({'shift'}, 'P', nil,
  function()
    hs.eventtap.keyStroke({'cmd'}, 'Left', delay)
    hs.eventtap.keyStroke({'shift'}, 'Return', delay)
    hs.eventtap.keyStroke({}, 'Up', delay)
    hs.eventtap.keyStroke({'cmd'}, 'v', delay)
    lastOperation({'shift'}, 'p')
  end)


-- NORMAL: Search --> '/'
normal:bind({}, '/',
  function()
    hs.eventtap.keyStroke({'cmd'}, 'F', delay)
    normal:exit()
    setBarIcon(insertNotification)
    findChar = false --Override 'f<char>'
    listener = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
      char = event:getKeyCode()
      if char == RETURN then
        listener:stop()
        hs.eventtap.keyStroke({'shift'}, 'Escape', delay)
        return normal:enter()
      end
    end)
    listener:start()
  end)



-- NORMAL: SEARCH FOWARD --> 'n'
normal:bind({}, 'n',
  function()
    if not findChar then
      hs.eventtap.keyStroke({'cmd'}, 'G', delay)
    end
  end)


-- NORMAL: SEARCH BACKWARDS --> 'n'
normal:bind({'shift'}, 'n',
  function()
    if not findChar then
      hs.eventtap.keyStroke({'shift', 'cmd'}, 'G', delay)
    end
  end)


-- NORMAL: INDENT FOWARD --> '>'
normal:bind({'shift'}, '.',
  function()
    --hs.eventtap.keyStroke({'cmd'}, 'Left', 500)
    hs.eventtap.keyStroke({}, 'tab')
    lastOperation({'shift'}, '.')
  end)


-- NORMAL: INDENT BACKWARDS --> '<'
normal:bind({'shift'}, ',',
  function()
    hs.eventtap.keyStroke({'cmd'}, 'Right', delay)
    hs.eventtap.keyStroke({'shift'}, 'Tab', delay)
    lastOperation({'shift'}, ',')
  end)



-- NORMAL: HIGHLIGHT COMPLETE LINE + VISUAL --> 'v'
normal:bind({'shift'}, 'v',
  function()
    normal:exit()
    visual:enter()
    hs.eventtap.keyStroke({'cmd'}, 'Left', delay)
    hs.eventtap.keyStroke({'shift', 'cmd'}, 'Right', delay)
    setBarIcon(visualNotification)
  end)



-- NORMAL: REPEAT LAST COMMAND
normal:bind({}, '.',
  function()
    if keys[0] ~= nil then
      hs.eventtap.keyStroke(mods, keys[0], delay)
      -- To deal with cases that put us in Insert
      hs.eventtap.keyStroke({}, 'Escape', delay)
    end
  end, nil,
  function()
    hs.eventtap.keyStroke(mods, keys[0], delay)
    hs.eventtap.keyStroke({}, 'Escape', delay)
  end)




-- NORMAL: FIND NEXT OCCURRENCE OF <CHARACTER> PUT US BEFORE CHARACTER --> 'f<char>'
normal:bind({}, 'f',
  function()
    normal:exit()
    listener = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
      char = event:getCharacters()
      listener:stop()
      hs.eventtap.keyStroke({'cmd'}, 'f')
      hs.eventtap.keyStrokes(char)
      hs.timer.doAfter(0.5,
        function()
          hs.eventtap.keyStroke({'cmd'}, 'g', delay)
          hs.eventtap.keyStroke({'shift'}, 'Escape', delay)
          hs.eventtap.keyStroke({}, 'left', delay)
        end)
      findChar = true
      return normal:enter()
    end)
    listener:start()
  end)


-- NORMAL: REVERSE 'f<char>' --> 'F<char>'
normal:bind({'shift'}, 'f',
  function()
    normal:exit()
    listener = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
      char = event:getCharacters()
      listener:stop()
      hs.eventtap.keyStroke({'cmd'}, 'f')
      hs.eventtap.keyStrokes(char)
      hs.timer.doAfter(0.5,
        function()
          hs.eventtap.keyStroke({'shift', 'cmd'}, 'g', delay)
          hs.eventtap.keyStroke({'shift'}, 'Escape', delay)
          hs.eventtap.keyStroke({}, 'left', delay)
        end)
      findChar = true
      return normal:enter()
    end)
    listener:start()
  end)


-- NORMAL: SAME AS 'f' BUT MOVES TO JUST BEFORE FOUND CHARACTER-> 't<char>'
normal:bind({}, 't',
  function()
    normal:exit()
    listener = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
      char = event:getCharacters()
      listener:stop()
      hs.eventtap.keyStroke({'cmd'}, 'f')
      hs.eventtap.keyStrokes(char)
      hs.timer.doAfter(0.5,
        function()
          hs.eventtap.keyStroke({'cmd'}, 'g', delay)
          hs.eventtap.keyStroke({'shift'}, 'Escape', delay)
          hs.eventtap.keyStroke({}, 'left', delay)
          hs.eventtap.keyStroke({}, 'left', delay)
        end)
      findChar = true
      return normal:enter()
    end)
    listener:start()
  end)


-- NORMAL: REVERSE 't<char>' --> 'T<char>'
normal:bind({'shift'}, 't',
  function()
    normal:exit()
    listener = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
      char = event:getCharacters()
      listener:stop()
      hs.eventtap.keyStroke({'cmd'}, 'f')
      hs.eventtap.keyStrokes(char)
      hs.timer.doAfter(0.5,
        function()
          hs.eventtap.keyStroke({'shift', 'cmd'}, 'g', delay)
          hs.eventtap.keyStroke({'shift'}, 'Escape', delay)
          hs.eventtap.keyStroke({}, 'right', delay)
        end)
      findChar = true
      return normal:enter()
    end)
    listener:start()
  end)


-- NORMAL: REPEAT LAST FIND COMMAND FORWARD
normal:bind({}, ';',
  function()
    if findChar then
      hs.eventtap.keyStroke({'cmd'}, 'g', delay)
    end
  end)


-- NORMAL: REPEAT LAST FIND COMMAND BACKWARDS
normal:bind({}, ',',
  function()
    if findChar then
      hs.eventtap.keyStroke({'shift', 'cmd'}, 'g', delay)
    end
  end)


-- NORMAL: MOVE BACK UP ONE SCREEN --> 'ctrl + b'
normal:bind({'ctrl'}, 'b',
  function()
    hs.eventtap.keyStroke({}, 'pageup')
  end, nil,
  function()
    hs.eventtap.keyStroke({}, 'pageup')
  end)


-- NORMAL: MOVE FORWARD DOWN ONE SCREEN --> 'ctrl + f'
normal:bind({'ctrl'}, 'f',
  function()
    hs.eventtap.keyStroke({}, 'pagedown')
    --hs.eventtap.event.newMouseEvent(hs.eventtap.middleClick(
    --						{hs.window.focusedWindow():size().w,
    --						 hs.window.focusedWindow():size().h}))
  end, nil,
  function()
    hs.eventtap.keyStroke({}, 'pagedown')
  end)


-- NORMAL: MOVE TO FIRST NON-WHITE CHAR IN THE LINE --> '^'
normal:bind({'shift'}, '6',
  function()
    hs.eventtap.keyStroke({'cmd'}, 'left')
  end)


-- NORMAL: MOVE TO FIRST NON-WHITE CHAR IN THE PREVIOUS LINE --> '-'
normal:bind({}, '-',
  function()
    hs.eventtap.keyStroke({'cmd'}, 'left', delay)
    hs.eventtap.keyStroke({}, 'up', delay)
  end, nil,
  function()
    hs.eventtap.keyStroke({'cmd'}, 'left', delay)
    hs.eventtap.keyStroke({}, 'up', delay)
  end)


-- NORMAL: MOVE TO FIRST NON-WHITE CHAR IN THE NEXT LINE --> '+'
normal:bind({'shift'}, '=',
  function()
    hs.eventtap.keyStroke({'cmd'}, 'left', delay)
    hs.eventtap.keyStroke({}, 'down', delay)
  end, nil,
  function()
    hs.eventtap.keyStroke({'cmd'}, 'left', delay)
    hs.eventtap.keyStroke({}, 'down', delay)
end)


-- NORMAL: ENTER EX MODE --> ':'
-- Possible choices: 'q'  > Quit file
-- 				     'w'  > Save file
--                   'wq' > Save and Quit
normal:bind({'shift'}, ';',
  function()
    normal:exit()
    exMode:show(hs.geometry.point(0, screenHeight * 0.85))
    listener = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
      char = event:getKeyCode()
      if char == ESCAPE then
        exMode:cancel()
        listener:stop()
        return normal:enter()

      elseif char == RETURN and exMode:isVisible() then
        command = exMode:query()
        if command == 'wq' then
          hs.eventtap.keyStroke({'cmd'}, 's', delay)
          exMode:cancel()
          listener:stop()
          return hs.eventtap.keyStroke({'cmd'}, 'q', delay)

        elseif command == 'w' then
          exMode:cancel()
          listener:stop()
          hs.alert.show('File Saved', alertStyle)
          hs.eventtap.keyStroke({'cmd'}, 's')
          return normal:enter()

        elseif command == 'q' then
          exMode:cancel()
          listener:stop()
          normal:enter()
          return hs.eventtap.keyStroke({'cmd'}, 'q', delay)
        else
          exMode:cancel()
          listener:stop()
          hs.alert.show('Command not found', alertStyle)
          return normal:enter()
        end
      end
    end)
    listener:start()
  end)

-- NORMAL: CENTER CURSOR POSITION IN THE MIDDLE OF THE SCREEN --> 'zz'
normal:bind({}, 'z',
  function()
    listener = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
      char = event:getCharacters()
      listener:stop()
      if char == 'z' then
        hs.eventtap.keyStroke({'ctrl'}, 'l')
      end
      return
    end)
    listener:start()
  end)



-- Placebo keys for now until they get bind to a operation:
normal:bind({}, 'q', function() end)
normal:bind({}, 'm', function() end)
normal:bind({}, '0', function() end)
normal:bind({}, '1', function() end)
normal:bind({}, '2', function() end)
normal:bind({}, '3', function() end)
normal:bind({}, '4', function() end)
normal:bind({}, '5', function() end)
normal:bind({}, '6', function() end)
normal:bind({}, '7', function() end)
normal:bind({}, '8', function() end)
normal:bind({}, '9', function() end)



---------------------------------------------------------------------
--                          VISUAL MODE                            --
---------------------------------------------------------------------


-- VISUAL: MOVE UP --> 'k'
function visualUP() hs.eventtap.keyStroke('shift', 'Up', delay) end
visual:bind({}, 'k', visualUP, nil, visualUP)


-- VISUAL: MOVE DOWN --> 'j'
function visualDOWN() hs.eventtap.keyStroke('shift', 'Down', delay) end
visual:bind({}, 'j', visualDOWN, nil, visualDOWN)


-- VISUAL: MOVE LEFT --> 'h'
function visualLEFT() hs.eventtap.keyStroke('shift', 'Left', delay) end
visual:bind({}, 'h', visualLEFT, nil, visualLEFT)



-- VISUAL: MOVE DOWN --> 'l'
function visualRIGHT() hs.eventtap.keyStroke('shift', 'Right', delay) end
visual:bind({}, 'l', visualRIGHT, nil, visualRIGHT)


-- VISUAL: MOVE TO BEGINNING OF WORD --> 'b'
function visualBeginningOfWord()
  hs.eventtap.keyStroke({'shift', 'alt'}, 'left', delay)
end
visual:bind({}, 'b', visualBeginningOfWord, nil, visualBeginningOfWord)


-- VISUAL: MOVE TO END OF WORD --> 'e'
function visualEndOfWord()
  hs.eventtap.keyStroke({'shift', 'alt'}, 'right', delay)
  hs.eventtap.keyStroke({'shift'}, 'Left', delay)
end
visual:bind({}, 'e', visualEndOfWord, nil, visualEndOfWord)


-- VISUAL: MOVE TO NEXT WORD --> 'w'
function visualNextWord()
  hs.eventtap.keyStroke({'shift', 'alt'}, 'right', delay)
  hs.eventtap.keyStroke({'shift', 'alt'}, 'right', delay)
  hs.eventtap.keyStroke({'shift', 'alt'}, 'left', delay)
end

visual:bind({}, 'w', visualNextWord, nil, visualNextWord)


-- VISUAL: YANK AND TAKE US TO NORMAL MODE --> 'y'
visual:bind({}, 'y',
  function()
    hs.eventtap.keyStroke({'cmd'}, 'c', delay)
    hs.eventtap.keyStroke({}, 'Right', delay)
    visual:exit()
    normal:enter()
    setBarIcon(normalNotification)
  end)



-- VISUAL: HIGHLIGHT FROM CURSOR UNTIL BEGINNING OF LINE --> '0'
visual:bind({}, '0',
  function()
    hs.eventtap.keyStroke({'shift', 'cmd'}, 'Left', delay)
  end)


-- VISUAL: HIGHLIGHT FROM CURSOR UNTIL BEGINNING OF FILE --> 'Shift + h'
visual:bind({'shift'}, 'h',
  function()
    hs.eventtap.keyStroke({'shift', 'cmd'}, 'Up', delay)
  end)


-- VISUAL: HIGHLIGHT FROM CURSOR UNTIL BEGINNING OF FILE --> 'gg'
visual:bind({}, 'g',
  function()
    listener = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
      char = event:getCharacters()
      listener:stop()
      if char == 'g' then
        hs.eventtap.keyStroke({'shift', 'cmd'}, 'Up', delay)
      end
      return false
  end)
  listener:start()
  end)


-- VISUAL: HIGHLIGHT FROM CURSOR UNTIL END OF FILE --> 'Shift + g'
visual:bind({'shift'}, 'g',
  function()
    hs.eventtap.keyStroke({'shift', 'cmd'}, 'Down', delay)
  end)


-- VISUAL: HIGHLIGHT FROM CURSOR UNTIL END OF FILE --> 'Shift + l'
visual:bind({'shift'}, 'l',
  function()
    hs.eventtap.keyStroke({'shift', 'cmd'}, 'Down', delay)
  end)


-- VISUAL: HIGHLIGHT FROM CURSOR UNTIL END OF Line --> '$'
visual:bind({'shift'}, '4',
  function()
    hs.eventtap.keyStroke({'shift', 'cmd'}, 'Right', delay)
  end)



-- VISUAL: DELETE HIGHLIGHTED CHARACTERS --> 'x'
visual:bind({}, 'x',
  function()
    visual:exit()
    normal:enter()
    deleteNextChar()
    setBarIcon(normalNotification)
    lastOperation({}, 'x')
  end)

-- VISUAL: DELETE HIGHLIGHTED CHARACTERS --> 'd'
visual:bind({}, 'd',
  function()
    visual:exit()
    normal:enter()
    hs.eventtap.keyStroke({''}, 'delete', delay)
    setBarIcon(normalNotification)
    lastOperation({}, 'd')
  end)


-- VISUAL: CHANGE HIGHLIGHTED CHARACTERS --> 'c'
visual:bind({}, 'c',
  function()
    visual:exit()
    hs.eventtap.keyStroke({''}, 'delete', delay)
    setBarIcon(insertNotification)
    lastOperation({}, 'c')
  end)


-- VISUAL: INDENT FOWARD --> '>'
visual:bind({'shift'}, '.',
  function()
    hs.eventtap.keyStroke({'cmd'}, 'Left', delay)
    hs.eventtap.keyStroke({}, 'Tab', delay)
    visual:exit()
    normal:enter()
    lastOperation({'shift'}, '.')
  end)

-- VISUAL: INDENT BACKWARDS --> '<'
visual:bind({'shift'}, ',',
  function()
    hs.eventtap.keyStroke({'cmd'}, 'Right', delay)
    hs.eventtap.keyStroke({'shift'}, 'Tab', delay)
    visual:exit()
    normal:enter()
    lastOperation({'shift'}, ',')
  end)


local Darvim = {}
Darvim.init = init
return Darvim
