# SISTERAP - Simple Stereotool Audio Processor

This is a Windows CLI script to process an audio track with a Stereotool preset and create a new video with the processed track as a replacement (or just a WAV/MP3 of the processed track).

The script needs FFMPEG and Stereotool-Commandline installed in the same folder or its binary folders included in the Windows PATH environment variable.

Download FFMPEG: https://www.ffmpeg.org/download.html  
Download StereoTool command line: https://www.stereotool.com/download/

Example installation in a folder:  
<img src="https://i.imgur.com/1v7O5c2.png">

## Config

If you have a key for StereoTool, enter it in the script in the line

    set stereotool_licence=""

at the beginning of the script (between the quotation marks, like `<KEYVALUE>`)

If you have your presets in a different folder installed than the folder where the script is copied to, enter the folder in the line

    set "sts_folder=%~sdp0."

at the beginning of the script (replace "%~sdp0." with the folder name, like "c:\my\stereotool\preset\folder").

## Execution

Just drag and drop one or more files onto the script 

or place a link to it in the Send-To folder of your Windows (location: `%APPDATA%\Microsoft\Windows\SendTo`), select one or more files in the file explorer and run the script from the Send-To context menu option.
