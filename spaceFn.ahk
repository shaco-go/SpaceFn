confFilePath := "./conf.ini"
conf := getConf()

; 获取需要映射的vk键和监控键
vkKey := map()
optKey := "{Space}"
for k,v in conf["KEY"] {
    optKey := optKey "{" k "}"
    vkKey[GetKeyVK(k)] := v
}

;SpaceFn
Space::
{
    global startTime := A_TickCount
    global releaseKey := []
    SetKeyDelay -1
    ; 如果到了延时时间,还有未释放的按键那么当作fn层释放
    SetTimer(timeoutReleaseKey,-conf["DEFAULT"]["press_time"])
    hook := InputHook("V L0")
    hook.OnKeyUp := OnKeyUp
    hook.OnKeyDown := OnKeyDown
    hook.KeyOpt(optKey, "N S")
    hook.Start()

    OnKeyUp(ih, vk, sc){
        global StartTime
        global releaseVK := []
        diffTime := A_TickCount - StartTime
        if (GetKeyVK("Space") == vk) {
            if (diffTime <= conf["DEFAULT"]["press_time"]) {
                Hotkey "Space", "OFF"
                ; 如果有未释放的键,按照普通层去按下
                prefixKey := ""
                if (releaseKey.length > 0) {
                    for k,v in releaseKey {
                        prefixKey := prefixKey "{" GetKeyName(Format("vk{:x}sc{:x}", v["vk"], v["sc"])) "}"
                    }
                }
                Send modifierPress(prefixKey "{Space}")
                ; 清空releaseKey
                releaseKey := []
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
        ; space键不执行
        if (GetKeyVK("Space") == vk) {
            return
        }
        ; 未超时,记录未释放的键
        if (diffTime <= conf["DEFAULT"]["press_time"]) {
            releaseKey.Push(map("vk",vk,"sc",sc))
            return
        }
        ; 进入长按按键了,可以释放
        timeoutReleaseKey()
        ; 如果有映射键,那么按下
        if (vkKey.Has(vk)) {
            modifierPress(vkKey[vk])
        }
    }

    timeoutReleaseKey(){
        global releaseKey
        if (releaseKey.length > 0) {
            for k,v in releaseKey {
                if (vkKey.Has(v["vk"])) {
                    modifierPress(vkKey[v["vk"]])
                }
            }
        }
        releaseKey := []
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
    Send "{Blind}" modifier key
}

; 获取配置文件
getConf(){
    defaultConf := GetDEFAULTConf()
    try{
        conf := FileRead(A_WorkingDir confFilePath)
        ; 获取配置成功,覆盖默认配置
        data := map()
        data["DEFAULT"] := iniRead confFilePath "DEFAULT" "press_time" defaultConf["DEFAULT"]["press_time"]
        key := iniRead confFilePath "KEY"
        data["KEY"] := getSectionMap(key)
        return data
    }catch{
        ; 获取配置失败,将默认的配置文件写入配置中
        for section,sectionValue in defaultConf{
            for key,value in sectionValue{
                ; 如果是[]=需要转义
                value := RegExReplace(value, "=", "\=")
                value := RegExReplace(value, "\[", "\[")
                value := RegExReplace(value, "\]", "\]")
                key := RegExReplace(key, "=", "\=")
                key := RegExReplace(key, "\[", "\[")
                key := RegExReplace(key, "\]", "\]")
                IniWrite value, confFilePath , section, key
            }
        }
        return defaultConf
    }
}

; 获取默认配置文件
GetDEFAULTConf(){
    ; 按下时长
    pressTime := 150
    ; 键盘的映射关系
    keyMap := map()
    keyMap["h"] := "{Left}"
    keyMap["j"] := "{Down}"
    keyMap["k"] := "{Up}"
    keyMap["l"] := "{Right}"
    keyMap["u"] := "{Home}"
    keyMap["i"] := "{End}"
    keyMap["["] := "{PgUp}"
    keyMap["]"] := "{PgDn}"
    keyMap["Enter"] := "{End}{Enter}"
    keyMap["Ins"] := "{i}"
    keyMap["Del"] := "{Ins}"
    keyMap["``"] := "{Esc}"
    keyMap["1"] := "{F1}"
    keyMap["2"] := "{F2}"
    keyMap["3"] := "{F3}"
    keyMap["4"] := "{F4}"
    keyMap["5"] := "{F5}"
    keyMap["6"] := "{F6}"
    keyMap["7"] := "{F7}"
    keyMap["8"] := "{F8}"
    keyMap["9"] := "{F9}"
    keyMap["0"] := "{F10}"
    keyMap["-"] := "{F11}"
    keyMap["="] := "{F12}"
    return map("DEFAULT",map("press_time",pressTime),"KEY",keyMap)
}

; 获取区域的配置文件,返回对应的map类型
getSectionMap(conf){
    section := []
    pos := 1 ; 起始匹配位置
    while (RegExMatch(conf,"([^\n]+)",&subSection,pos)!=0)
    {
        pos := pos + subSection.Len + 1
        section.push(subSection[1])
    }
    data := map()
    for k,v in section{
        ; 获取key和value,在去掉两边的空格
        rest := RegExMatch(v,"((?:[^=]|(?<=\\)=)+)=((?:[^=]|(?<=\\)=)+)",&subPat)
        if(rest){
            data[trim(subPat[1])] := trim(subPat[2])
        }
    }
    return data
}

; 去除两边的空格,然后去除转移的字符\= \[ \]
trim(str){
    str := RegExReplace(str, "^\s+|\s+$", "")
    str := RegExReplace(str, "\\\=", "=")
    str := RegExReplace(str, "\\\[", "[")
    str := RegExReplace(str, "\\\]", "]")
    return str
}
