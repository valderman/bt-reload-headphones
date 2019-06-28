bt-reload-headphones
====================

Workaround for Sony (and possibly other) BT headphones refusing to switch
over to A2DP audio sink profile.


What does it do?
----------------

This package installs a script (`bt-reload-headphones`) to disconnect
and then reconnect to any BT device which (a) supports the audio sink profile,
and (b) is for some reason unable to switch over to it.
It also installs a udev rule to execute this script automatically when a BT
device is connected. This feature can be turned off.


Installation
------------

### For Debian, Ubuntu, Mint, other Debian-based
Download the `.deb` file, then install it as you normally would:
`sudo dpkg -i bt-reload-headphones_<version>.deb`

### For other distributions
Clone the repository, run `make`, then run `sudo make install`.
The script can be uninstalled by running `sudo make uninstall`.


Help! It doesn't work!
----------------------

If your headphones still won't switch over to A2DP mode with this workaround,
your problem probably goes deeper. Sometimes un-pairing and then re-pairing
your headphones solves the problem. If it doesn't, I'm afraid this tool
is unlikely to help you.


Configuration
-------------

This package can be configured by editing the `/etc/bt-reload-headphones.conf`
configuration file. The following parameters are supported:

* `PULSEAUDIO_USER`: name or id of the user running the Pulse Audio daemon.
  Used to determine whether it's possible to switch audio devices over to A2DP
  or not.
  If unset, the script will attempt to automatically find an appropriate user.
* `DEVICE_BLACKLIST`: space-separated list of MAC addresses of BT devices that
  should never be reconnected. List must be given in "quotes".
* `DEVICE_WHITELIST`: space-separated list of MAC addresses of BT devices that
  we're allowed to reconnect. If empty, all devices supporting the A2DP profile
  are examined. List must be given in "quotes".
* `AUTORUN`: should the script run automatically whenever a BT device is
  connected? Set to `yes` (the default) to enable, any other value to disable.
