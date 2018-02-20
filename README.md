# SISTERAP - Simple Stereotool Audio Processor

This is a Windows CLI script to process an audio track with a Stereotool preset and create a new video with the processed track as a replacement.

The script needs FFMPEG and Stereotool-Commandline installed in the same folder or its binary folders included in the Windows PATH environment variable.

Download FFMPEG: https://www.ffmpeg.org/download.html
Download StereoTool command line: https://www.stereotool.com/download/

If you have a key for StereoTool, enter it in the script in the line

set stereotool_licence=""

at the beginning of the script (between the quotation marks, like "<KEYVALUE>")

If you have your presets in a different folder installed than the folder where the script is copied to, enter the folder in the line

set "sts_folder=."

at the beginning of the script (replace "." with the folder name, like "c:\my\stereotool\preset\folder").
