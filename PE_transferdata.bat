@REM ---------Sean Conrad---------
@REM ----------2/14/18------------
@REM Used to copy data off of a person's computer to
@REM their shared home drive


@echo off

REM ---------Run bitlocker command to get the Bilocker Key ID for user---------
manage-bde -protectors C: -get

@REM ---------Prompt user for inputs---------
set /p your_id="Enter your ID: "
set /p pwd="Enter Password: "
set /p user_id="Enter user's ID: "
echo The next prompt is for a bitlocker key. If you are booted in to Windows or bitlocker is not enabled, press ENTER to skip.
set /p bitlockerkey="BitLocker Recovery Key : "format xxxxxx-xxxxxx..." : "


@REM ---------Create Date Format---------
@REM echo Date format = %date%
set dd=%date:~7,2%-
set mm=%date:~3,3%-
set yyyy=%date:~10,7%
set today=%mm%%dd%%yyyy%


@REM ---------Unlock Drive---------
manage-bde -unlock C: -RecoveryPassword %bitlockerkey%
manage-bde -protectors -disable C:

@REM ---------Set up Source and Destination Paths---------
set source_dir=c:\users\%user_id%
set destination_dir=\\

@REM ---------Connect to Remote Server---------

net use t: %destination_dir% %pwd% /USER:<domain>\%your_id%

@REM ---------Copy Over Data-------------------
echo d | xcopy %source_dir%\Desktop t:\"IT_backup%today%"\Desktop /E

echo d | xcopy %source_dir%\Documents t:\"IT_backup%today%"\Documents /E

echo d | xcopy %source_dir%\Favorites t:\"IT_backup%today%"\Favorites /E

cd %source_dir%\AppData\Local\Google\Chrome\User Data\Default

copy Bookmarks t:\"IT_backup%today%"\ChromeBookmarks

echo d | xcopy %source_dir%\AppData\Roaming\Mozilla\Firefox t:\"IT_backup%today%"\Firefox /E

echo d | xcopy %source_dir%\AppData\Roaming\Microsoft\Signatures t:\"IT_backup%today%"\Signatures /E