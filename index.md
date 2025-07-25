## **Check NexusMods for Subnautica and Subnautica Below Zero Mod Updates**
**Features**

\- Check .zip mod files against NexusMods and highlight if the local version is the latest version.  
\- Give the option to open the mod page on NexusMods if a newer version is available.

***Last updated: 25th July 2025.***

### ***Initial Requirements***
1. Download the PowerShell script to a folder of your choosing and call it whatever you want  
   The file must end in `.ps1` to be recognised by PowerShell.

2. Create a file called apikey.txt that contains your personal API key from NexusMods  
   This key lets the script access the NexusMods API on your behalf.

3. Have Subnautica .zip files in their own folder  
   Store only Subnautica mods here—do not mix with Below Zero mods.

4. Have Subnautica Below Zero .zip mod files in their own folder  
   Keep these separate from Subnautica mods for correct version checking.

5. Get yourself a copy of Notepad++ for editing the script  
   Notepad++ is recommended for its syntax highlighting and ease of use.

### ***Links***
Nexus Mods - https://www.nexusmods.com/

## **Let's start. Step by Step**
There are a few things that must be done before using the script  
1. Download or copy the script to a folder and filename of your choosing  
   Make sure it's saved in a known location for easy access in PowerShell.

2. Update Line 2 in the script with the path and name of the script file  
   Example: `powershell -ExecutionPolicy Bypass -File "C:\Scripts\CheckSubMods.ps1"`

3. Get your personal API key from NexusMods (you will need to create an account to do this) 
   You can find your personal API key under your profile settings on the NexusMods website.

4. Put the API key into a file named apikey.txt and update Line 10 in the script with the path and name of the file  
   The script will read from this file to authenticate requests.  
   Example: `$apiKeyPath = "C:\Games\Nexusmods\SoftwareKeys\apikey.txt"`

5. Organise the .zip files of the mods you use into folders. One folder for Subnautica and one folder for Subnautica Below Zero  
   This helps the script separate mods by game and avoid mismatches.

6. Update Lines 13 & 14 in the script with the full path for the folders  
   Example: `@{ Path = "C:\Games\SubnauticaMods";        Domain = "subnautica" },`  
   and `@{ Path = "C:\Games\BelowZeroMods";         Domain = "subnauticabelowzero" }`

## **How to use**
Open PowerShell as Administrator  
Copy and paste Line 2 into PowerShell and press Enter  
The script will extract the NexusMods ID code for each of the .zip files and check the file name against NexusMods using their API. If an updated file is found, the script gives the option to open the corresponding webpage for the mod.

After the page is opened, you can return to the script and continue checking.  
As the script progresses, a new page will be opened for each mod that has an update available.  
The script does not download the newer mod; it must be downloaded manually. The old mod file should be deleted and replaced with the new one.  

After all mods have been checked and downloaded, you can install each mod using the instructions provided by the mod author.
