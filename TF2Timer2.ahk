#SingleInstance FORCE ;Makes the script automatically overwrite its old process if you run a new one.
#NoTrayIcon
SetTitleMatchMode 2   ;1 means winTitle must start with string, 2 means given string must be anywhere in title, 3 means given string must EXACTLY MATCH
SetWorkingDir %A_WorkingDir%

Loop {
	If(WinExist("Team Fortress 2")) {
		FileRead, infoString, TF2Timer.txt
		oldDate := SubStr(infoString,1,2)
		oldMinutes := SubStr(infoString, 3)

		If(oldDate != A_DD){
			InputBox, prevBedtimeString, TF2 Timer, What time did you go to bed last night? Assuming pm or military time.
			prevBedTime := RegExReplace(prevBedTimeString,"[^0-9]","")

			If(StrLen(prevBedTime) > 4 or StrLen(prevBedTime) < 3){
				msgbox, Error, too few/many numbers
				ExitApp
			}
			bedHr := SubStr(prevBedTime, 1, StrLen(prevBedTime) - 2)
			bedMin := SubStr(prevBedTime, -1, 2)
			if(bedHr < 12){
				bedHr += 12
			}
			totalMin := (24-bedHr)*60 - bedMin + 30
		}
		Else {
			totalMin := oldMinutes
		}

		If(totalMin > 1){
			totalMin--
			FileDelete, TF2Timer.txt
			FileAppend, %A_DD%%totalMin%, TF2Timer.txt
		}
		Else{    ;if tf2 is not active
			Process, Close, hl2.exe
			FileDelete, TF2Timer.txt
			FileAppend, %A_DD%%totalMin%, TF2Timer.txt
			msgbox, That's all for today!
		}
	sleep 60000
}
}
