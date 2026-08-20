# my quickshell config

My config that comes from: https://github.com/doannc2212/quickshell-config

## what's included

| Module | What it does |
|--------|-------------|
| **Bar** | clock, workspaces, active window title, volume, brightness, network, battery, powerprofile, keyboard layout, system tray, now-playing indicator |
| **OSD** | on-screen display for volume and brightness changes, auto-hides |

## prerequisites

these are needed regardless of which modules you use:

- [Quickshell](https://quickshell.outfoxxed.me/) + Qt 6
- [Hyprland](https://hyprland.org/)
- a [Nerd Font](https://www.nerdfonts.com/) (i use Hack Nerd Font — swap it in the QML files if you prefer another)

optional, depending on which modules you use:

- `brightnessctl` — for brightness display and control in the bar and OSD
- `powerprofilectl` - for power profiles display
- `nmcli` — for wifi network info in the bar
- `/sys/class/power_supply/` — for battery info (standard on most laptops)
- `hyprctl` / Hyprland, `jq` — for parsing keyboard layout from hyprctl json output

## installing everything

if you'd like the full setup:

git clone https://github.com/Banderascz/quickshell.git ~/.config/quickshell
quickshell
```bash
git clone https://github.com/Banderascz/quickshell.git ~/.config/quickshell
quickshell
```

that's it — quickshell reads from `~/.config/quickshell/` by default.

## installing individual modules

each module is self-contained in its own folder with a `DefaultTheme.qml` fallback, so you can pick and choose. here's how to set up just the parts you want.

### bar

the status bar — clock, workspaces, window title, volume, brightness, network, battery, system tray, and a now-playing indicator.

**extra dependencies:** `brightnessctl`, `nmcli`, `/sys/class/power_supply/`

1. copy `bar/` into your quickshell config directory
2. in your `shell.qml`, add:

```qml
import "bar"

Bar {}
```

the bar will use its built-in Tokyo Night Night colors by default. to wire it up with the theme switcher instead, pass `theme: yourThemeObject`.

you can also toggle the bar via IPC:
```
qs ipc call bar toggle
```

### osd

a vertical pill overlay that appears on the right side of the screen when volume or brightness changes, then auto-hides after 1.5 seconds.

**extra dependencies:** `brightnessctl`

1. copy `osd/` into your quickshell config directory
2. in your `shell.qml`, add:

```qml
import "osd"

OSD {}
```

no IPC needed — it reacts automatically to PipeWire volume changes and backlight changes.

## tweaking

- **colors** — all colors live in DefaultTheme.qml and if you want other colorschemes you must manually replace colors.
- **font** — edit the default `font: "Your Font"` at the top of the entry file.   
- **layout** — rearrange widgets in `bar/Bar.qml`.
- **polling rate** — change the interval in `bar/SystemInfo.qml` (default 2s).
- **extra bar widgets** — CPU, memory, and temperature widgets are already written in `bar/Bar.qml` but commented out. uncomment them if you'd like them back (requires `top`, `free`, and `sensors`).
- **adding a module** — create a folder with an entry QML file + `DefaultTheme.qml`, add `property var theme: DefaultTheme {}`, and wire it in `shell.qml`.

## acknowledgments

this wouldn't exist without the wonderful work behind [Quickshell](https://quickshell.outfoxxed.me/), [Hyprland](https://hyprland.org/), and the theme creators:

- [Catppuccin](https://github.com/catppuccin/catppuccin) by the Catppuccin team — theme (Mocha)
