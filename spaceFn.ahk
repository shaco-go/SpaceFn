Persistent
Space::
{
    global startTime := A_TickCount
    hook := InputHook("V L0")
    hook.OnKeyUp := OnKeyUp
    hook.OnKeyDown := OnKeyDown
    hook.KeyOpt("{Space}asdfhjkl", "N S")
    hook.Start()

    OnKeyUp(ih, vk, sc)
    {
        global StartTime
        diffTime := A_TickCount - StartTime
        if (GetKeyVK("Space") == vk) {
            if (diffTime <= 150) {
                Hotkey "Space", "OFF"
                Send "{Space}"
                Hotkey "Space", "ON"
            }
            if (GetKeyState("s","P")) {
                Send "{LShift Up}"
            }
            ih.Stop()
        }
        if (GetKeyVK("s") == vk) {
            Send "{LShift Up}"
        }
		if (GetKeyVK("a") == vk) {
            Send "{LCtrl Up}"
        }
    }

    OnKeyDown(ih, vk, sc)
    {

		if (GetKeyState("f","P")) {
			;如果开启F键,代表Home PgD PgUp End(hjkl)
			if (GetKeyVK("h") == vk) {
				if (GetKeyState("d","P")) {
				    Send "+{Home}{Del}"
				}else{
				    Send "{Home}"
				}
			}
			if (GetKeyVK("j") == vk) {
				 if (GetKeyState("d","P")) {
				    Send "+{PgDn}{Del}"
				 }else{
				    Send "{PgDn}"
				 }
			}
			if (GetKeyVK("k") == vk) {
				 if (GetKeyState("d","P")) {
				    Send "+{PgUp}{Del}"
				 }else{
				    Send "{PgUp}"
				 }
			}
			if (GetKeyVK("l") == vk) {
				 if (GetKeyState("d","P")) {
				    Send "+{End}{Del}"
				 }else{
				    Send "{End}"
				 }
			}
		} else {
			;如果没有开启F键,代表左下上右(hjkl)
			if (GetKeyVK("h") == vk) {
				if (GetKeyState("d","P")) {
				    Send "+{Left}{Del}"
				}else{
				    Send "{Left}"
				}
			}
			if (GetKeyVK("j") == vk) {
				 if (GetKeyState("d","P")) {
				    Send "+{Down}{Del}"
				 }else{
				    Send "{Down}"
				 }
			}
			if (GetKeyVK("k") == vk) {
				 if (GetKeyState("d","P")) {
				    Send "+{Up}{Del}"
				 }else{
				    Send "{Up}"
				 }
			}
			if (GetKeyVK("l") == vk) {
				 if (GetKeyState("d","P")) {
				    Send "+{Right}{Del}"
				 }else{
				    Send "{Right}"
				 }
			}
		}

        ;按下Shift键,和删除互斥
        if (GetKeyVK("s") == vk && !GetKeyState("d","P")) {
            Send "{LShift Down}"
        }
		 ;按下Ctrl键,和删除互斥
        if (GetKeyVK("a") == vk) {
            Send "{LCtrl Down}"
        }
    }
}
