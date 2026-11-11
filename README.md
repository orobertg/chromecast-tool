# chromecast-tool

This script allows basic configuration of a Chromecast device without
having to use Google Home or any other app.

This has been tested with a 1st generation Chromecast (2013), from Linux
and from Windows 11 (Git Bash and PowerShell).

> **1st generation (2013) Chromecast owners:** you do not need the Google
> Home app, Bluetooth, or the 4-character code shown on the TV. Those are
> for newer models. This script talks to the Chromecast directly over its
> setup Wi-Fi network.

## Commands

* `connect-wifi`: Connect the Chromecast to a Wi-Fi network.
* `scan-wifi`: List the Wi-Fi networks the Chromecast can see.
* `find`: Find Chromecasts on your local network(s).
* `get-config`: Show the current Chromecast settings.
* `set-config`: Change some of the Chromecast settings.
* `get-locales`: Get a list of the supported locales.
* `get-timezones`: Get a list of the supported timezones.

Run `chromecast-tool --help` for all the options.

## Installation

The script needs [curl](https://github.com/curl/curl),
[jq](https://github.com/jqlang/jq) and
[openssl](https://github.com/openssl/openssl), plus a POSIX shell with
GNU `getopt`.

### Linux

Install the dependencies with your package manager, for example:

```
sudo apt install curl jq openssl          # Debian / Ubuntu
sudo dnf install curl jq openssl          # Fedora
```

Then run `./chromecast-tool` from the folder you cloned or downloaded.

### macOS

macOS ships a BSD `getopt` that does not support long options, so install
GNU getopt and put it first in your `PATH`:

```
brew install jq gnu-getopt
export PATH="$(brew --prefix gnu-getopt)/bin:$PATH"
```

### Windows

1. Install [Git for Windows](https://git-scm.com/download/win), which
   provides Git Bash, curl, openssl and getopt:
   ```
   winget install Git.Git
   ```
2. Install jq:
   ```
   winget install jqlang.jq
   ```
3. **Close and reopen your terminal** so it picks up the new `PATH`.
4. Clone or download this repository.

Then use either Git Bash or PowerShell, as described below.

#### Option A: Git Bash (recommended)

Open **Git Bash** from the Start menu and run the script like on Linux:

```
cd ~/path/to/chromecast-tool
./chromecast-tool get-config
```

#### Option B: PowerShell or Command Prompt

Use the included `chromecast-tool.cmd` launcher. It finds Git's `sh.exe`
for you:

```
cd C:\path\to\chromecast-tool
.\chromecast-tool.cmd get-config
```

Typing `sh .\chromecast-tool` does **not** work in PowerShell, because
`sh` is not on the Windows `PATH`.

The examples below use Git Bash / Linux syntax (`./chromecast-tool`). In
PowerShell, replace `./chromecast-tool` with `.\chromecast-tool.cmd`.
Bash line continuations (`\`) do not work in PowerShell, so put each
command on one line.

## Setting up (or moving) a Chromecast

A Chromecast needs to be connected to your Wi-Fi network. If the Wi-Fi
settings change, or the device is moved somewhere else, it needs to be
set up again. This normally requires the Google Home app, which doesn't
always work correctly and no longer supports older models well.

1. **Factory reset.** Hold the button on the Chromecast until the LED
   starts blinking (about 25 seconds on the 2013 model).
2. **Wait** for it to reboot. The TV shows a setup screen, and the
   Chromecast creates its own Wi-Fi network called `ChromecastXXXX`
   (or named after the device, if it already had a name).
3. **Connect your computer to that network.** Windows may warn that it
   has no internet access; that is expected.
4. **Check that you can reach it:**
   ```
   ./chromecast-tool get-config
   ```
5. **Optional: set its name, timezone, etc.** Use `get-timezones` and
   `get-locales` to see the valid values:
   ```
   ./chromecast-tool get-timezones | grep -i america
   ./chromecast-tool set-config --name "Living Room" --timezone America/New_York
   ```
6. **Optional: see which networks it can join:**
   ```
   ./chromecast-tool scan-wifi
   ```
7. **Connect it to your Wi-Fi.** You will be asked for the password twice
   (it is not shown as you type):
   ```
   ./chromecast-tool connect-wifi --ssid "MyNetwork"
   ```
   The SSID is case-sensitive. The script then waits until the
   Chromecast leaves its setup network, which normally means it joined
   yours. Use `--no-wait` to skip that.
8. **Done.** The TV should say *Ready to cast*. Your computer will go back
   to your normal Wi-Fi. If it doesn't, reconnect it yourself. To find
   the Chromecast's new address:
   ```
   ./chromecast-tool find
   ./chromecast-tool get-config --addr 192.168.x.y
   ```

## Troubleshooting

* **`sh` is not recognized** (PowerShell): use `.\chromecast-tool.cmd`
  or Git Bash, see [Windows](#windows).
* **`jq not found`**: install jq and open a new terminal.
* **"Wi-Fi network not found"**: 1st generation Chromecasts only support
  **2.4 GHz** networks, and cannot join hidden networks. Run `scan-wifi`
  to see what it can find. If your router uses one name for both bands,
  check that 2.4 GHz is enabled.
* **TV says "can't connect to <network>"**: almost always a wrong
  password. Its setup network comes back after a short while. Reconnect
  to it and run `connect-wifi` again (the password length is shown so
  you can double-check it). Also check that the network uses WPA2, not
  WPA3 only.
* **TV says "Ready to cast" but phones/PCs can't see it, or `find` finds
  nothing**: your router may have *AP isolation* / *client isolation*
  enabled, which stops devices on the same Wi-Fi from talking to each
  other. Turn it off in the router settings. A freshly set up Chromecast
  may also spend a few minutes updating its firmware first.
* **`get-config` can't connect while on the setup network**: make sure
  your computer is really connected to the `ChromecastXXXX` network (and
  not automatically switched back to your normal Wi-Fi), and that no VPN
  is active.
