;spaceFn键长按延时时间
fnDelayed := 150
;SpaceFn
Space::
{
    SetKeyDelay -1
    global startTime := A_TickCount
;    global modifierKey := map("t",false,"s",false,"w",false,"d",false)
    global releaseKey := ""
    hook := InputHook("V L0")
    hook.OnKeyUp := OnKeyUp
    hook.OnKeyDown := OnKeyDown
    hook.KeyOpt("{Space}{h}{j}{k}{l}{u}{i}{Enter}{1}{2}{3}{4}{5}{6}{7}{8}{9}{0}{-}{=}{BS}{``}{[}{]}", "N S")
    hook.Start()

    OnKeyUp(ih, vk, sc){
        global StartTime
        global releaseKey
        diffTime := A_TickCount - StartTime
        if (GetKeyVK("Space") == vk) {
            if (diffTime <= fnDelayed) {
                Hotkey "Space", "OFF"
                Send modifierPress(releaseKey "{Space}")
                Hotkey "Space", "ON"
            }
            ih.Stop()
            return
        }
    }

    OnKeyDown(ih, vk, sc){
        global StartTime
        global releaseKey
        diffTime := A_TickCount - StartTime
        ; space按键不往下执行,或未检测到奥长按
        if (GetKeyVK("Space") == vk) {
            return
        }
        ; 未超时记录
        if (diffTime <= fnDelayed) {
            releaseKey := "{" GetKeyName(Format("vk{:x}sc{:x}", VK, SC)) "}" releaseKey
            return
        }
;        ;检查模式是否开始
;        global modifierKey
;        for k,v in modifierKey {
;            if (GetKeyVK(k) == vk) {
;                modifierKey[k] := !v
;            }
;        }
        key := map("h","{Left}","j","{Down}","k","{Up}","l","{Right}","u","{Home}","i","{End}","[","{PgUp}","]","{PgDn}")
;        toggleKey := map("h","{Home}","j","{PgDn}","k","{PgUp}","l","{End}")
        appendKey := map("Enter","{End}{Enter}","Ins","{i}","BS","{Del}","``","{Esc}")
        fKey := ["1","2","3","4","5","6","7","8","9","0","-","="]
;        ;开启切换模式
;        if (modifierKey["t"]) {
;            key := toggleKey
;        }
;        ;选中修饰符
;        if (modifierKey["s"]) {
;            for k,v in key {
;                key[k] := "+" v
;            }
;        }
;        ;ctrl修饰符
;        if (modifierKey["w"]) {
;            for k,v in key {
;                key[k] := "^" v
;            }
;        }
;        ;删除修饰符
;        if (modifierKey["d"]) {
;            for k,v in key {
;                key[k] := "+" v "{Del}"
;            }
;        }
        ;追加的不包含修饰符
        for k,v in appendKey {
            key[k] := v
        }
        ;数字键盘区
        for k,v in fKey {
            key[v] := "{F" k "}"
        }
        for k,v in key {
            if (GetKeyVK(k) == vk) {
                modifierPress(v)
            }
        }
    }
}



; 支持修饰符的按下按键
modifierPress(key){
    modifierKey := map("Ctrl","^","Shift","+","Alt","!","LWin","#","RWin","#")
    modifier := ""
    for k,v in modifierKey {
        if GetKeyState(k,"P"){
            modifier := v modifier
        }
    }
    Send modifier key
}
