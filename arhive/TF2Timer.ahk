#SingleInstance FORCE ;Makes the script automatically overwrite it's old process if you run a new one.
SetTitleMatchMode 2   ;1 means winTitle must start with string, 2 means given string must be anywhere in title, 3 means given string must EXACTLY MATCH
SetWorkingDir %A_WorkingDir%

FileRead, infoString, TF2Timer.txt

oldDate := SubStr(infoString,1,2)
oldMinutes := SubStr(infoString, 3)

if(oldDate != A_DD)
{
	;This segment sets the initial time left if date is off
	InputBox, prevBedtimeString, TF2 Timer, What time did you go to bed last night? `rAssuming pm or military time.
	prevBedTime := RegExReplace(prevBedTimeString,"[^0-9]","")

	If(StrLen(prevBedTime) > 4 or StrLen(prevBedTime) < 3)
	{
		msgbox, Error, too few/many numbers
		ExitApp
	}

	bedHr := SubStr(prevBedTime, 1, StrLen(prevBedTime) - 2)
	bedMin := SubStr(prevBedTime, -1, 2)
	if(bedHr < 12)
	{
		bedHr += 12
	}
	totalMin := (24-bedHr)*60 - bedMin + 30
}
Else
{
	totalMin := oldMinutes
}

run TF2.url
sleep 3000

While(totalMin >=1 && WinExist("Team Fortress 2"))
{
	totalMin--
	sleep 60000
}
Process, Close, hl2.exe
FileDelete, TF2Timer.txt
FileAppend, %A_DD%%totalMin%, TF2Timer.txt
msgbox, That's all for today!