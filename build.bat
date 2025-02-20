@echo off

set name=SampleJimbos

xcopy /s /y .\%name%\ %Appdata%\Balatro\Mods\%name%\*

exit