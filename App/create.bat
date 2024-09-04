@echo off
setlocal

rem Define the directory where files will be created
set "directory=python_files"
if not exist "%directory%" mkdir "%directory%"

rem Create blank Python files
echo. > "%directory%\hotel.py"
echo. > "%directory%\room_type.py"
echo. > "%directory%\available_room_per_hotel.py"
echo. > "%directory%\event_type.py"
echo. > "%directory%\service_type.py"
echo. > "%directory%\guest.py"
echo. > "%directory%\event_reservation.py"
echo. > "%directory%\service_reservation.py"
echo. > "%directory%\hotel_management.py"
echo. > "%directory%\room_management.py"
echo. > "%directory%\event_management.py"
echo. > "%directory%\service_management.py"
echo. > "%directory%\guest_management.py"
echo. > "%directory%\reservation_management.py"
echo. > "%directory%\reporting.py"

echo 15 blank Python files have been created in the "%directory%" directory.

endlocal
