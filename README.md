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

### Normal Mode:
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
 * `f<char>` : find `<char>` occurence after cursor
 * `;` : Repeat last 'f', 'F', 't', or 'T' command
 * `,` : Reverse direction of last 'f', 'F', 't', or 'T' command
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


 * `gg` : Highlight from cursor to beginning of file
 * `y` : Yank selected text block
 * `G` : Highlight from cursor to end of file
 * `L` : Highlight from cursor to end of file
 * `d` : Delete highlighted characters
 * `c` : Change highlighted characters and put us in insert mode.
 * `>` : Indent
 * `<` : Unindent
 

&nbsp; 

# TODO LIST:
- [ ] `C-d` : Page down
- [ ] `C-trl + u` : Page up
- [ ] `jk` : Make it possible for user to choose `jk` and variations as their Escape key
- [ ] `?` : Search backwards
- [ ] `zz` : Center cursor (ctrl + z)
- [ ] `F<char>` : find `<char>` occurence before cursor in current line
- [ ] `t<char>` : find `<char>` occurence after cursor in current line + cursor
    before char
- [ ] `T<char>` : find `<char>` occurence before cursor in current line + cursor
    before char
- [ ] `^` : Move to first non-whitespace character in the line
- [ ] `-` : Move to first non-whitespace character of previous line
- [ ] `+` : Move to first non-whitespace character of next line
- [ ] `(` : Move to previous sentence
- [ ] `)` : Move to next sentence
- [ ] `<operator><motion><text-object>` 
:
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
- [ ] Fix configurarion reload bug (Sometimes it has to be clicked more than
    once for it to be responsive.)
- [ ] Create table of contents
- [ ] Create installation script
- [ ] `r<char>` handle missing keymap cases (i.e `r<+>`)
- [ ] `r<char>` handle modifiers (i.e `shift + g`)
- [ ] Missing `.` functionality when using `r<char>`
- [ ] Ability for user tho change stuff like, Apps that they want included in
    VIM mode, change Normal mode key and other options.
- [ ] Add ex mode; thus be able to quit document using `:q` and `:wq`
- [ ] Add leader key functionality.
- [ ] Complete documentation on how to install and use.
- [ ] Disable all hotkeys when spotlight is beign used.
- [ ] Add macro recordings
- [ ] Add options in menu to let user chose keybinds for specific operations
    like (i.e Normal Mode keybind = '**choose keybind**')


# Credits:
This project couldn't have been possible without [Hammerspoon](https://github.com/Hammerspoon/hammerspoon), which is a powerful OSX automation tool.

Visit their [Website](http://www.hammerspoon.org/) for more imformation.
