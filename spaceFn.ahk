Persistent
Space::
{
    global startTime := A_TickCount
    hook := InputHook("V L0")
    hook.OnKeyUp := OnKeyUp
    hook.OnKeyDown := OnKeyDown
    hook.KeyOpt("{Space}sduiojklh;:", "N S")
    hook.Start()

    OnKeyUp(ih, vk, sc)
    {
        global StartTime
        ElapsedTime := A_TickCount - StartTime
        if (GetKeyVK("Space") == vk) {
            if (ElapsedTime <= 150) {
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
    }

    OnKeyDown(ih, vk, sc)
    {
        ;Up
        if (GetKeyVK("i") == vk) {
            if (GetKeyState("d","P")) {
                Send "+{Up}{Del}"
            }else{
                Send "{Up}"
            }
        }
        ;Down
        if (GetKeyVK("k") == vk) {
             if (GetKeyState("d","P")) {
                  Send "+{Down}{Del}"
            }else{
                Send "{Down}"
            }
        }
        ;Left
        if (GetKeyVK("j") == vk) {
             if (GetKeyState("d","P")) {
                Send "+{Left}{Del}"
            }else{
                Send "{Left}"
            }
        }
        ;Right
        if (GetKeyVK("l") == vk) {
             if (GetKeyState("d","P")) {
                Send "+{Right}{Del}"
            }else{
                Send "{Right}"
            }
        }
        ;Home
        if (GetKeyVK("u") == vk) {
             if (GetKeyState("d","P")) {
                Send "+{Home}{Del}"
            }else{
                Send "{Home}"
            }
        }
        ;End
        if (GetKeyVK("o") == vk) {
             if (GetKeyState("d","P")) {
                Send "+{End}{Del}"
            }else{
                Send "{End}"
            }
        }
        ;Left word
        if (GetKeyVK("h") == vk) {
             if (GetKeyState("d","P")) {
                Send "^+{Left}{Del}"
            }else{
                Send "^{Left}"
            }
        }
        ;Right word
        if (GetKeyVK(":") == vk || GetKeyVK(";") == vk) {
             if (GetKeyState("d","P")) {
                Send "^+{Right}{Del}"
            }else{
                Send "^{Right}"
            }
        }
        ; 选中
        if (GetKeyVK("s") == vk && !GetKeyState("d","P")) {
            Send "{LShift Down}"
        }
    }
}

Tab & Left::
{
    Send "{Home}"
}
Tab & Right::
{
    Send "{End}"
}
Tab & Up::
{
    Send "{PgUp}"
}
Tab & Down::
{
    Send "{PgDn}"
}
