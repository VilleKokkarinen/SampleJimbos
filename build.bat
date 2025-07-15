@echo off
setlocal enabledelayedexpansion

for /d %%F in (*) do (
    set "foundname="

    rem Look for .json file
    for %%J in ("%%F\*.json") do (
        echo Checking file: %%J

        if exist "%%J" (
            echo Found file: %%J

            rem Read each line of the file
            for /f "usebackq tokens=*" %%L in ("%%J") do (
                set "line=%%L"
                set "line=!line: =!"  rem remove spaces

                rem Does the line start with "name":
               echo !line! | findstr /c:"\"name\":" >nul
                if !errorlevel! neq 1 (
                    rem Extract value between quotes
                    for /f "tokens=2 delims=:" %%X in ("!line!") do (
                        set "val=%%X"
                        set "val=!val:\"=!"
                        set "val=!val:,=!"
                        set "foundname=!val!"
                        goto :copy
                    )
                )
            )
        )
    )

    :copy
    if defined foundname (
        echo Found mod name: !foundname!
        xcopy /s /y .\!foundname!\ %AppData%\Balatro\Mods\!foundname!\* >nul		
		
        echo Copied to Mods\!foundname!
    ) else (
        echo no valid name found in folder
    )
)
endlocal
exit
