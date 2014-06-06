i3lock-spy : Fork of i3lock for justbrowsing using fswebcam to monitor intruders
---------------------------------------------------------------------------------
Minor modification of i3lock: http://code.stapelberg.de/git/i3lock
Background resizing patches from: https://github.com/jaseg/i3lock

* New: Added zoom and fit background patches
* New: Switched from sed hackery to a proper Makefile
* New: Added CSS styling for intruder log
* New: Renamed i3lock-spy-wbar to i3lock-spy-panel
* New: Updated manpage

* Added libv4l preload to flip webcam where appropriate
* Rewrote i3lock-sentry script
* Added hooks for fswebcam to i3lock
* Allow mouse pass-through
* Resize i3lock to allow for a top panel (e.g. wbar)
* Generate report with i3lock-sentry script

Check out the JustBrowsing LiveCD projct: http://justbrowsing.info
