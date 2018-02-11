# FinderButtons

**FinderButtons** is my button cellection for Finder, it is inspired by [LTFinderButtons](https://github.com/lexrus/LTFinderButtons), but focuses on **AppleScript**, and intends to do more.

## How to use?

Download from [here](https://github.com/ashfinal/FinderButtons/releases), move the bundles into `Applications` directory. Then drag each one into Finder toolbar while holding down <kbd>Command</kbd> key.

## Buttons

*For now there is only one button, but I'm planning to add more.*

1. TerminalHere - A replacement for [Go2Shell](https://itunes.apple.com/cn/app/go2shell/id445770608?mt=12)

   It's clever than the latter.

   - Reuse current tab of current window instead of always opening new window.

   - Select certain folder/app bundle/Workflow… and `cd` to the subfolder of them.

   - Detect busy terminal window(vim, wget, etc) to open new window, or not.

   - Easy to maintain, because it's written in AppleScript!

## Contribute

Please include the source script and exported app bundle. When export your script to **Application**, replacing `applet.icns` with your own is a good idea.

If your script needs external programs, remember to mention them in README.

## LICENSE

MIT
