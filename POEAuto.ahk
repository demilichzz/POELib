#Persistent
#SingleInstance force
#InstallKeybdHook    ;安装键盘钩子，主要用来判断键盘是否处于按下状态，如果是就一直发送键盘消息！如果报毒的话就是这里报毒，加密下这一句代码就OK了
#MaxHotkeysPerInterval 240
#MaxThreadsPerHotkey 3
Process, Priority, , high
SetKeyDelay, 0, 3
SetStoreCapslockMode, off
autoShutDown:=0
rare_identify_flg := 1
#Include D:\Program Files\AutoHotkey\script\POELib\autoMacroLib.ahk
#Include D:\Program Files\AutoHotkey\script\POELib\POELib.ahk

*^P::Pause
*^O::ExitApp

!^Q::
{
	autoShutDown := 1 - autoShutDown
	if (autoShutDown=1){
		TrayTip, ,自动关机开启
	}
	else{
		TrayTip, ,自动关机关闭
	}
}
Return


~^Numpad1::		;auto vendor chaos recipe
{
	POEConstantLib_constantDefine()
	array_itemAxis := Object()
	Loop 8
	{
		array_temp := [0,0]
		array_itemAxis[A_Index+itemType_Ring-1] := (array_temp)
	}
	vendor_fail_flg := 0
	while(vendor_fail_flg =0)
	{
		vendor_fail_flg := autoVendor()
	}
	if(autoShutDown=1)
	{
		run shutdown -s -t 30
	}
}
Return

~^Numpad2::		;auto sort rare equip
{
	POEConstantLib_constantDefine()
	sort_list := [4,5,6,7,8,26,27]
	for index, element in sort_list
	{
		autoSort(element)
	}
	storeScrolls()
	if(true)	;if auto shutdown mode then vendor after sort dealed
	{
		POEConstantLib_constantDefine()
		vendor_sheet_list := [itemType_TempTrashNormal] ;vendor list
		for index, element in vendor_sheet_list
		{
			autoVendorTrash(element)
		}
		
		POEConstantLib_constantDefine()
		array_itemAxis := Object()
		Loop 8
		{
			array_temp := [0,0]
			array_itemAxis[A_Index+itemType_Ring-1] := (array_temp)
		}
		vendor_fail_flg := 0
		while(vendor_fail_flg =0)
		{
			vendor_fail_flg := autoVendor()
		}
	}
	endExecute()
}
Return

~^Numpad3::		;auto identifie vendor trash tab
{
	POEConstantLib_constantDefine()
	autoIdentifie()
}
Return

~^Numpad4::		;auto vendor trash
{
	POEConstantLib_constantDefine()
	openSheet(0)
	CtrlMoveItemByGrid(0,4)
	CtrlMoveItemByGrid(1,4)	;store scrolls
	CtrlMoveItemByGrid(2,4)
	vendor_sheet_list := [itemType_TempTrashNormal] ;vendor list
	for index, element in vendor_sheet_list
	{
		autoVendorTrash(element)
	}
	endExecute()
}
Return

~^Numpad5::		;auto analyze
{
	POEConstantLib_constantDefine()
	analyze_sheet_list := [itemType_Ring,itemType_Amu,itemType_Belt,itemType_Glove,itemType_Helm,itemType_Body]	;analyze list
	autoAnalyze(analyze_sheet_list)
}
Return

~^Numpad6::
{
	POEConstantLib_constantDefine()
	Sleep,10
	clipboard =		;clear clipboard
	Send ^c
	result := analyzeItem()
	MsgBox %result%
}
Return

storeScrolls()
{
	CtrlMoveItemByGrid(0,0)
	CtrlMoveItemByGrid(0,4)
	CtrlMoveItemByGrid(1,4)
	CtrlMoveItemByGrid(2,4)
}

autoSort(sheet)		;auto sort main
{
	global
	i := 0
	j := 0
	flag:=true
	source_sheet := sheet
	openSheet(0)	;open temp item sort sheet
	storeScrolls()
	if(rare_identify_flg = 1)	;identify rare equip and analyze
	{
		CtrlMoveCurrency(114,232,0,0)	;get a stack of scroll of wisdom
	}
	openSheet(source_sheet)	;open execute sheet
	if(CheckSheetIsEmpty())
	{
		return
	}
	array_type := Object()		;define item type map
	array_check := Object()		;define item type check flg map
	Loop 99
	{
		array_type.push(Object())
	}
	Loop 24
	{
		array_check.push(Object())
	}
	if(rare_identify_flg = 1)	;identify rare equip and analyze
	{
		while(not CheckColorRGB(1280,615,0x3C3C03))	;try to use scroll of wisdom
		{
			MouseMove 1303,624
			CommonClick_right()
			Sleep,200
			if(A_Index > 30)
			{
				ExitApp
			}
		}
		Send,{Shift Down}
		Sleep,50
	}
	while(flag)
	{
		x := stash_start_x + (i * 632 // div)
		y := stash_start_y + (j * 632 // div)
		if(not array_check[i][j]=1)		;if already check,skip
		{
			MouseMove x,y
			Sleep,10
			;clipboard =		;clear clipboard
			;Send ^c
			;Sleep,20
			if(true)	;item
			{
				item_type := sortItem()
				local sheet_index := item_type	;set target sheet = item_type
				;~ if(item_type > 50 and item_type <> 99 and item_type <> 77 and rare_identify_flg=1)	;identified equip
				;~ {
					;~ item_type := item_type - 50
					;~ sheet_index := item_type	;set target sheet = item_type
				;~ }
				if((item_type = itemType_Valuable or item_type = itemType_UniqueTemp1 or item_type = itemType_UniqueCollect or item_type = itemType_SpecialBase) and rare_identify_flg=1)
				{
					CommonClick_left()		;unique&misc equip identifie	
					Sleep,10
				}
				else if(item_type >= itemType_Ring and item_type < itemType_2H)
				{
					if(rare_identify_flg=1)
					{
						CommonClick_left()		;identifie	
						Sleep,10
						clipboard =		;clear clipboard
						while(clipboard="")
						{
							Send ^c
							Sleep,10
						}
					}
					local item_value := analyzeItem()		;check item
					;MsgBox %item_value%
					local check_result_sheet := sortItemByValue(item_type,item_value,sheet)
					;MsgBox %check_result_sheet%
					if(check_result_sheet <> 0)		;valuable item
					{
						sheet_index := check_result_sheet		;set target sheet = 4 for valuale items
					}
				}
				if(item_type > 0)
				{
					array_itemInfo := [x,y]
					array_type[sheet_index].push(array_itemInfo)
					array_check[i][j] := 1
					if(item_type = itemType_Flasks)
					{
						array_check[i][j+1] :=1	;2x1 Flask
					}
					if(item_type = itemType_Belt)	;1x2 Belt
					{
						array_check[i+1][j] :=1
					}
					if(item_type >= itemType_Glove and item_type <= itemType_Shoe)	;2x2 Armor
					{
						array_check[i+1][j] :=1
						array_check[i][j+1] :=1
						array_check[i+1][j+1] :=1
					}
					if(item_type=itemType_Body)	;2x3 Body Armor
					{
						array_check[i][j+1] :=1
						array_check[i][j+2] :=1
						array_check[i+1][j] :=1
						array_check[i+1][j+1] :=1
						array_check[i+1][j+2] :=1
					}
					if(item_type=itemType_2H)	;2x4 Two Handed
					{
						array_check[i][j+1] :=1
						array_check[i][j+2] :=1
						array_check[i][j+3] :=1
						array_check[i+1][j] :=1
						array_check[i+1][j+1] :=1
						array_check[i+1][j+2] :=1
						array_check[i+1][j+3] :=1
					}
					;MsgBox % array_type[14][1][1]
				}
			}
			else	;not item
			{
			}
		}
		j:=j+1
		if (j>=y_repeat)
		{
			j:=0
			i:=i+1
			if (i>=x_repeat)
			{
				;MsgBox 该页物品不足，停止循环
				flag:=false
			}
		}
	}
	if(rare_identify_flg = 1)	;identify rare equip and analyze
	{
		Send,{Shift Up}
		Sleep,50
	}
	openSheet(0)	;
	CtrlMoveItemByGrid(0,0)
	openSheet(source_sheet)	;
	;MsgBox % array_type[14][1][1]
	sortItemInBatch(array_type[itemType_Ring],itemType_Ring,60)		;Ring
	sortItemInBatch(array_type[itemType_Amu],itemType_Amu,60)		;Amulet
	sortItemInBatch(array_type[itemType_Belt],itemType_Belt,30)		;Belt
	sortItemInBatch(array_type[itemType_Glove],itemType_Glove,12)		;Glove
	sortItemInBatch(array_type[itemType_Helm],itemType_Helm,12)		;Helm
	sortItemInBatch(array_type[itemType_Shoe],itemType_Shoe,12)		;Boot
	sortItemInBatch(array_type[itemType_Body],itemType_Body,6)		;Body
	sortItemInBatch(array_type[itemType_2H],itemType_2H,6)		;Two Handed
	sortItemInBatch(array_type[itemType_SpecialBase],itemType_SpecialBase,60)		;SpecialBase
	sortItemInBatch(array_type[itemType_D],itemType_D,60)			;Div Card
	sortItemInBatch(array_type[itemType_E],itemType_E,60)			;Essence
	sortItemInBatch(array_type[itemType_M],itemType_M,60)			;Map
	sortItemInBatch(array_type[itemType_Misc],itemType_Misc,60)			;Misc
	sortItemInBatch(array_type[itemType_Gem],itemType_Gem,60)			;Gem
	sortItemInBatch(array_type[itemType_VaalGem],itemType_VaalGem,60)			;VaalGem
	sortItemInBatch(array_type[itemType_HighQGem],itemType_HighQGem,60)			;HighQGem
	sortItemInBatch(array_type[itemType_Oil],itemType_Oil,60)			;Oil
	sortItemInBatch(array_type[itemType_Sample],itemType_Sample,60)			;Sample
	sortItemInBatch(array_type[itemType_Flasks],itemType_Flasks,24)			;Flask
	sortItemInBatch(array_type[itemType_Jewel],itemType_Jewel,60)		;Jewel
	sortItemInBatch(array_type[itemType_ClusterJewel],itemType_ClusterJewel,60)		;Jewel
	sortItemInBatch(array_type[itemType_Delve],itemType_Delve,60)		;fossil,resonator
	sortItemInBatch(array_type[itemType_Shard],itemType_Shard,60)		;shard
	sortItemInBatch(array_type[itemType_Prophecy],itemType_Prophecy,60)		;shard
	sortItemInBatch(array_type[itemType_Valuable],itemType_Valuable,60)		    ;s/e,valueable rare move to No.4 temp tab
	sortItemInBatch(array_type[itemType_Veiled],itemType_Veiled,60)		    ;veiled
	sortItemInBatch(array_type[itemType_TempTrashNormal],itemType_TempTrashNormal,60)		;trash nonrare 
	sortItemInBatch(array_type[itemType_TempTrashRare],itemType_TempTrashRare,60)		;trash rare
	sortUniqueItem(array_type[itemType_UniqueCollect],itemType_UniqueCollect,60)		;unique temp
	sortItemInBatch(array_type[itemType_C],0,60)		;currency
	
	array_type := ""		;clear item type map
	array_check := ""		;clear item type check flg map
}

;try to push unique into unique collection sheet
;if push failed,skip to next unique
;when inventory looped,push to unique temp sheet1
sortUniqueItem(array_axis,tab_index,periodCount)
{
	global
	local full_mode_flg := true
	local iCount := 0
	local inv_full_flag := false
	for index, element in array_axis
	{
		moveSuccess := CtrlMoveItem(element[1],element[2])	;pull
		if(moveSuccess=1)
		{
			iCount := iCount + 1
		}
		else if(moveSuccess=0)
		{
			inv_full_flag := true
		}
		if(iCount = periodCount or index = array_axis.MaxIndex() or inv_full_flag)
		{
			sortUniqueItemIntoTabs(tab_index,iCount,periodCount,full_mode_flg)	;push
			iCount := 0
			if(inv_full_flag)
			{
				inv_full_flag := false
			}
		}
	}
	CheckInvIsEmpty()
}
;sort unique into unique collection sheet
sortUniqueItemIntoTabs(tab_index,iCount,periodCount,full_mode_flg)
{
	global
	openSheet(tab_index)
	fail_flg := false
	local success_count := 0
	if (periodCount = 60)	;single grid item or unsure size
	{
		local i:=0
		local j:=0
		while(i<12)
		{
			moveSuccess := CtrlMoveItemCustomized(inv_start_x+i*disp,inv_start_y+j*disp,3)
			;if sort into unique collection fail, then skip
			;fast move mode
			;if(moveSuccess=1 or moveSuccess=2 or moveSuccess=0)	;move success or no item
			;{
				j:=j+1
				if(j=5)
				{
					j:=0
					i:=i+1
				}
				if(moveSuccess=0)
				{
					fail_flg:=true
				}
				if(moveSuccess=1)
				{
					success_count := success_count + 1
				}
				if(success_count>=iCount or (full_mode_flg=false and A_Index>=iCount))
				{
					Break
				}
			;}
		}
	}
	if(fail_flg)
	{
		sortFailItem(tab_index,iCount-success_count,periodCount,full_mode_flg)	;deal rest items
	}
	if(tab_index<>itemType_Temp)
	{
		openSheet(source_sheet) ;open temp item sort sheet
	}
	else
	{
		openSheet(exec_sheet)
	}
}

;get items defined in array_axis from stash to inventory
sortItemInBatch(array_axis,tab_index,periodCount)
{
	global
	local full_mode_flg := true
	if(tab_index=itemType_Temp or tab_index=itemType_Valuable or tab_index=itemType_Delve or tab_index=itemType_TempTrashNormal or tab_index=itemType_TempTrashRare or tab_index=itemType_SpecialBase or tab_index=itemType_UniqueTemp1 or tab_index=itemType_Veiled)	
	;if selected item type has different size (resonator,unique,random equip),then set full_mode_flg=true
	{
		full_mode_flg := true
	}
	else
	{
		full_mode_flg := false
	}
	local iCount := 0
	inv_full_flag := false
	for index, element in array_axis
	{
		moveSuccess := CtrlMoveItem(element[1],element[2])	;pull
		if(moveSuccess=1)
		{
			iCount := iCount + 1
		}
		else if(moveSuccess=0)
		{
			inv_full_flag := true
		}
		if(iCount = periodCount or index = array_axis.MaxIndex() or inv_full_flag)
		{
			sortItemIntoTabs(tab_index,iCount,periodCount,full_mode_flg)	;push
			iCount := 0
			if(inv_full_flag)
			{
				inv_full_flag := false
			}
		}
	}
	if(array_axis.MaxIndex>0)
	{
		CheckInvIsEmpty()
	}
}
;full_mode_flg=true : try to store every grid until last
;full_mode_flg=false : only store how many times geted from stash in this type
;when there is different size item in one type,use full_mode_flg=true
sortItemIntoTabs(tab_index,iCount,periodCount,full_mode_flg)
{
	global
	openSheet(tab_index)
	fail_flg := false
	local success_count := 0
	if (periodCount = 60)	;single grid item or unsure size
	{
		i:=0
		j:=0
		while(i<12)
		{
			moveSuccess := CtrlMoveItem(inv_start_x + i*disp,inv_start_y + j*disp)
			if(moveSuccess=1 or moveSuccess=2)	;move success or no item
			{
				j:=j+1
				if(j=5)
				{
					j:=0
					i:=i+1
				}
				if(moveSuccess=1)
				{
					success_count := success_count + 1
				}
				if(success_count>=iCount or (full_mode_flg=false and A_Index>=iCount))
				{
					Break
				}
			}
			else if(moveSuccess=0)
			{
				fail_flg = true
				Break
			}
		}
	}
	if (periodCount = 30)	;belt
	{
		i:=0
		j:=0
		while(i<6)
		{
			moveSuccess := CtrlMoveItem(inv_start_x + i*disp*2,inv_start_y + j*disp)
			if(moveSuccess=1 or moveSuccess=2)  ;move success or no item
				{
				j:=j+1
				if(j=5)
				{
					j:=0
					i:=i+1
				}
				if(moveSuccess=1)
				{
					success_count := success_count + 1
				}
				if(success_count>=iCount or (full_mode_flg=false and A_Index>=iCount))
				{
					Break
				}
			}
			else if(moveSuccess=0)
			{
				fail_flg = true
				;sortItemIntoTabs(4,iCount,periodCount,false)
				Break
			}
		}
	}
	if (periodCount = 24)	;flask
	{
		i:=0
		j:=0
		while(i<12)
		{
			moveSuccess := CtrlMoveItem(inv_start_x + i*disp,inv_start_y + j*disp*2)
			if(moveSuccess=1 or moveSuccess=2)  ;move success or no item
				{
				j:=j+1
				if(j=2)
				{
					j:=0
					i:=i+1
				}
				if(moveSuccess=1)
				{
					success_count := success_count + 1
				}
				if(success_count>=iCount or (full_mode_flg=false and A_Index>=iCount))
				{
					Break
				}
			}
			else if(moveSuccess=0)
			{
				fail_flg = true
				;sortItemIntoTabs(4,iCount,periodCount,false)
				Break
			}
		}
	}
	if (periodCount = 12)	;2x2 item
	{
		i:=0
		j:=0
		while(i<6)
		{
			moveSuccess := CtrlMoveItem(inv_start_x + i*disp*2,inv_start_y + j*disp*2)
			if(moveSuccess=1 or moveSuccess=2)
				{
				j:=j+1
				if(j=2)
				{
					j:=0
					i:=i+1
				}
				if(moveSuccess=1)
				{
					success_count := success_count + 1
				}
				if(success_count>=iCount or (full_mode_flg=false and A_Index>=iCount))
				{
					Break
				}
			}
			else if(moveSuccess=0)
			{
				fail_flg = true
				;sortItemIntoTabs(4,iCount,periodCount,false)
				Break
			}
		}
	}
	if (periodCount = 6)	;2x4 item
	{
		i:=0
		j:=0
		while(i<6)
		{
			moveSuccess := CtrlMoveItem(inv_start_x + i*disp*2,inv_start_y)
			if(moveSuccess=1 or moveSuccess=2)
				{
				j:=j+1
				if(j=1)
				{
					j:=0
					i:=i+1
				}
				if(moveSuccess=1)
				{
					success_count := success_count + 1
				}
				if(success_count>=iCount or (full_mode_flg=false and A_Index>=iCount))
				{
					Break
				}
			}
			else if(moveSuccess=0)
			{
				fail_flg = true
				Break
			}
		}
	}
	if(fail_flg)
	{
		sortFailItem(tab_index,iCount-success_count,periodCount,full_mode_flg)	;deal rest items
	}
	if(tab_index<>itemType_Temp)
	{
		openSheet(source_sheet) ;open temp item sort sheet
	}
	else
	{
		openSheet(exec_sheet)
	}
}
sortFailItem(tab_index,iCount,periodCount,full_mode_flg)
{
	global
	if(tab_index>=itemType_Glove and tab_index<=itemType_2H)
	{
		sortItemIntoTabs(tab_index+6,iCount,periodCount,true)	;chaos recipe,then sort into bak
	}
	else if(tab_index=itemType_TempTrashNormal)
	{
		sortItemIntoTabs(itemType_TempTrashRare,iCount,periodCount,true)	;chaos recipe,then sort into 28
	}
	else if(tab_index=itemType_TempTrashRare)
	{
		sortItemIntoTabs(itemType_TempTrash1,iCount,periodCount,true)	;chaos recipe,then sort into 28
	}
	else if(tab_index>=itemType_TempTrash1 and tab_index<=itemType_TempTrash3)
	{
		sortItemIntoTabs(tab_index+1,iCount,periodCount,true)	;chaos recipe,then sort into 28
	}
	else if(tab_index=itemType_UniqueCollect)
	{
		sortItemIntoTabs(itemType_UniqueTemp1,iCount,periodCount,true)
	}
	else if(tab_index>=itemType_UniqueTemp1 and tab_index<=itemType_UniqueTemp2)
	{
		sortItemIntoTabs(tab_index+1,iCount,periodCount,true)	;chaos recipe,then sort into 28
	}
	else
	{
		sortItemIntoTabs(itemType_Valuable,iCount,periodCount,true)	;not equip,then sort into 4
	}
}

;auto vendor trash tab
autoVendorTrash(sheet)
{
	global
	local i := 0
	local j := 0
	local equipbase := ""
	local array_equipbase := Object()
	openSheet(sheet)
	while(i<24)
	{
		flag:=true ;checkLineNotEmpty(i) or checkLineNotEmpty(i+1)
		if(flag)	;if line i is not all empty,then identifie this line,else end loop
		{
			while(j<24)
			{
				x := stash_start_x + (i * 632 // div)
				y := stash_start_y + (j * 632 // div)
				MouseMove x,y
				equipbase := getEquipBaseType(x,y)	;evoid 5 rare vendor recipe
				equipbase := StrReplace(equipbase," ","")
				if(equipbase<>"" and array_equipbase[equipbase]>=4)	;same base item >=4
				{
					vendorTrash_all()
					openSheet(sheet)
					array_equipbase := Object()
				}
				else
				{
					if(array_equipbase[equipbase]="")
					{
						array_equipbase[equipbase] := 0
					}
					moveResult := CtrlMoveItem(x,y)
					if(moveResult=1)	;move success or no item,then next grid
					{
						array_equipbase[equipbase] := array_equipbase[equipbase] + 1
						j:=j+1
					}
					else if(moveResult=2)
					{
						j:=j+1
					}
					else if(moveResult=0)	;move fail,then vendor
					{
						vendorTrash_all()
						openSheet(sheet)
						array_equipbase := Object()
					}
				}
			}
			j:=0
			i:=i+1
		}
		else
		{
			Break
		}
	}
	vendorTrash_all()
	Sleep,50
	i:=0
}

vendorTrash_all()
{
	global
	openVendor()
	vendorMove_all()
	vendorDeal()
	openStash()
	storeCurrency()
}

;auto identifie trash tab
autoIdentifie()
{
	global
	openSheet(0)
	CtrlMoveItemByGrid(0,4)
	CtrlMoveItemByGrid(1,4)
	CtrlMoveItemByGrid(2,4)
	CtrlMoveCurrency(114,232,0,0)	;get a stack of scroll of wisdom
	openSheet(itemType_TempTrashRare)
	identifieItems()
	openSheet(0)
	CtrlMoveItemByGrid(0,0)
}

;loop and identifie items for current tab
identifieItems()
{
	global
	i := 0
	j := 0
	flag:=true
	while(not CheckColorRGB(1280,615,0x3C3C03))	;try to use scroll of wisdom
	{
		MouseMove 1303,624
		CommonClick_right()
		Sleep,200
	}
	Send,{Shift Down}
	Sleep,50
	while(i<24)
	{
		flag:=checkLineNotEmpty(i)
		if(flag)	;if line i is not all empty,then identifie this line,else end loop
		{
			while(j<24)
			{
				x := stash_start_x + (i * 632 // div)
				y := stash_start_y + (j * 632 // div)
				MouseMove x,y
				CommonClick_left()		;identifie
				j:=j+1
			}
			j:=0
			i:=i+1
		}
		else
		{
			Break
		}
	}
	Send,{Shift Up}
	Sleep,50
	i:=0
}

;auto vendor main
autoVendor()	
{
	global
	;openStash()
	local result := 0
	result := result + pickEquip(itemType_Ring,1,1,24)
	result := result + pickEquip(itemType_Ring,1,1,24)
	result := result + pickEquip(itemType_Amu,1,1,24)
	result := result + pickEquip(itemType_Belt,1,2,24)
	result := result + pickEquip(itemType_Glove,2,2,24)
	result := result + pickEquip(itemType_Helm,2,2,24)
	result := result + pickEquip(itemType_Shoe,2,2,24)
	result := result + pickEquip(itemType_Body,3,2,24)
	result := result + pickEquip(itemType_2H,4,2,24)
	if(result > 0)	;some type of items not exist
	{
		return result
	}
	else
	{
		openVendor()
		vendorMove_chaosRecipe()
		vendorDeal()
		openStash()
		storeCurrency()
		return 0
	}
}

;pick equip from stash  
;page=pageIndex  Ring Amu Belt G H S Bd W  Color:5x3Blue
;hh=item height
;ww=item width
;div=stash type 12x12 or 24x24
pickEquip(page,hh,ww,div)	
{
	global
	;Msgbox % page_list[1][1]
	pe_result := 0
	openSheet(page)
	y_repeat := div / hh
	x_repeat := div / ww
	
	i:=array_itemAxis[page][1]
	j:=array_itemAxis[page][2]
	flag := true
	while(flag)
	{
		x := stash_start_x + (i * 632 // div * ww)
		y := stash_start_y + (j * 632 // div * hh)
		if(checkItemInfo(x,y))	;item exists
		{
			CtrlMoveItem(x,y)
			flag := false
		}
		else	;item not exists
		{
			j:=j+1
			if (j>=y_repeat)
			{
				j:=0
				i:=i+1
				if (i>=x_repeat)
				{
					;MsgBox 该页物品不足，停止循环
					flag:=false
					pe_result := 1
					;Pause
				}
			}
		}
	}
	array_itemAxis[page][1] := i
	array_itemAxis[page][2] := j
	return pe_result
}

;move all items from inventory to vendor
vendorMove_all()
{
	x_diff := -961
	y_diff := -69
	inv_start_x := 1296
	inv_start_y := 615
	disp := 52.5
	i:=0
	j:=0
	x := inv_start_x+i*disp
	y := inv_start_y+j*disp
	while(i<12)
	{
		while(j<5)
		{
			x := inv_start_x+i*disp
			y := inv_start_y+j*disp
			while(checkColorRGB(x,y,0x101010)=false and checkColorRGB(x+x_diff,y+y_diff,0x101010)=true)	;color check
			{
				MouseMove x,y
				Sleep,30
				CtrlClick()
				MouseMove 1353,485	;leave item to not show tooltips
				Sleep,100
				if(A_Index>10 and CheckItemInfo(x+x_diff,y+y_diff)=true)	;if color check not work,then go iteminfo check
				{
					Break
				}
			}
			j:=j+1
		}
		j:=0
		i:=i+1
	}
}

;move chaos recipe items from inventory to vendor
vendorMove_chaosRecipe()
{
item_axis_1 := [1296,615,0x081F08]
item_axis_2 := [1300,670,0x031E04]
item_axis_3 := [1297,721,0x234F46]
item_axis_4 := [1301,777,0x6A6151]
item_axis_5 := [1351,617,0xB1AB9C]
item_axis_6 := [1386,700,0x041E04]
item_axis_7 := [1436,594,0x010101]
item_axis_8 := [1506,719,0x031D04]
item_axis_9 := [1614,616,0x011C01]
	Send,{Ctrl down}
	Sleep,20
	moveEquip(item_axis_1[1],item_axis_1[2])
	moveEquip(item_axis_2[1],item_axis_2[2])
	moveEquip(item_axis_3[1],item_axis_3[2])
	moveEquip(item_axis_4[1],item_axis_4[2])
	moveEquip(item_axis_5[1],item_axis_5[2])
	moveEquip(item_axis_6[1],item_axis_6[2])
	moveEquip(item_axis_7[1],item_axis_7[2])
	moveEquip(item_axis_8[1],item_axis_8[2])
	moveEquip(item_axis_9[1],item_axis_9[2])
	Send,{Ctrl up}
	Sleep,20
}
moveEquip(x,y)
{
	x_diff := -961
	y_diff := -69
	;CommonClick(x,y)
	while((CheckColorRGB(x+x_diff,y+y_diff,0x101010)=true) and (CheckColorRGB(x+x_diff,y+y_diff+18,0x101010)=true) and (CheckColorRGB(x+x_diff+18,y+y_diff,0x101010)=true))
	{
		;MsgBox %x%,%y%
		CommonClick(x,y)
	}
}

;auto analyze all items in tab 
;and get which item's calculated resultvalue over checkvalue into temp2
autoAnalyze(analyze_sheet_list)
{
	global
	openSheet(0)
	CtrlMoveItemByGrid(0,4)
	CtrlMoveItemByGrid(1,4)	;store scrolls
	CtrlMoveItemByGrid(2,4)
	for index, element in analyze_sheet_list
	{
		exec_sheet := element
		openSheet(exec_sheet)
		local i := 0
		local j := 0
		flag:=true
		array_type := Object()		;define valuable item map
		array_check := Object()		;define item type check flg map
		Loop 24
		{
			array_check.push(Object())
		}
		while(flag)
		{
			x := stash_start_x + (i * 632 // div)
			y := stash_start_y + (j * 632 // div)
			if(not array_check[i][j]=1)		;if already check,skip
			{
				MouseMove x,y
				Sleep,10
				clipboard =		;clear clipboard
				Send ^c
				if(not clipboard="")	;item
				{
					item_type := sortItem()
					if(item_type > 0)
					{
						array_check[i][j] := 1
						if(item_type = 9)
						{
							array_check[i][j+1] :=1	;2x1 Flask
						}
						if(item_type = 16)	;1x2 Belt
						{
							array_check[i+1][j] :=1
						}
						if(item_type>=17 and item_type <=19)	;2x2 Armor
						{
							array_check[i+1][j] :=1
							array_check[i][j+1] :=1
							array_check[i+1][j+1] :=1
						}
						if(item_type=20)	;2x3 Body Armor
						{
							array_check[i][j+1] :=1
							array_check[i][j+2] :=1
							array_check[i+1][j] :=1
							array_check[i+1][j+1] :=1
							array_check[i+1][j+2] :=1
						}
						if(item_type=21)	;2x4 Two Handed
						{
							array_check[i][j+1] :=1
							array_check[i][j+2] :=1
							array_check[i][j+3] :=1
							array_check[i+1][j] :=1
							array_check[i+1][j+1] :=1
							array_check[i+1][j+2] :=1
							array_check[i+1][j+3] :=1
						}
						item_value := analyzeItem()
						local check_result := sortItemByValue(item_type,item_value,exec_sheet)
						if(check_result <> 0)
						{
							array_itemInfo := [x,y]
							array_type.push(array_itemInfo)
							;MsgBox % array_type[14][1][1]
						}
					}
				}
				else	;not item
				{
				}
			}
			j:=j+1
			if (j>=y_repeat)
			{
				j:=0
				i:=i+1
				if (i>=x_repeat or not checkLineNotEmpty(i))
				{
					;MsgBox 该页物品不足，停止循环
					flag:=false
				}
			}
		}
		if(exec_sheet<>itemType_Valuable)
		{
			sortItemInBatch(array_type,itemType_Valuable,60)		;sort all item in temp2
		}
		else
		{
			sortItemInBatch(array_type,itemType_Temp,60)
		}
		;MsgBox % array_type[14][1][1]
		array_type := ""		;clear item type map
		array_check := ""		;clear item type check flg map	
	}
}

;return item sort into which sheet
;by item type and exec from which sheet
sortItemByValue(item_type,item_value,exec_sheet)
{
	local check_value := 999
	if(item_type = itemType_Ring or item_type = itemType_Amu)	;ring and amulet
	{
		check_value := 90
		if(exec_sheet=itemType_Valuable)
		{
			check_value := 110	;more strict check
		}
	}
	else if(item_type = itemType_Belt or item_type = itemType_Helm or item_type = itemType_Shoe)	;belt,boots,helm
	{
		check_value := 110
		if(exec_sheet=itemType_Valuable)
		{
			check_value := 140	;more strict check
		}
	}
	else if(item_type = itemType_Glove)	;glove
	{
		check_value := 100
		if(exec_sheet=itemType_Valuable)
		{
			check_value := 130	;more strict check
		}
	}
	else if(item_type = itemType_Body)	;body armor
	{
		check_value := 125
		if(exec_sheet=itemType_Valuable)
		{
			check_value := 150	;more strict check
		}
	}
	if(item_value >= check_value)
	{
		if(exec_sheet <> itemType_Valuable)
		{
			return itemType_Valuable
		}
		else
		{
			return itemType_Temp
		}
	}
	return 0
}

endExecute()	;end
{
	if(autoShutDown=1)
	{
		run shutdown -s -t 30
	}
}