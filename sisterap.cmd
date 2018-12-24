@echo off

set stereotool_licence=""
set "sts_folder=%~sdp0."

set sts_idx_sel=
set dest_type=

set "this_cmd=%~dpnx0"

if "%~n1" == "#direct" (
  set dest_type=%2
  set sts_idx_sel=%3
  shift
  shift
  shift
)

echo.
echo Simple Stereotool Audio Processor (SISTERAP) 2018.12.23.1
  
set path=%~dp0;%path


:sel_sts
  
  if x%sts_idx_sel% == x (
    echo.
    echo Select Stereotool preset:
    set /a sts_idx=0
    for /f "tokens=*" %%f in ('dir /b %sts_folder%\*.sts') do call :sub_echo_sts "%%f"
    set /p sts_idx_sel=^>
  )
  if x%sts_idx_sel% == x set sts_idx_sel=1
  
  set stereotool_cfg=""
  set sts_idx=0
  for /f "tokens=*" %%f in ('dir /b %sts_folder%\*.sts') do call :sub_sel_sts "%%f"
  
  if %stereotool_cfg% == "" goto sel_sts
  
  echo.
  echo Selected preset: %stereotool_cfg%
  
  if x%dest_type% == x (
    echo.
    echo Destination:
    echo Replace audio track in source [V]ideo ^(default^)
    echo [M]P3
    echo [W]AV
    set /p dest_type=^>
  )
  if "%dest_type%"=="" set dest_type=V
  
  if not "%~n2"=="" (
    echo.
    echo Process files in multiple threads?
    echo [Y]es ^(default^)
    echo [N]o
    set /p use_mt=^>
  )
  if "%use_mt%"=="" set use_mt=Y
  if "%~n2"=="" set use_mt=N

  set license_param=
  if not %stereotool_licence%=="" set license_param=-k %stereotool_licence%
  
  :startprocess
  
  set "src_file=%~dpnx1"
  set "src_type=%~x1"
  set /a fidx=0
  
  set "dest_ext=%~x1"
  if /i "%dest_type%"=="M" ( 
    set dest_ext=.mp3
  ) else ( 
    if /i "%dest_type%"=="W" ( 
      set dest_ext=.wav
    ) 
  )   

  :render_finalname
  
  set /a fidx+=1
  
  set "dest_file=%~dpn1.processed.%fidx%%dest_ext%"
  
  if exist "%dest_file%" goto render_finalname

  if /i %use_mt% == N (
    title "%~n1"
    call :sub_processfile
  ) else (
    start "" cmd /c %this_cmd% #direct %dest_type% %sts_idx_sel% "%~dpnx1" 
  )

  shift

  if not "%~n1"=="" goto :startprocess

  goto eob


:sub_processfile

  if /i "%dest_ext%"==".wav" (
    set "temp_procwav=%dest_file%"
  ) else (
    set "temp_procwav=%dest_file%.wav"
  )
  
  set temp_wav=
  if /i not "%src_type%"==".wav" (
    set "temp_wav=%dest_file%.tmp.wav"
  )

  if not "%temp_wav%"=="" "%~dp0ffmpeg.exe" -y -i "%src_file%" -vn -ac 2 -af "aresample=matrix_encoding=dplii" "%temp_wav%"
  
  set "stt_src_wav=%temp_wav%"
  if "%stt_src_wav%"=="" set "stt_src_wav=%src_file%"

  "%~dp0stereo_tool_cmd.exe" "%stt_src_wav%" "%temp_procwav%" -s %stereotool_cfg% %license_param%
  
  if not "%temp_wav%"=="" del "%temp_wav%"

  echo.
  
  if /i "%dest_type%"=="M" (
     "%~dp0ffmpeg.exe" -y -i "%temp_procwav%" -acodec libmp3lame -ac 2 -aq 0 -af "anull " -vn "%dest_file%"
    del "%temp_procwav%"
  ) else (
    if /i "%dest_type%"=="W" ( 
      rem keep WAV
    ) else (
      "%~dp0ffmpeg.exe" -y -i "%src_file%" -i "%temp_procwav%" -map 1:0 -map 0:0 -strict -2 -acodec aac -ac 2 -ab 192k -bsf:a aac_adtstoasc -af "anull " -c:v copy "%dest_file%"
      del "%temp_procwav%"
    )
  )
  
  goto eob


:sub_echo_sts 

  set /a sts_idx+=1
  echo [%sts_idx%] %~n1

  goto eob
  

:sub_sel_sts

  set /a sts_idx+=1 
  if %sts_idx%==%sts_idx_sel% set stereotool_cfg="%sts_folder%\%~nx1"
  
  goto eob

  
:eob
