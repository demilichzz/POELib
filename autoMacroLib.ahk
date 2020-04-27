*^P::Pause
*^O::ExitApp

^Left::
{
	MouseMove,-1,0,50,R
}
Return
^Right::
{
	MouseMove,1,0,50,R
}
Return
^Up::
{
	MouseMove,0,-1,50,R
}
Return
^Down::
{
	MouseMove,0,1,50,R
}
Return

x:=0
y:=0

!Numpad1::
{
	MouseGetPos, x, y
	PixelGetColor, color, %x%, %y%, RGB
	Clipboard = %x%,%y%,%color%
	Msgbox %x%,%y%,%color%
}
Return

!Numpad2::
{
	x:=928
	y:=19
	PixelGetColor, color, %x%, %y%, RGB
	Clipboard = %x%,%y%,%color%
	Msgbox %x%,%y%,%color%
}
Return

!Numpad3::
{
	MouseGetPos, x, y
	PixelGetColor, color, %x%, %y%, RGB
	if (checkColorRGB(x,y,0x101010))
	{
		MsgBox %x%,%y%,%color%,<
	}
	else
	{
		MsgBox %x%,%y%,%color%,>
	}
}
Return

~!Numpad4::
{
	id := WinExist("A")
	MsgBox % id
}
Return

~!Numpad7::
{
	x:=1559
	y:=614
	x_diff := -961
	y_diff := -69
	c1 := CheckColorRGB(x,y,0x101010)
	c2 := CheckColorRGB(x+x_diff,y+y_diff,0x101010)
	Msgbox %c1%,%c2%
}
Return
~!Numpad8::
{
	pagelist := Object()
	pagelist.push([94,138,0x5579AC])
	pagelist.push([167,138,0x5579AC])
	pagelist.push([233,138,0x5579AC])
	pagelist.push([288,141,0x5F89BF])
	pagelist.push([349,142,0x587DB2])
	pagelist.push([409,141,0x5980B4])
	pagelist.push([473,141,0x577DB1])
	pagelist.push([530,144,0x5B80B8])
	textlist := Object()
	Loop 8
	{
		x := % pagelist[A_Index][1]
		y := % pagelist[A_Index][2]
		PixelGetColor, color, %x%, %y%, RGB
		text := "page_list.push([" . x . "," . y . "," . color . "])"
		textlist.push(text)
	}
	Clipboard := textlist[1] . textlist[2] . textlist[3] . textlist[4] . textlist[5] . textlist[6] . textlist[7] . textlist[8]
}
Return

CheckColor(x,y,cc)
{
	PixelGetColor,color,x,y,RGB
	;Msgbox %cc%,%color%
	;text = %x%,%y%,%cc%,color:%color%
	;TrayTip, , %text%
	if (color = cc)
	{
		return true
	}
	else
	{
		return false
	}
}

CheckColorRGB(x,y,cc)
{
	PixelGetColor,color,x,y,RGB
	;text = %x%,%y%,%cc%,color:%color%
	;MsgBox %text%
	R := color>>16
	G := (color>>8) - (R<<8)
	B := color- (R<<16) - (G<<8)
	ccR := cc>>16
	ccG := (cc>>8) - (ccR<<8)
	ccB := cc - (ccR<<16) - (ccG<<8)
	if (R <= ccR and G <= ccG and B <= ccB and R >= (ccR-0x10) and G >= (ccG-0x10) and B >= (ccB-0x10))
	{
		return true
	}
	else
	{
		return false
	}
}

ColorClick(x,y,xtar,ytar,cc,mode,clickdelay)
{
	flg := false
	while (flg = false)
	{
		PixelGetColor,color,xtar,ytar,RGB
		;Msgbox %cc%,%color%
		;text = %x%,%y%,%xtar%,%ytar%,%cc%,color:%color%
		;TrayTip, , %text%
		if ((color = cc and mode = true) or (color <> cc and mode = false))
		{
			flg := true
		    Sleep,100
		}
		else
		{
			CommonClick(x,y)
			Sleep,clickdelay
		}
	}	
}

ColorClickRight(x,y,xtar,ytar,cc,mode,clickdelay)
{
	flg := false
	while (flg = false)
	{
		PixelGetColor,color,xtar,ytar,RGB
		;Msgbox %cc%,%color%
		;text = %x%,%y%,%xtar%,%ytar%,%cc%,color:%color%
		;TrayTip, , %text%
		if ((color = cc and mode = true) or (color <> cc and mode = false))
		{
			flg := true
		    Sleep,100
		}
		else
		{
			CommonClickRight(x,y)
			Sleep,clickdelay
		}
	}	
}

ColorClickDiff(x,y,xtar,ytar,cc,mode,clickdelay)
{
	flg := false
	while (flg = false)
	{
		res := CheckColorRGB(xtar,ytar,cc)
		;TrayTip, , %text%
		if ((res = true and mode = true) or (res = false and mode = false))
		{
			flg := true
		    Sleep,100
		}
		else
		{
			CommonClick(x,y)
			Sleep,clickdelay
		}
	}
}

WaitFor(x,y,cc,mode)
{
	flg := false
	while (flg = false)
	{
		PixelGetColor,color,x,y,RGB
		;Msgbox %cc%,%color%
		if ((color = cc and mode = true) or (color <> cc and mode = false))
		{
			flg := true
		    Sleep,1000
		}
		else
		{
			Sleep,1000
		}
	}	
}

CommonClick(x,y)
{
	MouseMove x,y
	Sleep,10
	Click Down Left
	Sleep,10
	Click Up Left
	Sleep,10
}

CommonClickRight(x,y)
{
	MouseMove x,y
	Sleep,10
	Click Down Right
	Sleep,10
	Click Up Right
	Sleep,10
}