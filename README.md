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


&nbsp; 

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

&nbsp; 

### Normal Mode:
- [x] `Ctrl + y` : Scroll Up
- [x] `Ctrl + e` : Scroll Down
- [x] `h` : Move Left
- [x] `j` : Move Down
- [x] `k` : Move Up
- [x] `l` : Move Right
- [x] `g` : Move to top of page


- [x] `Shift + g` : Move to bottom of page
- [x] `b` : Move to previous word
- [x] `w` : Move to next word
- [x] `e` : Move to end of word
- [x] `$` : Move to end of the line
- [x] `a` : Enter insertion mode after current character
- [x] `Shift + a` : Enter insertion mode after end of line
- [x] `Shift + i` : Enter insertion mode before first non-whitespace character
- [x] `Shift + o` : Open line above and enter insertion mode
- [x] `o` : Open line below and enter insertion mode
- [x] `x` : Delete single character in front of cursor
- [x] `s` : Delete single character in front of cursor + Insert Mode
- [x] `Shift + s` : Substitutes entire line/Delete line + Insert Mode
- [ ] `r<char>` : Replace single character at cursor (Missing)
- [x] `r` : delete character + insert mode
- [ ] `dw` : Delete next word
- [x] `d` : Delete next word (works like `dw`)
- [ ] `dd` : Delete whole line
- [x] `Ctrl + d` : Works like `dd` 
- [x] `Shift + d` : Delete to end of line
- [ ] `cw` : Change word
- [x] `c` : Works like `cw`
- [x] `Shift + c` : Change to end of line
- [x] `Ctrl + c` : Change next word (works like `c-w`)
- [x] `u` : Undo
- [x] `Ctrl + r` : Redo
- [x] `y` : Yank (Works like `yy` in native VIM)
- [x] `Shift + y` : Yank whole line
- [x] `p` : Paste
- [x] `Shift + p` : Paste above current cursor line.
- [x] `/` : Search
- [x] `n` : Repeat last search; Foward
- [x] `Shift + n` : Repeat last search; Backwards
- [x] `>` : Indent
- [x] `<` : Unindent
- [x] `i` : Enter Insert Mode
- [x] `v` : Enter Visual Mode
- [x] `Shift + v` : Enter Visual mode and highlight whole line

&nbsp; 

### Visual Mode:
- [x] `h` : Highlight Left
- [x] `j` : Highlight Down
- [x] `k` : Highlight Up
- [x] `l` : Highlight Right
- [x] `e` : Highlight to end of word
- [x] `w` : Highlight to next of word
- [x] `0` : Highlight from cursor to beginning of line
- [x] `$` : Highlight until end of line
- [x] `Shift + h` : Highlight from cursor to beginning of file


- [x] `g` : Highlight from cursor to beginning of file
- [x] `y` : Yank selected text block
- [x] `Shift + g` : Highlight from cursor to end of file
- [x] `Shift + l` : Highlight from cursor to end of file
- [x] `d` : Delete highlighted characters
- [x] `c` : Change highlighted characters and put us in insert mode.
- [x] `>` : Indent
- [x] `<` : Unindent
 

&nbsp; 

# TODO LIST:
- [x] Add prefix keys functionality for cases like: `c-w`, `d-w`, etc.
- [x] Add menu bar icon to display current mode.
- [x] Add `.` repetition functionality
- [x] Add delay variable
- [ ] Create installation script
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
