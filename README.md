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
 * `G` : Scroll Bottom of PDF
 * `Ctrl + f` : Scroll to next page
 * `Ctrl + b` : Scroll to previous page
 
 * `Esc` : Enter Normal Mode
 * `i` : Enter Insert Mode (VIM keybinds stop working)
 * `u` : Undo
 * `Ctrl + r` : Redo
 * `s` : Invert screen colors

&nbsp; 

### Normal Mode:
 * `Ctrl + y` : Scroll Up
 * `Ctrl + e` : Scroll Down
 * `h` : Move Left
 * `j` : Move Down
 * `k` : Move Up
 * `l` : Move Right
 * `g` : Move to top of page [**Temporary**]


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
 * `r` : Delete character + insert mode [**Temporary**]
 * `d` : Delete next word (works like `dw`) [**Temporary**]
 * `D` : Delete to end of line
 * `Ctrl + d` : Works like `dd`  [**Temporary**]
 * `cw` : Change word
 * `cc` : Change whole line
 * `C` : Change from cursor to end of line
 * `u` : Undo
 * `Ctrl + r` : Redo
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
 
&nbsp; 

### Visual Mode:
 * `h` : Highlight Left
 * `j` : Highlight Down
 * `k` : Highlight Up
 * `l` : Highlight Right
 * `e` : Highlight to end of word
 * `w` : Highlight to next of word
 * `0` : Highlight from cursor to beginning of line
 * `$` : Highlight until end of line
 * `H` : Highlight from cursor to beginning of file


 * `g` : Highlight from cursor to beginning of file
 * `y` : Yank selected text block
 * `G` : Highlight from cursor to end of file
 * `L` : Highlight from cursor to end of file
 * `d` : Delete highlighted characters
 * `c` : Change highlighted characters and put us in insert mode.
 * `>` : Indent
 * `<` : Unindent
 

&nbsp; 

# TODO LIST:
- [ ] `<key>` : Bind unusable Normal mode characters. One of those could be
    mapped by the user to be their `<leader` key.
- [ ] `dd` : Delete whole line
- [ ] `gg` : Move to top of page
- [ ] `z` : Center cursor (ctrl + z)
- [ ] `Ctrl + u` : Page up
- [ ] `Ctrl + d` : Page down
- [ ] `Ctrl + +` : Zoom in
- [ ] `Ctrl + -` : Zoom out
- [ ] `f<char>` : find `<char>` occurence after cursor in current line
- [ ] `F<char>` : find `<char>` occurence before cursor in current line
- [ ] `t<char>` : find `<char>` occurence after cursor in current line + cursor
    before char
- [ ] `T<char>` : find `<char>` occurence before cursor in current line + cursor
    before char
- [ ] `<prefix>iw` : in word
- [ ] `<prefix>i"` : in double quotes
- [ ] `<prefix>i(` : in parenthesis
- [ ] `<prefix>i>` : in word
- [ ] `<prefix>i[` : in word
- [ ] `<prefix>i{` : in word
- [ ] `<prefix>i{` : in word

&nbsp; 

- [x] Add menu bar icon to display current mode.
- [x] Add `.` repetition functionality
- [x] Add delay variable
- [x] Add mode in mode status in the menu bar using hs.menubar
- [x] Add real `cw`, `dw`, etc. functionalities
- [ ] `r<char>` handle missing keymap cases (i.e `r<+>`)
- [ ] `r<char>` handle modifiers (i.e `shift + g`)
- [ ] Missing `.` functionality when using `r<char>`
- [ ] Fix configurarion reload bug (Sometimes it has to be clicked more than
    once for it to be responsive.)
- [ ] Create installation script
- [ ] Ability for user tho change stuff like, Apps that they want included in
    VIM mode, change Normal mode key and other options.
- [ ] Add ex mode; thus be able to quit document using `:q` and `:wq`
- [ ] Add leader key functionality.
- [ ] Complete documentation on how to install and use.
- [ ] Add Shift + `key` to scroll faster than normal scrolling speed.
- [ ] Disable all hotkeys when spotlight is beign used.
- [ ] Add macro recordings
- [ ] Add options in menu to let user chose keybinds for specific operations
    like (i.e Normal Mode keybind = '**choose keybind**')


# Credits:
This project couldn't have been possible without [Hammerspoon](https://github.com/Hammerspoon/hammerspoon), which is a powerful OSX automation tool.

Visit their [Website](http://www.hammerspoon.org/) for more imformation.
