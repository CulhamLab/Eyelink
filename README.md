# Eyelink Repository
Instructions and scripts for collecting and analyzing data with Eyelink 1000 using MATLAB with PsychToolbox. A demo is included with the collection scripts.

---

# Data Collection

## Requirements
1. Windows (for SR Research SDK)
1. MATLAB (32 or 64 bit)
1. PsychToolbox (instructions [here](http://psychtoolbox.org/download))
1. SR Research SDK (download [here](http://download.sr-support.com/displaysoftwarerelease/EyeLinkDevKit_Windows_1.11.5.zip) and install)
1. A computer with an Ethernet port (some laptops do not have this)

## Network Configuration
*This process will disable network and internet access until manually undone. To undo, follow the same steps but set the TCP/IPv4 back to automatic ip. This process does not need to be repeated unless it has been manually undone.*
1. On the MATLAB PC...
1. Open the Network Connections display...
    1. Windows 7:
        1. Press START
        1. Search for "View Network Connections"
        1. Select the match
    1. Windows 10:
        1. Press START
        1. Search for "Change Ethernet Settings"
        1. Select the match
        1. Click "Change Adapter Settings"
1. Identify the "Local Area Connection" (might be called Ethernet) that corresponds with the connection to the Eyelink PC (in most cases, there is only one). If there are multiple "Local Area Connection", look for the one that is connected. Alternatively, you could complete the following steps for each if you are not sure which one is used.
1. Right click on the "Local Area Connection" and select properties
1. Click on "Internet Protocol Version 4 (TCP/IPv4)" and click Properties
1. Switch from automatic ip to specified ip (top section)
1. Enter:
    * IP: 100.1.1.2
    * Subnet: 255.255.255.0
    * Gateway: leave blank
1. Click OK
1. You may now close everything

## Setup
1. Ensure that the network settings have been adjusted (see above). You do not need to repeat this if the changes have already been set and not manually undone.
1. Turn off the Eyelink PC if it is already on
1. Close MATLAB if it is already open
1. Connect the Ethernet cable from Eyelink PC to MATLAB PC
1. Connect the power cable from an outlet to the Eyelink
1. Connect the data cable from the Eyelink PC to the Eyelink
1. Connect the two plugs labeled L and R into the Left and Right sockets on the IR source box
1. Turn on the Eyelink PC and select to boot Eyelink (instead of Windows) when prompted
1. The Eyelink PC will enter DOS. Type `elcl` and press ENTER to start the Eyelink software
1. Ensure that Eyelink software does not say “Cable FAULT” in the top right corner. If it does, check the Ethernet cable and turn the Eyelink PC off and then on again.
1. Start MATLAB on the MATLAB PC

---

# Analysis

TODO
