# macos-terminal-selenized

This repo is an attempt to make it a bit easier to use Jan Warchol's excellent
[Selenized color palette][1] with macOS's built-in Terminal.app.

It provides:
- A set of installable palettes for the macOS color picker
- An opinionated Terminal.app profile that uses the Selenized color palette

I'm honestly not sure if this will be useful to anyone besides myself!  It's
awfully frustrating how difficult macOS makes it to export some of these
configurations in useful, reusable formats.

## Installation

1. Download or clone this repo:
   ```bash
   git clone https://github.com/mccutchen/macos-terminal-selenized.git
   ```

2. Copy color palettes into place:
   ```bash
   cp macos-terminal-selenized/*.clr ~/Library/Colors
   ```

3. Install the terminal profile:
   ```bash
   open macos-terminal-selenized/Selenized\ Light.terminal
   ```


## Notes

- I only care about the Selenized Light theme, so that's all I have here.

- The palettes here were assembled manually in the macOS color picker by
  copy/pasting color values from [these tables][3], and then copied from
  `~/Library/Colors` into this repo.
  - (The values were actually taken from
    [jan-warchol/selenized#100][4], because the table above
    seems to be slightly outdated?)

- I'm not sure which color space should be used with Terminal.app, so there's a
  palette for both sRGB and AppleRGB. The Selenized project just provides this
  cryptic warning w/r/t choosing the right colors for Terminal.app:

  > Remember to use coordinates from correct color space.

- The included terminal profile was set up according to the mappings specified
  in the [manual installation instructions][5], and includes these additional
  tweaks according to my own preferences:
  - Font: 12pt Menlo
  - Window size: 130x30
  - <kbd>^←</kbd> and <kbd>^→</kbd> are remapped to `\033b` and `\033f`,
    respectively

## Here be dragons?

The Selenized project [warns against using Terminal.app][2] and recommends
iTerm2 instead:

> Using Selenized with OS X default terminal is problematic. That's because
> Terminal.app has a misfeature: it will modify the colors you set in
> preferences according to its own liking, and you cannot disable this
> behaviour.
>
> Therefore I strongly recommend that Mac users switch to
> [iTerm](http://www.iterm2.com/), which seems to be a much better terminal
> emulator anyway. You can find Selenized color palette for iTerm
> [here](https://github.com/jan-warchol/selenized/tree/df1c7f1f/terminals/iterm).

[1]: https://github.com/jan-warchol/selenized
[2]: https://github.com/jan-warchol/selenized/tree/df1c7f1f/terminals/terminal-app
[3]: https://github.com/jan-warchol/selenized/blob/df1c7f1f/the-values.md#selenized-light
[4]: https://github.com/jan-warchol/selenized/pull/100
[5]: https://github.com/jan-warchol/selenized/blob/df1c7f1f/manual-installation.md
