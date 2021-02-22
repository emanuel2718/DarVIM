[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
<h1 align="center" style="font-size: 3rem;">
DarVIM
</h1>

Vim system keybinds for macOS using [Hammerspoon](http://www.hammerspoon.org/),
but only on the applications you want Vim keybinds on.

This project was born because I wanted to start using Xcode for iOS development but couldn't handle
not having Vim keybinds and the fact that the support for such keybinds on Xcode it's almost
not existent, served as the catalyst for this project.


That being said, DarVIM is specifically tailored
for Xcode but will work on any other app you add to the list of Vim supported
apps (see
[Add text-editing application to have Vim keybinds
support](#add-text-editing-application-to-have-vim-keybinds-support) or 
[Add PDF application to have Vim keybinds support](#add-pdf-application-to-have-vim-keybinds-support)
to learn how to add such applications). 


&nbsp; 

**Warning:** This is a work in progress, not all Vim operators and motions
are available. The goal of this project is to, eventually, have support for all
operators and motions from native Vim.
Other applications will work like they are
supposed to, but some of them (i.e OneNote) will not behave as intended 100% of
the time.


If you find something is not working like it's supposed to, refer to the
[Troubleshoot](#troubleshoot) section or feel free to open a pull request.


# Index

* [Installation](#installation)
* [How to use](#how-to-use)
* [Supported Keybinds](#supported-keybinds)
	- [Normal Mode in PDF app](#normal-mode-in-pdf-app)
	- [Normal Mode](#normal-mode)
	- [Visual Mode](#visual-mode)
* [Customization](#customization)
	- [Increase scrolling speed with hjkl in PDF mode](#increase-scrolling-speed-with-hjkl-in-PDF-mode)
	- [Add text-editing application to have Vim keybinds support](#add-text-editing-application-to-have-vim-keybinds-support)
	- [Add PDF application to have Vim keybinds support](#add-pdf-application-to-have-vim-keybinds-support)
	- [Toogle Ex mode bar from Dark mode and Light mode](#toogle-ex-mode-bar-from-dark-mode-and-light-mode)
	- [Customize mode indicators in menu bar](#customize-mode-indicators-in-menu-bar)
	- [Application where you don't want Escape to work like the system Escape](#application-where-you-dont-want-escape-to-work-like-the-system-escape)
* [Troubleshoot](#troubleshoot)
* [Things todo](#things-todo)
* [Credits](#credits)



# Installation

### Step 1: Install Hammerspoon

##### Manual Installation
 * Download the [latest release](https://github.com/Hammerspoon/hammerspoon/releases/latest)
 * Drag `Hammerspoon.app` from your `Downloads` folder to `Applications`

##### Homebrew installation
  * `brew cask install hammerspoon`

&nbsp; 

### Step 2: Install DarVIM

&nbsp; 
##### CASE 1: If you already have an `init.lua` file

1. `git clone https://github.com/emanuel2718/DarVIM.git`

2. Copy the contents of the `init.lua` from this repo and paste it on your
    existing `init.lua` file.

3. `ln -s <path-to-DarVIM-folder>/darvim.lua ~/.hammerspoon/darvim.lua`

&nbsp; 

##### CASE 2: If you DON'T already have an `init.lua` file then on a Terminal window


1. `git clone https://github.com/emanuel2718/DarVIM.git`

2. `mkdir ~/.hammerspoon`

3. `ln -s <path-to-DarVIM-folder>/darvim.lua ~/.hammerspoon/darvim.lua`

4. `ln -s <path-to-DarVIM-folder>/init.lua ~/.hammerspoon/init.lua`

&nbsp; 

### Step 3: Reaload Hammerspoon Configuration
Open Hammerspoon application either with a Spotlight search or by Right
clicking Hammerspoon application in Finder and selecting `Open`.
Then, press `shift + cmd + r` to reaload Hammerspoon configuration.
At this point VIM keybinds should be enabled while using Preview.

TLDR: `Open` Hammerspoon appllication and press `shift + cmd + r`.


&nbsp; 



# How to use

Basically this program divides applications into three possible states:


	- Normal Mode apps (Vim keybinds)
		- Text editing apps like Notes, Xcode, Word etc.
	- Normal Mode PDF apps (Vim keybinds)
		- PDF apps like Preview
	- Non-Vim keybinds apps
		- Any app you don't want Vim keybindings on.
		
Every time you switch into a Vim-supported application, it will default into
Normal mode. So in order to start typing, simply tap `i` to enter Insert mode.

There are not system notifications when you switch into a mode as it tends to
get annoying really quick. As a workaround, every time a Vim-supported
application is beign focused/used the current mode will be displayed
on the menu bar as a single letter in  brackets as show below.


	- [ N ] : Normal Mode
	- [ I ] : Insert Mode
	- [ V ] : Visual Mode
		
		
This can be changed, refer to
the [Customization](#customization) section to change this.)


The default keybind to enter Normal mode is `Esc` itself. If we are in any
mode other than Normal mode, when we press `Esc` it will put us in Normal
mode. Press `Esc` again and it will work as the system `Escape` so you don't
loose it's native system function.


Unfortunately, if you are reading this there is not support for binding `Esc`
as `ctrl + [` or `jk`, which I know are some famous rebindings of the `Esc`
key on Vim. Work is beign done to implement this.

To save or quit a file simply type `:` to enter Ex mode. And type any of the
following:

	- wq --> Save & Quit
	- w  --> Save file
	- q  --> Quit file


&nbsp; 

# Supported Keybinds

### Normal Mode in PDF app
 * `h` : Scroll Left
 * `j` : Scroll Down
 * `k` : Scroll Up
 * `l` : Scroll Right
 * `gg`   : Scroll Top of PDF
 * `G` : Scroll Bottom of PDF
 * `C-f` : Scroll to next page
 * `C-b` : Scroll to previous page
 
 * `Esc` : Enter Normal Mode
 * `i` : Enter Insert Mode (VIM keybinds stop working)
 * `u` : Undo
 * `C-r` : Redo
 * `s` : Invert screen colors

&nbsp; 

### Normal Mode
 * `C-y` : Scroll Up
 * `C-e` : Scroll Down
 * `h` : Move Left
 * `j` : Move Down
 * `k` : Move Up
 * `l` : Move Right
 * `gg` : Move to top of the page
 * `G` : Move to bottom of page
 * `b` : Move to previous word
 * `w` : Move to next word
 * `e` : Move to end of word
 * `$` : Move to end of the line
 * `a` : Enter insertion mode after current character
 * `A` : Enter insertion mode after end of line
 * `I` : Enter insertion mode before first non-whitespace character
 * `O` : Open line above and enter insertion mode
 * `o` : Open line below and enter insertion mode
 * `x` : Delete single character in front of cursor
 * `s` : Delete single character in front of cursor + Insert Mode
 * `S` : Substitutes entire line/Delete line + Insert Mode
 * `r<char>` : Replace single character at cursor
 * `F<char>` : Find `<char>` occurence before cursor
 * `f<char>` : Find `<char>` occurence after cursor
 * `T<char>` : reverse `t<char>` :: Broken
 * `t<char>` : Same as `f<char>` but move to just one before found char :: Broken
 * `;` : Repeat last `f`, `F`, `t`, or `T` command
 * `,` : Reverse direction of last `f`, `F`, `t`, or `T` command
 * `dw` : Delete next word
 * `dd` : Delete whole line
 * `D` : Delete to end of line
 * `cw` : Change word
 * `cc` : Change whole line
 * `C` : Change from cursor to end of line
 * `u` : Undo
 * `C-r` : Redo
 * `yy` : Yank whole line
 * `Y` : Yank from cursor until EOL
 * `p` : Paste
 * `P` : Paste above current cursor line.
 * `/` : Search
 * `n` : Repeat last search; Foward
 * `N` : Repeat last search; Backwards
 * `>` : Indent
 * `<` : Unindent
 * `i` : Enter Insert Mode
 * `v` : Enter Visual Mode
 * `V` : Enter Visual mode and highlight whole line
 * `^` : Move to first non-whitespace character in the line (Having trouble in
   some apps i.e Notes)
 * `-` : Move to first non-whitespace character of previous line (Having trouble
   in some apps i.e Notes)
 * `+` : Move to first non-whitespace character of next line (Having trouble
   in some apps i.e Notes)
 * `zz` : Center cursor position in the middle of the screen
 
 * `:` : Enter Ex mode


 * Currently available Ex mode commands:
	- [x] `wq` -> Save and Quit file
	- [x] `w`  -> Save file
	- [x] `q`  -> Quit file
	
	
 :: Need to click with mouse once in desired location
 * `C-b` : Move backwards up one page :: *Broken*
 * `C-f` : Move forwdard down one page :: *Broken*
 
&nbsp; 

### Visual Mode
 * `h` : Highlight Left
 * `j` : Highlight Down
 * `k` : Highlight Up
 * `l` : Highlight Right
 * `b` : Highlight to beginning of word
 * `e` : Highlight to end of word
 * `w` : Highlight to next of word
 * `0` : Highlight from cursor to beginning of line
 * `$` : Highlight until end of line
 * `H` : Highlight from cursor to beginning of file


 * `gg` : Highlight from cursor to beginning of file
 * `y` : Yank selected text block
 * `G` : Highlight from cursor to end of file
 * `L` : Highlight from cursor to end of file
 * `d` : Delete highlighted characters
 * `c` : Change highlighted characters and put us in insert mode.
 * `>` : Indent
 * `<` : Unindent
 
 
&nbsp; 

# Customization

All the following customization variables are found inside the `darvim.lua`
file.

Open the file --> Make the change --> Save the file --> Reload Hammerspoon Config



#### Increase scrolling speed with hjkl in PDF mode

```lua
-- By default, the scrolling speed is set to 4. Increase or decrease as you like
-- by changing the integer value of the @SPEED variable
local SPEED = 5 -- Increase
```


#### Add text editing application to have Vim keybinds support

```lua
-- Text-editing application is any application you want complete VIM keybinds
-- support. Not just scrolling support like in PDF applications.

-- Hypothetical original list:
local APPS = {'Xcode'}
-- If we want to add Vim support to the 'Notes' application, simply add the
--  application name into the @APPS list on darvim.lua
local APPS = {'Xcode', 'Notes'}
-- Keep appending to the list as desired. See documentation above the variable inside
--  darvim.lua for more information about application names. Examples included.
```

#### Add PDF application to have Vim keybinds support

```lua
-- Hypothetical original list:
local PDF = {'Preview'}

-- In order to add Vim keybinds to Acrobat Reader, simply add the exact name
--  into the list
local PDF = {'Preview', 'Acrobat Reader'}
```



#### Toogle Ex mode bar from Dark mode and Light mode
```lua
local isDarkMode = true --> Dark Mode
local isDarkMode = false --> Light Mode
```

#### Customize mode indicators in menu bar
```lua
-- Customize here the menu bar mode indicator icons
local normalIcon = '[ N ]'
local insertIcon = '[ I ]'
local visualIcon = '[ V ]'


--Possible change: Single letters without brackets
local normalIcon = 'N'
local insertIcon = 'I'
local visualIcon = 'V'
```


#### Application where you dont want Escape to work like the system Escape
```lua
-- There are some text-editing applications like Slack and Discord where if you
--  press Escape it takes you out of the input box. If you want to change that
--  behaviour, add the name of the application into the following list.
-- Note that it must also be present in the @APPS or @PDF list.

-- Hypothetical original list:
local appsWithEscapeSupport = {'Anki'}

-- Add the application name to the list.
local appsWithEscapeSupport = {'Anki', 'Slack', 'Discord'}
```


**Important:** After any changes, the Hammerspoon configuration must be reloaded for the changes 
to take place.


&nbsp; 


# Troubleshoot
As this is a work in progress there will be times that things start to behave
strangely (i.e VIM modes in an app we don't want). But everything is fixed right
away by simply opening spotlight and searching for: 'Hammerspoon' (Sometimes 1
search might not suffice, search again and the Hammerspoon Console will pop up).


Once inside the Hammerspoon application, press `shift + cmd + r` to reaload the
hammerspoon configuration and go back keep Viming away. Or, if you have the menu
bar icon enabled, simply click on the Hammerspoon icon on the menu bar and click 'Reload Config' 


Work is beign done to implement a single global keybind to reload the
configuration. Thus there will be no need to open the Hammerspoon console and
manually reloading the configuration.


TL;DR: If something goes wrong, open Hammerspoon and once inside press `shift + cmd + r` and
everything should work now.

&nbsp; 

# Things todo
- [ ] `Escape` : Refactor Escape key. Ex. escModeAndKey[0] = {'ctrl'}, escModeAndKey[1] = '['
- [ ] `jk` : Make it possible for user to choose `jk` and variations as their Escape key
- [ ] `?` : Search backwards
- [ ] `(` : Move to previous sentence
- [ ] `)` : Move to next sentence
- [ ] `<operator><motion><text-object>` 
- [ ] `<prefix>iw` : in word
- [ ] `<prefix>i"` : in double quotes
- [ ] `<prefix>i(` : in parenthesis
- [ ] `<prefix>i>` : in word
- [ ] `<prefix>i[` : in word
- [ ] `<prefix>i{` : in word
- [ ] `<prefix>i{` : in word

- [ ] `<prefix><times><target>` : Example: `d2w`

&nbsp; 

- [ ] ERROR HANDLING
- [ ] Fix `t` and `f`. Gonna type the next letter if there are no search
      function (i.e Anki)
- [ ] Move listeners to a separate function to avoid repetition
- [ ] Fix last operation. For example with:  `c<word>`
- [ ] Fix `ctrl + b` and `ctrl + f` scrolling bug
- [ ] Missing `.` functionality when using `r<char>`
- [ ] Disable all hotkeys when spotlight is beign used.
- [ ] Add macro recordings
- [ ] Add options in menu to let user chose keybinds for specific operations
    like (i.e Normal Mode keybind = '**choose keybind**')


# Credits
This project couldn't have been possible without [Hammerspoon](https://github.com/Hammerspoon/hammerspoon), which is a powerful OSX automation tool.

Visit their [Website](http://www.hammerspoon.org/) for more imformation.
