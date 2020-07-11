#Persistent
#SingleInstance force
#InstallKeybdHook    ;安装键盘钩子，主要用来判断键盘是否处于按下状态，如果是就一直发送键盘消息！如果报毒的话就是这里报毒，加密下这一句代码就OK?
#MaxHotkeysPerInterval 240
#MaxThreadsPerHotkey 3
Process, Priority, , high
SetKeyDelay, 0, 3
SetStoreCapslockMode, off
autoShutDown:=0
rare_identify_flg := 1
useUnidRecipe := 1
autoVendorTrashWhileSort := 0
autoVendorRareWhileSort := 0
#Include D:\Program Files\AutoHotkey\script\POELib\autoMacroLib.ahk
#Include D:\Program Files\AutoHotkey\script\POELib\POELib.ahk

~^Numpad1::		;auto vendor chaos recipe
{
	POEConstantLib_constantDefine()
	x_center:=960
	y_center:=520
	map_close_x := 630
	map_close_y := 68
	map_close_cc := 0x030507
	quarry_cnt:=0
	while(quarry_cnt<50000)
	{
		autoQuarry()
		quarry_cnt:=quarry_cnt+1
		if(mod(quarry_cnt,20)=19)
		{
			checkSeedFull()
		}
	}
	;run shutdown -s -t 30
}
Return

~^Numpad2::
{
	POEConstantLib_constantDefine()
	;test:=Sin(0)
	;MsgBox %test%
	x_center:=960
	y_center:=520
	;waypoint_obj := getWaypointPos(0)
	;getHarvestPos(960,520)
	;getSeedCachePos()
	;pickupItem()
	x:= waypoint_obj["x"]
	y:=waypoint_obj["y"]
	dist:=waypoint_obj["dist"]
	angle:=waypoint_obj["angle"]
	predict:=waypoint_obj["predict"]
	x_harvest:= harvest_obj["x"]
	y_harvest:=harvest_obj["y"]
	dist_harvest:=harvest_obj["dist"]
	angle_harvest:=harvest_obj["angle"]
	;MsgBox phase:%phase%`npredict:%predict%`nx:%x%`ny;%y%`ndist:%dist%`nangle:%angle%`nx_harvest:%x_harvest%`ny_harvest;%y_harvest%`ndist_harvest:%dist_harvest%`nangle_harvest:%angle_harvest%`n
	checkSeedFull()
}
Return

~^Numpad3::
{
	x:=1918
	y:=900
	x_dist := x - 960	958
	y_dist := y - 520	380
	dist := sqrt(x_dist*x_dist+y_dist*y_dist)
	if(dist=0)
	{
		dist:=1
	}
	x_dir := x_dist / dist
	y_dir := y_dist / dist
	y_check:=1
	if(y_dir<0)
	{
		y_check:=-1
	}
	angle := 180-(180-ACos(x_dir)/3.1415926*180)*y_check
	MsgBox x:%x%`ny;%y%`ndist:%dist%`nangle:%angle%
}

autoQuarry()
{
	global
	dist_after:=999999
	turn_count:=0
	seed_click_count:=0
	waypoint_obj := getWaypointPos(0)
	harvest_obj := getHarvestPos(0)
	charMoveByDir(0,1,150,false,false)
	phase := 1
	harvest_loop:=0
	harvestFoundFlag:=false
	;TrayTip, , Phase 1
	loop_cnt:=0
	while(phase>-1)
	{
		loop_cnt:=loop_cnt+1
		if(loop_cnt>150)
		{
			phase:=-2
			errorHandle()
			Sleep,1000
			Break
		}
		waypoint_obj := getWaypointPos(waypoint_obj)
		harvest_obj := getHarvestPos(harvest_obj)
		if(waypoint_obj["predict"]>0)
		{
			charMoveByDir(waypoint_obj["x_dir"],waypoint_obj["y_dir"],400,true,true)
		}
		else
		{
			if(phase>1 and harvest_obj["dist"]>0)
			{
				phase:=0
			}
			if(phase=1)
			{
				if(waypoint_obj["dist"]<250)
				{
					charMoveByDir(0,1,300,true,true)
				}
				else
				{
					;TrayTip, , Phase 2
					phase:=2
				}
			}
			if(phase=2)
			{
				if(waypoint_obj["dist"]<400)
				{
					charMoveByDir(-1,0,300,true,true)
				}
				else
				{
					;TrayTip, , Phase 3
					phase:=3
				}
			}
			if(phase=3)
			{
				if(waypoint_obj["angle"]>270)
				{
					charMoveByDir(-0.7,-0.7,400,true,true)
				}
				else
				{
					;TrayTip, , Phase 4
					phase:=4
				}
			}
			if(phase=4)
			{
				if(waypoint_obj["angle"]>=0 and waypoint_obj["angle"]<45)
				{
					charMoveByDir(0.7,-0.3,400,true,true)
				}
				else
				{
					phase:=5
				}
			}
			if(phase=5)
			{
				if(waypoint_obj["angle"]>=45 and waypoint_obj["angle"]<110)
				{
					charMoveByDir(1,0,400,true,true)
				}
				else
				{
					phase:=6
				}
			}
			if(phase=6)
			{
				if(waypoint_obj["angle"]>=100 and waypoint_obj["angle"]<150)
				{
					charMoveByDir(0.7,0.7,400,true,true)
				}
				else
				{
					phase:=-1
				}
			}
			if(phase=0)	;go to harvest
			{
				;harvest_obj := getHarvestPos(960,540)
				if(harvest_obj["dist"]>100)
				{
					charMoveByDir(harvest_obj["x_dir"],harvest_obj["y_dir"],160,true,true)
				}
				else if(harvest_obj["dist"]>0)
				{
					charMoveByDir(harvest_obj["x_dir"],harvest_obj["y_dir"],100,false,false)
				}
				local seedObj := getSeedCachePos()
				if(seedObj["x"]>=0)
				{
					CommonClick(seedObj["x"],seedObj["y"])
					Sleep,1000
					seed_click_count:=seed_click_count+1
				}
				if(seed_click_count>=3)
				{
					seed_click_count:=0
					MouseMove seedObj["x"],seedObj["y"]
					Send, {z}
					Sleep 500
				}
				local ifSeedOpened := checkItem()
				if(ifSeedOpened<3)
				{
					pickUpItem()
					phase:=-1
				}
				else
				{
					harvest_loop := harvest_loop+1
					if(harvest_loop>50)
					{
						phase:=-1
						harvest_loop:=0
					}
				}
			}	
		}
	}
	loop_cnt:=0
	while(phase=-1 and CheckColor(map_close_x,map_close_y,map_close_cc)=false)
	{
		loop_cnt:=loop_cnt+1
		if(loop_cnt>120)
		{
			phase:=-2
			errorHandle()
			Sleep,1000
			Break
		}
		waypoint_obj := getWaypointPos(waypoint_obj)
		if(waypoint_obj["dist"]>100)
		{
			charMoveByDir(waypoint_obj["x_dir"],waypoint_obj["y_dir"],300,true,true)
		}
		else
		{
			charMoveByDir(waypoint_obj["x_dir"],waypoint_obj["y_dir"],150,false,false)
		}
		Sleep,200
	}
	enterNewMap()
}

checkSeedFull()
{
	global
	while(CheckColor(1342,77,0xCBA069)=false)
	{
		Send,{i}
		Sleep,1000
		if(A_Index>15)
		{
			return
		}
	}
	if(not CheckEmptyByAxis(1822,615))
	{
		reloginToHideout()
		moveToStash()
		storeSeeds()
		moveToWP()
		enterNewMap()
		return
	}
	while(CheckColor(1342,77,0xCBA069)=true)
	{
		Send,{i}
		Sleep,1000
		if(A_Index>15)
		{
			return
		}
	}
}

errorHandle()
{
	global
	reloginToHideout()
	ColorClick(949,463,329,57,0xDBBA7E,true,1000)
}

moveToStash()
{
	global
	CommonClick(1343,940)
	Sleep,4000
	openStash()
}

storeSeeds()
{
	global
	local inv_store := itemType_Temp
	local store_result:=CheckInvIsEmpty(0,inv_store)
	while(store_result=-1)
	{
		inv_store:=inv_store+1
		store_result:=CheckInvIsEmpty(0,inv_store)
	}
}

moveToWP()
{
	global
	CommonClick(724,199)
	Sleep,4000
}

reloginToHideout()
{
	cc := CheckColor(847,472,0xFEC076)
	while(cc<>true)
	{
		Send,{Esc}
		Sleep,1000
		cc := CheckColor(847,472,0xFEC076)
	}
	ColorClick(847,472,1783,659,0xFEC076,true,500)
	ColorClick(1783,659,1783,659,0xFEC076,false,500)
	WaitFor(266,1004,0x090801,true)
	Sleep,1000
	Send,{Enter}/hideout{Enter}
	Sleep,5000
	WaitFor(266,1004,0x090801,true)
	Send,{Tab}
}

enterNewMap()
{
	Send,{Ctrl Down}
	Sleep,10
	ColorClick(310,120,310,120,0xFEC076,true,500)
	ColorClick(391,156,391,156,0xFEC076,true,500)
	ColorClick(284,280,460,335,0xEAB06B,true,500)
	ColorClick(460,335,460,335,0xEAB06B,false,500)
	Send,{Ctrl Up}
	Sleep,2000
	WaitFor(266,1004,0x090801,true)
	Sleep,500
}

getWaypointPos(wp_last)
{
	global
	local obj := Object()
	local search_dist := 200
	local find_flg := 0
	obj["predict"]:=0
	if(wp_last["x"]<=0 and wp_last["y"]<=0)
	{
		Px_last := 960
		Py_last := 520
	}
	else
	{
		Px_last := wp_last["x"]
		Py_last := wp_last["y"]
	}
	if(Px_last-220-400>0)
	{
		ltx := Px_last-220-400
	}
	else
	{
		ltx := 0
	}
	if(Py_last-80-300>0)
	{
		lty := Py_last-80-300
	}
	else
	{
		lty := 0
	}
	if(Px_last-220+400<1920)
	{
		rbx := Px_last-220+400
	}
	else
	{
		rbx := 1920
	}
	if(Py_last-80+300<1080)
	{
		rby := Py_last-80+300
	}
	else
	{
		rby := 1080
	}
	;MsgBox %ltx%`n%lty%`n%rbx%`n%rby%
	ImageSearch, Px, Py, ltx,lty,rbx,rby, *16 D:\Program Files\AutoHotkey\script\POELib\Pic\entrance.png
	if(ErrorLevel>0)
	{
		if(wp_last["x"]>0 and wp_last["y"]>0)
		{
			;MsgBox SSS
			obj["x"]:=wp_last["x"]
			obj["y"]:=wp_last["y"]
			obj["predict"]:=1
		}
		else
		{
			return obj
		}
	}
	else
	{
		;MouseMove,Px,Py
		Px:=Px+220
		Py:=Py+80
		;MsgBox, waypoint was found at X%Px% Y%Py%.
		obj["x"] := Px
		obj["y"] := Py
	}
	local x_dist := obj["x"] - x_center
	local y_dist := obj["y"] - y_center
	local dist := sqrt(x_dist*x_dist+y_dist*y_dist)
	if(dist=0)
	{
		dist:=1
	}
	obj["dist"] := dist
	local x_dir := x_dist / dist
	local y_dir := y_dist / dist
	obj["x_dir"] := x_dir
	obj["y_dir"] := y_dir
	local y_check:=1
	if(y_dir<0)
	{
		y_check:=-1
	}
	obj["angle"] := 180-(180-ACos(x_dir)/3.1415926*180)*y_check
	return obj
}

getHarvestPos(hv_last)
{
	global
	local obj := Object()
	local search_dist := 400
	local find_flg := 0
	while(find_flg=0)
	{
		if(harvestFoundFlag=true)
		{
			find_flg:=1
			waypoint_obj := getWaypointPos(waypoint_obj)
			obj["x"] := waypoint_obj["x"] + harvest_obj["x_diff"]
			obj["y"] := waypoint_obj["y"] + harvest_obj["y_diff"]
			obj["x_diff"]:= harvest_obj["x_diff"]
			obj["y_diff"]:= harvest_obj["y_diff"]
		}
		else
		{
			PixelSearch, Px, Py, 220,90,1650,800, 0xC5FFFF, 16, Fast RGB
			if(ErrorLevel>0)
			{
				;search_dist := search_dist + 100
				;if(search_dist > 500)
				;{
					return obj
				;}
			}
			else
			{
				PixelSearch, Px1, Py1, Px-50, Py-50, Px+50, Py+50, 0x1B1A2C, 20, Fast RGB
				PixelSearch, Px2, Py2, Px-50, Py-50, Px+50, Py+50, 0x68B4FF, 20, Fast RGB
				if(Px1>0 and Py1>0 and Px2>0 and Py2>0)
				{
					if(Px > waypoint_obj["x"]-540 and Px < waypoint_obj["x"]+100 and Py > waypoint_obj["y"] - 260 and Py < waypoint_obj["y"]+100)
					{
						return obj
					}
					else if(harvestFoundFlag=false and Px>940-150 and Px<940+150 and Py>460-100 and Py<460+100)
					{
						return obj
					}
					else
					{
						harvestFoundFlag:=true
						find_flg:=1
						;TrayTip, , harvest was found at X%Px% Y%Py%.
						obj["x"] := Px
						obj["y"] := Py
						waypoint_obj := getWaypointPos(waypoint_obj)
						obj["x_diff"]:= obj["x"] - waypoint_obj["x"]
						obj["y_diff"]:= obj["y"] - waypoint_obj["y"]
					}
				}
				else
				{
					return obj
				}
			}
		}
		local x_dist := obj["x"] - x_center
		local y_dist := obj["y"] - y_center
		local dist := sqrt(x_dist*x_dist+y_dist*y_dist)
		if(dist=0)
		{
			dist:=1
		}
		obj["dist"] := dist
		local x_dir := x_dist / dist
		local y_dir := y_dist / dist
		obj["x_dir"] := x_dir
		obj["y_dir"] := y_dir	
	}
	return obj
}

getSeedCachePos()
{
	local obj := Object()
	ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 D:\Program Files\AutoHotkey\script\POELib\Pic\1.png
	if ErrorLevel = 2
	{
		;MsgBox Could not conduct the search.
	}
	else if ErrorLevel = 1
	{
		;MsgBox Icon could not be found on the screen.
	}
	else
	{
		;MsgBox The icon was found at %FoundX%x%FoundY%.
		obj["x"]:=FoundX
		obj["y"]:=FoundY
	}
	return obj
}

checkItem()
{
	global
	local finish_flg:=0
	ImageSearch, FoundX, FoundY, 960-400, 520-300, 960+400, 520+300, *16 D:\Program Files\AutoHotkey\script\POELib\Pic\seed1.png
	finish_flg:=finish_flg+ErrorLevel
	ImageSearch, FoundX, FoundY, 960-400, 520-300, 960+400, 520+300, *16 D:\Program Files\AutoHotkey\script\POELib\Pic\seed2.png
	finish_flg:=finish_flg+ErrorLevel
	ImageSearch, FoundX, FoundY, 960-400, 520-300, 960+400, 520+300, *16 D:\Program Files\AutoHotkey\script\POELib\Pic\seed3.png
	finish_flg:=finish_flg+ErrorLevel
	return finish_flg
}
pickUpItem()
{
	global
	local finish_flg:=0
	pick_cnt:=0
	while(finish_flg<3)
	{
		finish_flg:=0
		ImageSearch, FoundX, FoundY, 960-400, 520-300, 960+400, 520+300, *16 D:\Program Files\AutoHotkey\script\POELib\Pic\seed1.png
		if(ErrorLevel=0)
		{
			CommonClick(FoundX, FoundY)
		}
		finish_flg:=finish_flg+ErrorLevel
		ImageSearch, FoundX, FoundY, 960-400, 520-300, 960+400, 520+300, *16 D:\Program Files\AutoHotkey\script\POELib\Pic\seed2.png
		if(ErrorLevel=0)
		{
			CommonClick(FoundX, FoundY)
		}
		finish_flg:=finish_flg+ErrorLevel
		ImageSearch, FoundX, FoundY, 960-400, 520-300, 960+400, 520+300, *16 D:\Program Files\AutoHotkey\script\POELib\Pic\seed3.png
		if(ErrorLevel=0)
		{
			CommonClick(FoundX, FoundY)
		}
		finish_flg:=finish_flg+ErrorLevel
		pick_cnt:=pick_cnt+1
		if(pick_cnt>100)
		{
			run shutdown -s -t 30
		}
	}
}

charMoveByDir(x_dir,y_dir,dist,blink_flg,attack_flg)
{
	global
	local y_check:=1
	if(y_dir<0)
	{
		y_check:=-1
	}
	local angle := 180-(180-ACos(x_dir)/3.1415926*180)*y_check
	if(abs(dist_after-waypoint_obj["dist"])<10 and waypoint_obj["predict"]=0)
	{
		turn_count:=turn_count+1
		angle := angle + 20*turn_count
	}
	else
	{
		turn_count:=0
	}
	x_dir := Cos(angle/180*3.1415926)
	y_dir := Sin(angle/180*3.1415926)
	local x_tar := x_center + dist*x_dir
	local y_tar := y_center + dist*y_dir
	;charMoveByAxis(x_tar,y_tar,blink_flg,attack_flg)
	MouseMove x_tar,y_tar
	CommonClick(x_tar,y_tar)
	Sleep,500
	if(blink_flg)
	{
		MouseMove x_center+500*x_dir,y_center+500*y_dir
		Send {z}
		Sleep,200
	}
	if(attack_flg)
	{
		CommonClickRight(x_center+50*x_dir,y_center+50*y_dir)
		Sleep,300
	}
	dist_after:=waypoint_obj["dist"]
}
charMoveByAxis(x,y,blink_flg,attack_flg)
{
	MouseMove x,y
	CommonClick(x,y)
	Sleep,1000
	if(blink_flg)
	{
		Send {z}
		Sleep,300
	}
	if(attack_flg)
	{
		CommonClickRight(x,y)
		Sleep,500
	}
}

getColorObj(cc)
{
	colorObj := Object()
	R := cc>>16
	G := (cc>>8) - (R<<8)
	B := cc- (R<<16) - (G<<8)
	colorObj[1]:=R
	colorObj[2]:=G
	colorObj[3]:=B
}