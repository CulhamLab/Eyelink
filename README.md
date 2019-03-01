# Eyelink Repository
Instructions and scripts for collecting and analyzing data with Eyelink 1000 using MATLAB with PsychToolbox.

---

# Data Collection

## Requirements
1. Windows (for SR Research SDK)
1. MATLAB (32 or 64 bit)
1. PsychToolbox (instructions [here](http://psychtoolbox.org/download))
1. SR Research SDK (download [here](http://download.sr-support.com/displaysoftwarerelease/EyeLinkDevKit_Windows_1.11.5.zip))

## Network Setup
*This process will disable network and internet access until manually undone. To undo, follow the same steps but set the TCP/IPv4 back to automatic ip.*
1. Connect ethernet cable from Eyelink PC to MATLAB PC
1. On the MATLAB PC...
1. Open the Network Connections display...
    1. Windows 7:
        1. Press START and search for "View Network Connections" and open it
    1. Windows 10:
        1. Press START and search for "Change Ethernet Settings" and open it
        1. Click "Change Adapter Settings"
1. Identify the "Local Area Connection" (might be called Ethernet) that corresponds with the connection to the Eyelink PC (in most cases, there is only one). If there are multiple "Local Area Connection", look for the one that is connected. You may need to turn the Eyelink PC on from connection status to be displayed.
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
1. TODO
