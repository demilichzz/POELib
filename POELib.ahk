#Persistent
#SingleInstance force
#InstallKeybdHook    ;安装键盘钩子，主要用来判断键盘是否处于按下状态，如果是就一直发送键盘消息！如果报毒的话就是这里报毒，加密下这一句代码就OK了
#MaxHotkeysPerInterval 240
#MaxThreadsPerHotkey 3
Process, Priority, , high
SetKeyDelay, 0, 3
SetStoreCapslockMode, off
;constant define

;constant define
#Include D:\Program Files\AutoHotkey\script\POELib\autoMacroLib.ahk

~^Numpad9::		;test
{
	POEConstantLib_constantDefine()
	array_equipbase := sortItem()
	;eb := "Test"
	;array_equipbase[eb] := 1
	;sa := "Test"	
	;MsgBox % array_equipbase[sa]
	MsgBox % array_equipbase
}
Return

openSheet(index)	;open the index start by 0
{
	global
	target_page := 0
	if(index >=0 and index <=30)
	{
		target_page := 0
	}
	else if(index >30 and index <= 60)
	{
		target_page := 1
	}
	else if(index >60 and index <= 90)
	{
		target_page := 2
	}
	ColorClickMulti(tablist_x,tablist_y,currency_x,currency_y,currency_color_list,true,100)	;open sheet scroll
	if(current_page <> target_page or index=0)
	{
		ColorClick(scroll_start_x,scroll_start_y+scroll_disp*target_page,scroll_start_x,scroll_start_y+scroll_disp*target_page,scroll_color,false,500)
		current_page := target_page
	}
	ColorClickMulti(tab_start_x,tab_start_y+10+(tab_disp_y*(index-(target_page*30))),currency_x,currency_y,currency_color_list,false,500)
}
CtrlClick()
{
	Send,{Ctrl Down}
	Sleep,5
	CommonClick_left()
	Send,{Ctrl Up}
	Sleep,5
}
CommonClick_left()
{
	Click Down Left
	Sleep,10
	Click Up Left
	Sleep,10
}
CommonClick_right()
{
	Click Down Right
	Sleep,10
	Click Up Right
	Sleep,10
}
ColorClickMulti(x,y,xtar,ytar,cclist,mode,clickdelay)
{
	flg := false
	while (flg = false)
	{
		PixelGetColor,color,xtar,ytar,RGB
		color_flag := false
		if(color = cclist[1] or color = cclist[2] or color = cclist[3])
		{
			color_flag := true
		}
		;Msgbox %cc%,%color%
		;text = %x%,%y%,%xtar%,%ytar%,%cc%,color:%color%
		;TrayTip, , %text%
		if ((color_flag and mode = true) or (not color_flag and mode = false))
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

;analyze item value by clipboard
analyzeItem()
{
	rare_flg := false
	prefix_count:=0
	suffix_count:=0
	modifer_start_flg:=false
	modifer_array := Object()
	;MsgBox test0
	Loop, parse, clipboard, `n, `r
	{
		if(A_Index=1)
		{
			if (A_LoopField = "Rarity: Rare")
			{
				rare_flg := true
			}
		}
		if(modifer_start_flg)	;record affix row into array
		{
			;MsgBox test2
			modifer_array.push(A_LoopField)
		}
		if (Instr(A_LoopField,"Item Level:")>0)	;row after item level may be implicit or explicit
		{
			;MsgBox test1
			modifer_start_flg:=true
		}
	}
	return analyzeModifer(modifer_array)
}

;analyze modifer text rows
analyzeModifer(modifer_array)
{
	modifer_value_array := Object()
	for index, element in modifer_array
	{
		if(element = "" or element = "--------")
		{
			continue
		}
		else if(Instr(element,"crafted")>0)	;not analyze master craft affix
		{
			continue
		}
		else
		{
			value := getModiferValue(element)
			if(value <> 0)
			{
				modifer_value_array.push(value)		;get an array with mod index and mod value
			}
		}
	}
	return calculateModiferValue(modifer_value_array)
}

;calculate modifer value
;merge same modifer and x weight to calculate final value
;calculate as base life has 1 weight
calculateModiferValue(modifer_value_array)
{
	global
	local merged_value := Object()
	Loop %modifer_count%
	{
		merged_value[A_Index] := 0
	}
	for index, element in modifer_value_array
	{
		mod_index := element[0]
		;MsgBox %mod_index%
		;MsgBox % element[1]
		merged_value[mod_index] := merged_value[mod_index] + element[1]
	}
	result_value := 0
	Loop %modifer_count%
	{
		;MsgBox % merged_value[A_Index]
		if (A_Index=11)	;minion level
		{
			if(merged_value[A_Index]=1)
			{
				merged_value[A_Index]:=0	;remove +1 level weight
			}
		}
		result_value := result_value + merged_value[A_Index] * weight_list[A_Index]
	}
	merged_value := ""
	return result_value
}

getModiferValue(modifer_string)
{
	global
	for index, element in modifer_match_array
	{
		regString := StrReplace(element,"#","(.*)")
		regString := StrReplace(regString,"+","")
		FoundPos := RegExMatch(modifer_string, regString, SubPat)
		if(FoundPos>0)
		{
			result:=Array()
			result[0]:=index
			result[1]:=SubPat1
			return result
		}
	}
	return 0
}
getModValue(modString,regString)
{
	regString := StrReplace(regString,"(","[(]")
	regString := StrReplace(regString,")","[)]")
	regString := StrReplace(regString,"#","(.*)")
	regString := StrReplace(regString,"+","")
	FoundPos := RegExMatch(modString, regString, SubPat)
	if(FoundPos>0)
	{
		return SubPat1
	}
	else
	{
		return -1
	}
}

sortItem()		;sort single item by clipboard
{
	global
	clipboard := 
	Send ^c
	MouseGetPos, x, y
	item_exist_temp := not CheckColorRGB(x-3,y-3,0x101010)
	if(item_exist_temp)		;if color check result is item exist(surely exist) 
	{
		ClipWait, 2
	}
	else	;color check has chance to uncorrectly return false due to item color
	{
		Sleep,30
	}
	rare_flg := false
	currency_flg := false
	equip_type := 0
	unid_flg := false
	if (Instr(clipboard,"Unidentified")>0)
	{
		unid_flg := true
	}
	if(Instr(clipboard,"Veiled Suffix")>0 or Instr(clipboard,"Veiled Prefix")>0)
	{
		return itemType_Veiled
	}
	else if(Instr(clipboard,"Map Tier:")>0 and Instr(clipboard,"Rarity: Divination Card")=0)	;identified map and not div card
	{
		return itemType_M
	}
	else if(Instr(clipboard,"Shaper Scarab")>0 or Instr(clipboard,"Elder Scarab")>0 or (Instr(clipboard,"Mortal")>0 and Instr(clipboard,"Can be used in a personal Map Device.")>0))	;scarab and queen fragment
	{
		return itemType_Misc
	}
	else if(Instr(clipboard,"Rarity: Divination Card")=0 and (Instr(clipboard,"Elder Item")>0 or Instr(clipboard,"Shaper Item")>0 or Instr(clipboard,"Crusader Item")>0 or Instr(clipboard,"Hunter Item")>0 or Instr(clipboard,"Warlord Item")>0 or Instr(clipboard,"Redeemer Item")>0))
	{
		return itemType_SpecialBase
	}
	else if(Instr(clipboard,"Right-click to add this prophecy to your character.")>0)	;shard,prophecy
	{
		return itemType_Prophecy
	}
	else if(Instr(clipboard,"Combine this with four other different samples in Tane's Laboratory.")>0)	;metamorph
	{
		return itemType_Sample
	}
	else
	{
		Loop, parse, clipboard, `n, `r
		{
			if (A_Index=1)
			{
				if (A_LoopField = "Rarity: Rare")
				{
					rare_flg := true
				}
				else if (A_LoopField = "Rarity: Currency")
				{
					currency_flg := true
				}
				else if (A_LoopField = "Rarity: Unique")
				{
					return itemType_UniqueCollect
				}
				else if (A_LoopField = "Rarity: Gem")
				{
					return checkGemType(clipboard)
				}
				else if (A_LoopField = "Rarity: Divination Card")
				{
					return itemType_D
				}
			}
			if (A_Index = 2)
			{
				if(Instr(A_LoopField,"Map")>0)
				{
					return itemType_M
				}
				else if(Instr(A_LoopField,"Essence")>0 or Instr(A_LoopField,"Remnant of Corruption")>0)
				{
					return itemType_E
				}
				else if(Instr(A_LoopField,"Flask")>0)
				{
					return itemType_Flasks
				}
				else if(Instr(A_LoopField,"Sacrifice at")>0 or Instr(A_LoopField,"Offering to the Goddess")>0 or Instr(A_LoopField,"'s Key")>0 or Instr(A_LoopField,"Fragment of")>0 or Instr(A_LoopField,"Divine Vessel")>0)	;misc
				{
					return itemType_Misc
				}
				else if(Instr(A_LoopField,"Scarab")>0 and rare_flg = false)
				{
					return itemType_Misc
				}
				else if(Instr(A_LoopField,"Cluster Jewel")>0)
				{
					return itemType_ClusterJewel
				}
				else if(Instr(A_LoopField,"Jewel")>0 and Instr(A_LoopField,"Jeweller")<=0 and Instr(A_LoopField,"Jewelled")<=0)
				{
					return itemType_Jewel
				}
				else if(currency_flg and Instr(A_LoopField, "Fossil")>0)
				{
					return itemType_Delve
				}
				else if(currency_flg and Instr(A_LoopField, "Resonator")>0)
				{
					return itemType_Delve
				}
				else if(currency_flg and Instr(A_LoopField, "Splinter")>0 and Instr(A_LoopField, "Simulacrum Splinter")<=0)
				{
					return itemType_Misc
				}
				else if((currency_flg and (Instr(A_LoopField, "Shard")>0 or Instr(A_LoopField, "Catalyst")>0) or Instr(A_LoopField, "Breachstone")>0) or Instr(clipboard,"Delirium Orb")>0)
				{
					return itemType_Shard
				}
				else if(currency_flg=false and Instr(A_LoopField, "Incubator")>0)
				{
					return itemType_Shard
				}
				else if(currency_flg and Instr(A_LoopField, "Oil")>0)
				{
					return itemType_Oil
				}
				else if(currency_flg)
				{
					return itemType_C  ;currency
				}
			}
			if (A_Index = 3)
			{
				if(Instr(A_LoopField,"Talisman")>0)
				{
					return itemType_Amu
				}
				else if(Instr(A_LoopField,"Cluster Jewel")>0)
				{
					return itemType_ClusterJewel
				}	
			}
			if (A_Index>1 and rare_flg=false)
			{
				return itemType_TempTrashNormal ;vendor trash nonrare
			}
			else
			{
				if(rare_flg and A_Index=2 and unid_flg)	;unid rare check
				{
					equip_type := checkEquipType(A_LoopField)
				}
				if(rare_flg and A_Index=3 and equip_type=0)	;ided rare check
				{
					equip_type := checkEquipType(A_LoopField)
				}
				if(equip_type = 0 and rare_flg and unid_flg and A_Index=4)
				{
					equip_type := checkEquipTypeTwoHand(A_LoopField)
				}
				if(equip_type = 0 and rare_flg and A_Index=5)
				{
					equip_type := checkEquipTypeTwoHand(A_LoopField)
				}
				;~ if (A_LoopField = "Unidentified")
				;~ {
					;~ unid_flg := true
				;~ }
			}
		}
		if(rare_flg and equip_type > 0)
		{
			; if (unid_flg := true)
			if(true)
			{
				local socket:=checkEquipInfo(clipboard)
				if(socket=6)
				{
					return itemType_TempTrashNormal
				}
				else
				{
					return equip_type
				}
			}
			;else
			;{
			;	return equip_type + 50
			;}
		}
		else if(rare_flg)
		{
			return itemType_TempTrashRare	;vendor trash rare
		}
		return 0
	}
	return 0
}

getEquipBaseType(x,y)	;get item basetype by clipboard
{
	global
	clipboard := 
	Send ^c
	item_exist_temp := not CheckColorRGB(x-3,y-3,0x101010)
	basetype := ""
	rare_flg := false
	if(item_exist_temp)
	{
		ClipWait, 2
	}
	else
	{
		Sleep,30
	}
	Loop, parse, clipboard, `n, `r
	{
		if(A_Index=1 and A_LoopField = "Rarity: Rare")
		{
			rare_flg := true
		}
		if (A_Index=3 and rare_flg)
		{
			basetype := A_LoopField
			break
		}
	}
	return basetype
}

CtrlMoveItem(x,y)	;make sure item moved,check by clipboard
{
	return CtrlMoveItemCustomized(x,y,30)
}

CtrlMoveItemCustomized(x,y,tryTime)	;make sure item moved,check by clipboard
{
	if(x>0 and y>0)
	{
		MouseMove x,y
		Sleep,10
		item_exist_temp := not CheckColorRGB(x-3,y-3,0x101010)
		clipboard =		;clear clipboard
		Send ^c
		if(item_exist_temp)
		{
			ClipWait, 2
		}
		else
		{
			Sleep,30
		}
		if (clipboard="")	;no item
		{
			return 2
		}
		else
		{
			while (not clipboard="")	;item exist
			{
				CtrlClick()
				clipboard =		;clear clipboard
				Send ^c
				if (A_Index > tryTime)
				{
					return 0	;item move fail
				}
				Sleep,50
			}
			return 1	;item move success
		}
	}
	return 0
}

;i,j=move until inventory i,j filled by currency
;used by get scroll of wisdom to inventory
CtrlMoveCurrency(x,y,i,j)	;make sure item moved to target
{
	global
	if(x>0 and y>0)
	{
		MouseMove x,y
		Sleep, 20
		moveNotSuccessFlg:=true
		while (moveNotSuccessFlg=true)	;item exist
		{
			CtrlClick()
			Sleep,200
			moveNotSuccessFlg := CheckColorRGB(inv_start_x+i*disp,inv_start_y+j*disp,0x101010)
			if (A_Index > 30)
			{
				return 0	;item move fail
			}
		}
		return 1	;item move success
	}
	return 0
}
CtrlMoveItemByGrid(i,j)	;move item from player inventory
{
	global
	return CtrlMoveItem(inv_start_x+i*disp,inv_start_y+j*disp)
}

CheckNoItemByGrid(i,j)
{
	global
	return CheckColorRGB(inv_start_x+i*disp,inv_start_y+j*disp,0x101010)
}

storeCurrency()		;store currency into temp-currency tab
{
	global
	openSheet(itemType_TempCurrency)
	i:=0
	j:=0
	while(i<3)
	{
		while(j<5)
		{
			CtrlMoveItemByGrid(i,j)
			while(not CheckNoItemByGrid(i,j))	;check if grid has item
			{
				CtrlMoveItemByGrid(i,j)
			}
			;~ if(j<4)
			;~ {
				;~ result := CheckNoItemByGrid(i,j+1)	;check next grid
			;~ }
			;~ else
			;~ {
				;~ result := CheckNoItemByGrid(i+1,0)
			;~ }
			;~ if(result)	;check next grid,if no item,then exit
			;~ {
				;~ return true
			;~ }
			;~ else
			;~ {
				j:=j+1
			;~ }
		}
		j:=0
		i:=i+1
	}
	return true
}

checkGemType(cp)
{
	global
	local clip_array := Object()
	local match_level := ("Level: #")
	local match_quality := ("Quality: +#% (augmented)")
	local level := -1
	local quality := -1
	Loop, parse, cp, `n, `r
	{
		clip_array[A_Index] := A_LoopField
	}
	for index, element in clip_array
	{
		if (InStr(element,"Level") > 0 and level=-1)
		{
			level := getModValue(element,match_level)
		}
		if (InStr(element,"Quality") > 0 and quality=-1)
		{
			quality := getModValue(element,match_quality)
		}
	}
	if(level >= 18 or quality >= 17)
	{
		return itemType_HighQGem
	}
	else
	{
		if(InStr(cp,"Vaal") > 0 and InStr(cp,"Corrupted") > 0)
		{
			return itemType_VaalGem
		}
		else
		{
			return itemType_Gem
		}
	}
}
;check detailed equip info
;ilvl, sockets, links
checkEquipInfo(cp)
{
	global
	local clip_array := Object()
	local match_iLvl := ("Item Level: #")
	local match_sockets := ("Sockets: #")
	local iLvl := -1
	local socketInfo := -1
	Loop, parse, cp, `n, `r
	{
		clip_array[A_Index] := A_LoopField
	}
	for index, element in clip_array
	{
		if (InStr(element,"Item Level") > 0 and iLvl=-1)
		{
			iLvl := getModValue(element,match_iLvl)
		}
		if (InStr(element,"Sockets") > 0 and socketInfo=-1)
		{
			socketInfo := getModValue(element,match_sockets)
		}
	}
	socketInfo := StrReplace(socketInfo," ","")
	socketInfo := StrReplace(socketInfo,"-","")
	local sockets := StrLen(socketInfo)
	return sockets
}

checkEquipType(text)	;check equip type by clipboard
{
	global
	result := 0
	result := checkTricket(text)
	if(result=0)
	{
		result := checkGlove(text)
	}
	if(result=0)
	{
		result := checkBoot(text)
	}
	if(result=0)
	{
		result := checkHelm(text)
	}
	if(result=0)
	{
		result := checkBody(text)
	}
	return result
}
checkEquipTypeTwoHand(text)
{
	global
	result := 0
	result := result + InStr(text,"Two Handed")
	result := result + InStr(text,"Bow")
	result := result + InStr(text,"Staff")
	if result > 0
	{
		return itemType_2H
	}
	return 0
}
checkTricket(text)
{
	global
	result := 0
	array_Tri := Object()
	array_Tri.insert("Ring")
	array_Tri.insert("Amulet")
	array_Tri.insert("Belt")
	array_Tri.insert("Sash")
	array_Tri.insert("Vise")
	result := 0
	StringSplit, array_out, text, %A_Space%, . 
	comp_text = %array_out2%
	Loop 4
	{
		match_text := array_Tri[A_Index]
		if (comp_text == match_text)
		{
			result := A_Index + itemType_Ring - 1	;tricket tab index
			if (A_Index = 4 or A_Index = 5)
			{
				result := itemType_Belt
			}
			Break
		}
	}
	return result
}
checkHelm(text)
{
	global
	result := 0
	array_Helm := Object()
	array_Helm.insert("Helmet")
	array_Helm.insert("Burgonet")
	array_Helm.insert("Cap")
	array_Helm.insert("Hood")
	array_Helm.insert("Tricorne")
	array_Helm.insert("Pelt")
	array_Helm.insert("Circlet")
	array_Helm.insert("Cage")
	array_Helm.insert("Helm")
	array_Helm.insert("Sallet")
	array_Helm.insert("Bascinet")
	array_Helm.insert("Crown")
	array_Helm.insert("Mask")
	result := 0
	Loop 13
	{
		match_text := array_Helm[A_Index]
		checkPos := InStr(text,match_text)
		if (checkPos > 0)
		{
			result := itemType_Helm		;helm tab index
			Break
		}
	}
	return result
}
checkGlove(text)
{
	global
	array_Glove := Object()
	array_Glove.insert("Gauntlets")
	array_Glove.insert("Gloves")
	array_Glove.insert("Mitts")
	result := 0
	Loop 3
	{
		match_text := array_Glove[A_Index]
		checkPos := InStr(text,match_text)
		if (checkPos > 0)
		{
			result := itemType_Glove		;glove tab index
			Break
		}
	}
	return result
}
checkBoot(text)
{
	global
	array_Boot := Object()
	array_Boot.insert("Greaves")
	array_Boot.insert("Boots")
	array_Boot.insert("Shoes")
	array_Boot.insert("Slippers")
	result := 0
	Loop 4
	{
		match_text := array_Boot[A_Index]
		checkPos := InStr(text,match_text)
		if (checkPos > 0)
		{
			result := itemType_Shoe		;boot tab index
			Break
		}
	}
	return result
}
checkBody(text)
{
	global
	array_Body := Object()
	array_Body.insert("Plate")
	array_Body.insert("Leather")
	array_Body.insert("Tunic")
	array_Body.insert("Garb")
	array_Body.insert("Robe")
	array_Body.insert("Vest")
	array_Body.insert("Vestment")
	array_Body.insert("Wrap")
	array_Body.insert("Regalia")
	array_Body.insert("Brigandine")
	array_Body.insert("Doublet")
	array_Body.insert("Armour")
	array_Body.insert("Lamellar")
	array_Body.insert("Wyrmscale")
	array_Body.insert("Dragonscale")
	array_Body.insert("Coat")
	array_Body.insert("Ringmail")
	array_Body.insert("Chainmail")
	array_Body.insert("Hauberk")
	array_Body.insert("Raiment")
	array_Body.insert("Jacket")
	array_Body.insert("Silks")
	result := 0
	Loop 22
	{
		match_text := array_Body[A_Index]
		if (Instr(text,"Plated Maul")>0)
		{
			result := itemType_2H
			Break
		}
		checkPos := InStr(text,match_text)
		if (checkPos > 0)
		{
			result := itemType_Body		;body tab index
			Break
		}
	}
	return result
}

;check if a stash tab line is all empty
;if line=i has a grid is not empty,then return true
checkLineNotEmpty(i)
{
	global
	result := false
	j:=0
	while(not result)
	{
		x := stash_start_x + (i * 632 // div)
		y := stash_start_y + (j * 632 // div)
		result := not CheckColorRGB(x,y,0x101010)
		if(result)
		{
			return result
		}
		else
		{
			j:=j+1
			if(j>=24)
			{
				return false
			}
		}
	}
	return false
}
CheckSheetIsEmpty()
{
	global
	local i:=0
	local j:=0
	local sheetIsEmptyCount:=false
	sheetIsEmptyCount := CheckEmptyByAxis(stash_start_x + 0*disp/2,stash_start_y + 0*disp/2) and CheckEmptyByAxis(stash_start_x + 3*disp/2,stash_start_y + 0*disp/2) and CheckEmptyByAxis(stash_start_x + 0*disp/2,stash_start_y + 3*disp/2) and CheckEmptyByAxis(stash_start_x + 3*disp/2,stash_start_y + 3*disp/2)
	return sheetIsEmptyCount
}
CheckInvIsEmpty()
{
	global
	local i:=0
	local j:=0
	local invIsEmptyCount:=0
	while(i<12 and j<5)
	{
		if(not CheckEmptyByAxis(inv_start_x + i*disp + 10,inv_start_y + j*disp + 10))
		{
			invIsEmptyCount:=invIsEmptyCount+1
			if(invIsEmptyCount=1)
			{
				openSheet(itemType_Valuable)
			}
			if (CtrlMoveItem(inv_start_x + i*disp + 10,inv_start_y + j*disp + 10)=0)
			{
				MsgBox "error,valuable sheet is full"
			}
		}
		j:=j+1
		if(j=5)
		{
			j:=0
			i:=i+1
		}
	}
}
CheckEmptyByAxis(x,y)
{
	return CheckColorRGB(x,y,0x101010)
}
;check if item exist by clipboard
CheckItemInfo(x,y)
{
	MouseMove x,y
	Sleep,5
	clipboard =		;clear clipboard
	Send ^c
	if(not clipboard="")	;item exist
	{
		return true
	}
	return false
}
openStash()
{	
	global
	ColorClick(chest_x,chest_y,chest_close_x,chest_close_y,chest_close_cc,true,500)
}
openVendor()
{
	global
	ColorClickDiff(vendor_x,vendor_y,vendor_check_x,vendor_check_y,vendor_check_cc,true,500)
	ColorClick(vendor_sell_x,vendor_sell_y,vendor_accept_x,vendor_accept_y,vendor_accept_cc,true,500)
}
vendorDeal()
{
	global
	ColorClick(vendor_accept_x,vendor_accept_y,vendor_accept_x,vendor_accept_y,vendor_accept_cc,false,500)
}