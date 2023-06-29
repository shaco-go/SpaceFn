;SpaceFn
#inputlevel,2
$Space::
    SetMouseDelay -1
    Send {Blind}{F24 DownR}
    KeyWait, Space
    Send {Blind}{F24 up}
    if(A_ThisHotkey="$Space" and A_TimeSinceThisHotkey<300){
		Send {Blind}{Space DownR}
	}
    return

#inputlevel,1
F24 & v::
	Send,^+!v
	reloadSpace()
return
F24 & k::
	Send,{Up}
	reloadSpace()
return
F24 & j::
	Send,{Down}
	reloadSpace()
return
F24 & h::
	Send,{Left}
	reloadSpace()
return
F24 & l::
	Send,{Right}
	reloadSpace()
return
F24 & u::
	Send,{Home}
	reloadSpace()
return
F24 & i::
	Send,{End}
	reloadSpace()
return




reloadSpace()
{
    if (!GetKeyState("Space", "P"))
    {
        Send {Blind}{Space DownR}
    }
}


