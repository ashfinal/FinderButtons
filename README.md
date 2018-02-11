# FinderButtons

**FinderButtons** is my button cellection for Finder, which are written in **AppleScript**.

This repository is inspired by [LTFinderButtons](https://github.com/lexrus/LTFinderButtons), but focuses on **AppleScript**, and intends to do more.

## How to use?

Download from [here](https://github.com/ashfinal/FinderButtons/releases), move the bundles into `Applications` directory. Then drag each one into Finder toolbar while holding down <kbd>Command</kbd> key.

## Buttons

*There is only one button now, but I'm planning to add more.*

1. TerminalHere - A replacement for [Go2Shell](https://itunes.apple.com/cn/app/go2shell/id445770608?mt=12)

   Clever than the latter, it will

   - Reuse current tab of current window instead of always opening new window.

   - Select certain folder/app bundle/Workflow…and `cd` to the subfolder of them.

   - Detect busy terminal window(vim, wget, etc) to open new window, or not.

   - Easy to maintain and keep working, because it's written in AppleScript!

## Contribute

Please include your source file and exported app bundle. 

If need external programs in your script, remember to mention them in README.

Export your script to **Application**, and replace the `applet.icns` with your own.

## LICENSE

MIT
