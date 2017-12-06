@echo off
@echo "Cleaning folders..."

set path_code=%1%

for /r %1 %%R in (%path_code%\__history) do if exist "%%R" (rd /s /q "%%R")
for /r %1 %%R in (%path_code%\backup) do if exist "%%R" (rd /s /q "%%R")
for /r %1 %%R in (%path_code%\lib) do if exist "%%R" (rd /s /q "%%R")
for /r %1 %%R in (%path_code%\build\debug) do if exist "%%R" (rd /s /q "%%R")
for /r %1 %%R in (%path_code%\build\release) do if exist "%%R" (rd /s /q "%%R")

del /s %path_code%\*.ec
del /s %path_code%\*.em
del /s %path_code%\*.xml
del /s %path_code%\*.html
del /s %path_code%\*.exe
del /s %path_code%\*.drc
del /s %path_code%\*.map
del /s %path_code%\*.dll
del /s %path_code%\*.dcu
del /s %path_code%\*.~*
del /s %path_code%\*.ddp
del /s %path_code%\*.ddp
del /s %path_code%\*.log
del /s %path_code%\*.stat
del /s %path_code%\*.identcache
del /s %path_code%\*.dproj.local
del /s %path_code%\*.bak
del /s %path_code%\*.o
del /s %path_code%\*.ppu
del /s %path_code%\*.dot
del /s %path_code%\*.gif
del /s %path_code%\*.svg
del /s %path_code%\*.css
