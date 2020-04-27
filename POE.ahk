#Persistent
#SingleInstance force
#InstallKeybdHook    ;安装键盘钩子，主要用来判断键盘是否处于按下状态，如果是就一直发送键盘消息！如果报毒的话就是这里报毒，加密下这一句代码就OK了
#MaxHotkeysPerInterval 240
#MaxThreadsPerHotkey 1
Process, Priority, , high
SetKeyDelay, 0, 3
SetStoreCapslockMode, off
mousestate:=0
playstate:=0
autoPotion:=1
autoEstate:=0
autoWstate:=0
autoTstate:=0
autoSstate:=0
autoAstate:=0
#Include D:\Program Files\AutoHotkey\script\POELib\autoMacroLib.ahk


~^P::Pause
~^O::ExitApp

!^Q::
{
	mousestate := 1 - mousestate
	if (mousestate=1){
		TrayTip, ,鼠标连点模式开启
	}
	else{
		TrayTip, ,鼠标连点模式关闭
	}
}
Return

!^T::
{
	autoTstate := 1 - autoTstate
	if (autoTstate=1){
	}
	else{
	}
}
Return

!^S::
{
	autoSstate := 1 - autoSstate
	if (autoSstate=1){
	}
	else{
	}
}
Return

!^W::
{
	autoWstate := 1 - autoWstate
	if (autoWstate=1){
	}
	else{
	}
}
Return

!^E::
{
	autoEstate := 1 - autoEstate
	if (autoEstate=1){
	}
	else{
	}
}
Return

!^P::
{
	autoPotion := 1 - autoPotion
	if (autoPotion=1){
	}
	else{
	}
}
Return

F4::
{
	autoAstate := 1- autoAstate
	if (autoAstate = 1)
	{
		;MsgBox a
		Send {a down}
	}
	else
	{
		Send {a up}
	}
}
Return

#If (autoPotion=1) and WinActive("Path of Exile")
LWin::return
~2::
{
	Send {3}
	Send {4}	
	Send {5}
	Send {S}
}
Return

#If (mousestate=1) and WinActive("Path of Exile")

*$LButton::
{
	Loop
	{
		Click Down Left
		Loop
		{
			Sleep,10
			GetKeyState,Cstate,Ctrl,P
			if Cstate = D
			{
				Click Left
			}
			GetKeyState,Lstate,LButton,P
			if Lstate = U
			{
				Click Up Left
				Break
			}
		}
		Return
	}
	Return
}
Return

!^Y::
{
	cc_w := false
	cc_e := false
	while(mousestate=1)
	{
		Sleep,500
		if WinActive("Path of Exile")
		{
			if(autoEstate=1)
			{
				cc_w := CheckColor(1493,1030,0xD1F13F)	;plague bearer check
				cc_e := CheckColor(1544,1036,0x171C02)	;withering step check
			}
			while(cc_e)
			{
				Send {e down}
				Sleep,20
				Send {e up}
				Sleep,50
				cc_e := CheckColor(1544,1036,0x171C02)
			}
			while(cc_w)
			{
				Send {w down}
				Sleep,20
				Send {w up}
				Sleep,50
				cc_w := CheckColor(1493,1030,0xD1F13F)
			}
			if(autoTstate=1)
			{
				Send {t down}
				Sleep,20
				Send {t up}
				Sleep,50
			}
			if(autoSstate=1)
			{
				Send {s down}
				Sleep,20
				Send {s up}
				Sleep,50
			}
		}
	}
}
Return

*$z::
{
	Send {z}
	Sleep,200
	Send {d}
}
Return