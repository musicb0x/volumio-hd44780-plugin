#!/bin/bash
## HD44780 installation script
apt-get update
apt-get --assume-yes install -y -q python-smbus i2c-tools lcdproc python-mpd python-pip zip

pip install mpdlcd

wget -O /etc/mpdlcd.conf https://github.com/Saiyato/volumio-hd44780-plugin/blob/master/mpdlcd.conf

# Driver installation
mkdir /home/volumio/raspdrivers

# // ARMv6 -> rPi 1 A/A+/B/B+/Zero
wget -O /home/volumio/raspdrivers/hd44780.so https://github.com/Saiyato/volumio-hd44780-plugin/blob/master/Driver/hd44780.so

rm /etc/LCDd.conf

echo "# LCDd.conf -- configuration file for the LCDproc server daemon LCDd
#
# This file contains the configuration for the LCDd server.
#
# The format is ini-file-like. It is divided into sections that start at
# markers that look like [section]. Comments are all line-based comments,
# and are lines that start with '#' or ';'.
#
# The server has a 'central' section named [server]. For the menu there is
# a section called [menu]. Further each driver has a section which
# defines how the driver acts.
#
# The drivers are activated by specifying them in a driver= line in the
# server section, like:
#
#   Driver=curses
#
# This tells LCDd to use the curses driver.
# The first driver that is loaded and is capable of output defines the
# size of the display. The default driver to use is curses.
# If the driver is specified using the -d <driver> command line option,
# the Driver= options in the config file are ignored.
#
# The drivers read their own options from the respective sections.
# Andy Pi version2 with GPIO14 and GPIO18 swapped to enable same pins for use with Raspbian



## Server section with all kinds of settings for the LCDd server ##
[server]

# Where can we find the driver modules ?
# IMPORTANT: Make sure to change this setting to reflect your
#            specific setup! Otherwise LCDd won't be able to find
#            the driver modules and will thus not be able to
#            function properly.
# NOTE: Always place a slash as last character !
DriverPath=/home/volumio/raspdrivers/

# Tells the server to load the given drivers. Multiple lines can be given.
# The name of the driver is case sensitive and determines the section
# where to look for further configuration options of the specific driver
# as well as the name of the dynamic driver module to load at runtime.
# The latter one can be changed by giving a File= directive in the
# driver specific section.
#
# The following drivers are supported:
#   bayrad, CFontz, CFontz633, CFontzPacket, curses, CwLnx, ea65,
#   EyeboxOne, g15, glcdlib, glk, hd44780, icp_a106, imon, imonlcd,
#   IOWarrior, irman, joy, lb216, lcdm001, lcterm, lirc, lis, MD8800,
#   mdm166a, ms6931, mtc_s16209x, MtxOrb, mx5000, NoritakeVFD, picolcd,
#   pyramid, sed1330, sed1520, serialPOS, serialVFD, shuttleVFD, sli,
#   stv5730, svga, t6963, text, tyan, ula200, xosd
Driver=hd44780

# Tells the driver to bind to the given interface
Bind=127.0.0.1

# Listen on this specified port; defaults to 13666.
Port=13666

# Sets the reporting level; defaults to 2 (warnings and errors only).
#ReportLevel=3

# Should we report to syslog instead of stderr ? [default: no; legal: yes, no]
#ReportToSyslog=yes

# User to run as.  LCDd will drop its root privileges, if any,
# and run as this user instead.
User=nobody

# The server will stay in the foreground if set to true.
#Foreground=no

# Hello message: each entry represents a display line; default: builtin
Hello=\"  Welcome to\"
Hello=\"  VOLUMIO 2!\"

# GoodBye message: each entry represents a display line; default: builtin
GoodBye=\"Thanks for using\"
GoodBye=\"  VOLUMIO 2!\"

# Sets the default time in seconds to displays a screen.
WaitTime=5

# If set to no, LCDd will start with screen rotation disabled. This has the
# same effect as if the ToggleRotateKey had been pressed. Rotation will start
# if the ToggleRotateKey is pressed. Note that this setting does not turn off
# priority sorting of screens. [default: on; legal: on, off]
#AutoRotate=no

# If yes, the the serverscreen will be rotated as a usual info screen. If no,
# it will be a background screen, only visible when no other screens are
# active. The special value 'blank' is similar to no, but only a blank screen
# is displayed. [default: on; legal: on, off, blank]
ServerScreen=no

# Set master backlight setting. If set to 'open' a client may control the
# backlight for its own screens (only). [default: open; legal: off, open, on]
Backlight=open
#BacklightInvert=yes

# Set master heartbeat setting. If set to 'open' a client may control the
# heartbeat for its own screens (only). [default: open; legal: off, open, on]
#Heartbeat=open

# set title scrolling speed [default: 10; legal: 0-10]
#TitleSpeed=10

# The \"...Key=\" lines define what the server does with keypresses that
# don't go to any client. The ToggleRotateKey stops rotation of screens, while
# the PrevScreenKey and NextScreenKey go back / forward one screen (even if
# rotation is disabled.
# Assign the key string returned by the driver to the ...Key setting. These
# are the defaults:
ToggleRotateKey=Enter
PrevScreenKey=Left
NextScreenKey=Right
#ScrollUpKey=Up
#ScrollDownKey=Down


## The menu section. The menu is an internal LCDproc client. ##
[menu]
# You can configure what keys the menu should use. Note that the MenuKey
# will be reserved exclusively, the others work in shared mode.

# Up to six keys are supported. The MenuKey (to enter and exit the menu), the
# EnterKey (to select values) and at least one movement keys are required.
# These are the default key assignments:
MenuKey=Escape
EnterKey=Enter
UpKey=Up
DownKey=Down
#LeftKey=Left
#RightKey=Right


### Driver sections are below this line, in alphabetical order  ###

## Hitachi HD44780 driver ##
[hd44780]

# Select what type of connection. See documentation for types.
ConnectionType=i2c

# Port where the LPT is. Usual value are: 0x278, 0x378 and 0x3BC
Port=0x27

# Device of the serial interface [default: /dev/lcd]
Device=/dev/i2c-1

# Bitrate of the serial port (0 for interface default)
Speed=0

# If you have a keypad connected.
# You may also need to configure the keypad layout further on in this file.
Keypad=no

# Set the initial contrast (bwctusb and lcd2usb) [default: 500; legal: 0 - 1000]
Contrast=0

# Set brightness of the backlight (lcd2usb only) [default: 0; legal: 0 - 1000]
#Brightness=1000
#OffBrightness=0

# If you have a switchable backlight.
Backlight=no

# If you have the additional output port (\"bargraph\") and you want to
# be able to control it with the lcdproc OUTPUT command
OutputPort=no

# Specifies if the last line is pixel addressable (yes) or it controls an
# underline effect (no). [default: yes; legal: yes, no]
#Lastline=yes

# Specifies the size of the LCD.
# In case of multiple combined displays, this should be the total size.
Size=16x2

i2c_line_RS=0x01
i2c_line_RW=0x02
i2c_line_EN=0x04
i2c_line_BL=0x08
i2c_line_D4=0x10
i2c_line_D5=0x20
i2c_line_D6=0x40
i2c_line_D7=0x80

# If the display is connected to non-default GPIO pins, the driver can
# recognise these with pin assignment commands. 
# commented out as these are the defaults
#D7=18
#D6=23
#D5=24
#D4=25
#RS=7
#EN=8

# For multiple combined displays: how many lines does each display have.
# Vspan=2,2 means both displays have 2 lines.
#vspan=2,2

# If you have an HD66712, a KS0073 or another 'almost HD44780-compatible',
# set this flag to get into extended mode (4-line linear).
#ExtendedMode=yes

# In extended mode, on some controllers like the ST7036 (in 3 line mode)
# the next line in DDRAM won't start 0x20 higher. [default: 0x20]
#LineAddress=0x10

# Character map to to map ISO-8859-1 to the LCD's character set
# [default: hd44780_default; legal: hd44780_default, hd44780_euro, ea_ks0073,
# sed1278f_0b, hd44780_koi8_r, hd44780_cp1251, hd44780_8859_5, upd16314 ]
# (hd44780_koi8_r, hd44780_cp1251, hd44780_8859_5 and upd16314 are possible if
# compiled with additional charmaps)
CharMap=hd44780_default

# If your display is slow and cannot keep up with the flow of data from
# LCDd, garbage can appear on the LCDd. Set this delay factor to 2 or 4
# to increase the delays. Default: 1.
#DelayMult=2

# Some displays (e.g. vdr-wakeup) need a message from the driver to that it
# is still alive. When set to a value bigger then null the character in the
# upper left corner is updated every <KeepAliveDisplay> seconds. Default: 0.
#KeepAliveDisplay=0

# If you experience occasional garbage on your display you can use this
# option as workaround. If set to a value bigger than null it forces a
# full screen refresh <RefreshDiplay> seconds. Default: 0.
#RefreshDisplay=5

# You can reduce the inserted delays by setting this to false.
# On fast PCs it is possible your LCD does not respond correctly.
# Default: true.
DelayBus=true

# If you have a keypad you can assign keystrings to the keys.
# See documentation for used terms and how to wire it.
# For example to give directly connected key 4 the string \"Enter\", use:
#   KeyDirect_4=Enter
# For matrix keys use the X and Y coordinates of the key:
#   KeyMatrix_1_3=Enter
KeyMatrix_4_1=Enter
KeyMatrix_4_2=Up
KeyMatrix_4_3=Down
KeyMatrix_4_4=Escape

# EOF" | sudo tee -a /etc/LCDd.conf

rm /etc/init.d/mpdlcd
echo "#! /bin/sh
case \"$1\" in
    start)
        /usr/local/bin/mpdlcd --no-syslog &
        ;;
    stop)
        killall mpdlcd
        ;;
    *)
        echo \"Usage: /etc/init.d/mpdlcd {start|stop}\"
        exit 1
        ;;
esac
exit 0
#" | sudo tee -a /etc/init.d/mpdlcd

chmod a+x /etc/init.d/mpdlcd

update-rc.d mpdlcd defaults
update-rc.d LCDd defaults