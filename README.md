<h1 align="center" style="font-size: 3rem;">
DarVIM
</h1>

Pseudo-VIM keybinds ONLY on the apps you decide you want VIM keybinds.


# Installation:

### Step 1: Install Hammerspoon:

##### Manual Installation:
 * Download the [latest release](https://github.com/Hammerspoon/hammerspoon/releases/latest)
 * Drag `Hammerspoon.app` from your `Downloads` folder to `Applications`

##### Homebrew installation:
  * `brew cask install hammerspoon`

### Step 2: Install DarVIM:

&nbsp; 
##### CASE 1: If you already have an `init.lua` file:

1. `git clone https://github.com/emanuel2718/DarVIM.git`

2. Copy the contents of the `init.lua` from this repo and paste it on your
    existing `init.lua` file.

3. `ln -s <path-to-DarVIM-folder>/darvim.lua ~/.hammerspoon/darvim.lua`

&nbsp; 

##### CASE 2: If you DON'T already have an `init.lua` file then on a Terminal window:



1. `git clone https://github.com/emanuel2718/DarVIM.git`

2. `mkdir ~/.hammerspoon`

3. `ln -s <path-to-DarVIM-folder>/darvim.lua ~/.hammerspoon/darvim.lua`

4. `ln -s <path-to-DarVIM-folder>/init.lua ~/.hammerspoon/init.lua`

&nbsp; 

### Step 3: Reaload Hammerspoon configuration:
Open Hammerspoon application either with a Spotlight search or by Right
clicking Hammerspoon application in Finder and selecting `Open`.
Then, press `Shift + Cmd + R` to reaload Hammerspoon configuration.
At this point VIM keybinds should be enabled while using Preview.

TLDR: `Open` Hammerspoon appllication and press `Shift + Cmd + R`.


# How to use:
**TODO:** Explain what keybinds ara available in which apps.

**TODO:** Get official movement descriptions from:
https://hea-www.harvard.edu/~fine/Tech/vi.html



# Supported Keybinds:

### Normal Mode in PDF's:
 * `h` : Scroll Left
 * `j` : Scroll Down
 * `k` : Scroll Up
 * `l` : Scroll Right
 * `g`   : Scroll Top of PDF
 * `Shift + g` : Scroll Bottom of PDF
 * `Ctrl + f` : Scroll to next page
 * `Ctrl + b` : Scroll to previous page
 
 * `ESC` : Enter Normal Mode
 * `i` : Enter Insert Mode (VIM keybinds stop working)
 * `s` : Invert screen colors

### Normal Mode:
 * `Ctrl + y` : Scroll Up
 * `Ctrl + e` : Scroll Down
 * `h` : Move Left
 * `j` : Move Down
 * `k` : Move Up
 * `l` : Move Right
 * `g` : Move to top of page


 * `Shift + g` : Move to bottom of page
 * `b` : Move to previous word
 * `w` : Move to next word
 * `e` : Move to end of word
 * `$` : Move to end of the line
 * `a` : Enter insertion mode after current character
 * `Shift + a` : Enter insertion mode after end of line
 * `Shift + i` : Enter insertion mode before first non-whitespace character
 * `Shift + o` : Open line above and enter insertion mode
 * `o` : Open line below and enter insertion mode
 * `x` : Delete single character in front of cursor
 * `s` : Delete single character in front of cursor + Insert Mode
 * `r` : Replace single character at cursor (Need to fix this)
 * `d` : Delete next word (works like `d-w`)
 * `Shift + d` : Delete to end of line
 * `Ctrl + d` : Works like `d-d` in native VIM
 * `c` : Works like `c-w` in native VIM
 * `Shift + c` : Change to end of line
 * `Ctrl + c` : Change next word (works like `c-w`)
 * `u` : Undo
 * `Ctrl + r` : Redo
 * `y` : Yank (Works like `yy` in native VIM)
 * `Shift + y` : Yank whole line
 * `p` : Paste below current cursor line (**TODO:** Change this)
 * `Shift + p` : Paste above current cursor line.
 * `/` : Search
 * `n` : Repeat last search; Foward
 * `Shift + n` : Repeat last search; Backwards
 * `>` : Indent
 * `<` : Unindent
 * `i` : Enter Insert Mode
 * `v` : Enter Visual Mode
 * `Shift + v` : Enter Visual mode and highlight whole line


### Visual Mode:
 * `h` : Highlight Left
 * `j` : Highlight Down
 * `k` : Highlight Up
 * `l` : Highlight Right
 * `e` : Highlight to end of word
 * `w` : Highlight to next of word
 * `0` : Highlight from cursor to beginning of line
 * `$` : Highlight until end of line
 * `Shift + h` : Highlight from cursor to beginning of file


 * `g` : Highlight from cursor to beginning of file
 * `y` : Yank selected text block
 * `Shift + g` : Highlight from cursor to end of file
 * `Shift + l` : Highlight from cursor to end of file
 * `d` : Delete highlighted characters
 * `c` : Change highlighted characters and put us in insert mode.
 * `>` : Indent
 * `<` : Unindent
 


# TODO LIST:
- [x] Add prefix keys functionality for cases like: `c-w`, `d-w`, etc.
- [x] Add menu bar icon to display current mode.
- [ ] Add `.` repetition functionality
- [ ] Add ex mode; thus be able to quit document using `:q` and `:wq`
- [ ] Add leader key functionality.
- [ ] Add mode in mode status in the menu bar using hs.menubar
- [ ] Add real `c-w`, `d-w`, etc. functionalities
- [ ] Complete documentation on how to install and use.
- [ ] Add Shift + `key` to scroll faster than normal scrolling speed.
- [ ] Disable all hotkeys when spotlight is beign used.
- [ ] Add macro recordings
- [ ] Add window tiling like in i3wm. Moving and resizing.
- [ ] Add options in menu to let user chose keybinds for specific operations
    like (i.e Normal Mode keybind = '**choose keybind**')


# Credits:
This project couldn't have been possible without [Hammerspoon](https://github.com/Hammerspoon/hammerspoon), which is a powerful OSX automation tool.

Visit their [Website](http://www.hammerspoon.org/) for more imformation.
