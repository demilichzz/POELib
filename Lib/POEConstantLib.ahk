POEConstantLib_constantDefine()
{
	global
	;constant define start
	;
	stash_start_x := 16+13
	stash_start_y := 161+13
	stash_end_x := 648
	stash_end_y := 793
	inv_start_x := 1296		;player inventory leftup grid
	inv_start_y := 615
	disp := 52.5
	;for open stash tab
	tablist_x := 641
	tablist_y := 145
	tablist_color := 0x57300B	;show tablist button
	currency_x := 662
	currency_y := 811
	currency_color_1 := 0x030201
	currency_color_2 := 0x050302
	currency_color_3 := 0x030201	;check tablist opened
	currency_color_list := Array(currency_color_1,currency_color_2,currency_color_3)
	tab_start_x := 800
	tab_start_y := 134		;first tab loc
	tab_disp_y := 22
	current_page := 0
	scroll_start_x := 881
	scroll_start_y := 217
	scroll_disp := 130
	scroll_color := 0x000000
	;for auto vendor
	chest_x := 1018
	chest_y := 506
	chest_close_x := 630
	chest_close_y := 68
	chest_close_cc := 0x030704
	vendor_x := 830
	vendor_y := 454
	vendor_sell_x := 922
	vendor_sell_y := 338
	vendor_sell_cc := 0x5F5A46
	vendor_check_x := 928
	vendor_check_y := 19
	vendor_check_cc := 0xE3D7A6
	vendor_accept_x := 355
	vendor_accept_y := 820
	vendor_accept_cc := 0xFEC076
	div := 24
	y_repeat := 24
	x_repeat := 24
	;sheet no.
	itemType_C:=99	;can't set to 0
	itemType_D:=1
	itemType_E:=2
	itemType_Temp:=4
	itemType_Valuable:=3
	itemType_M:=9
	itemType_Misc:=10
	itemType_Gem:=11
	itemType_VaalGem:=12
	itemType_Flasks:=13
	itemType_Ring:=31
	itemType_Amu:=32
	itemType_Belt:=33
	itemType_Glove:=34
	itemType_Helm:=35
	itemType_Shoe:=36
	itemType_Body:=37
	itemType_2H:=38
	itemType_TempCurrency:=39
	itemType_GloveBak:=40
	itemType_HelmBak:=41
	itemType_ShoeBak:=42
	itemType_BodyBak:=43
	itemType_2HBak:=44
	itemType_Delve:=15
	itemType_Shard:=16
	
	itemType_Jewel:=17
	itemType_ClusterJewel:=18
	itemType_SpecialBase:=64
	itemType_TempTrashNormal:=20
	itemType_TempTrashRare:=21
	itemType_TempTrash1:=22
	itemType_TempTrash2:=23
	itemType_TempTrash3:=24
	itemType_TempTrash4:=25
	itemType_UniqueTemp1:=26
	itemType_UniqueTemp2:=27
	itemType_UniqueTemp3:=28
	itemType_Veiled:=29
	itemType_UniqueCollect:=30
	itemType_Sample:=57
	itemType_Oil:=58
	itemType_Enchanted:=59
	itemType_HighQGem:=61
	itemType_Prophecy:=62
	itemType_CraftBase:=19
	
	itemType_ValuableJewel:=78
	itemType_CobaltJewel:=80
	;
	
	;craft
	currency_list := Object()
	currency_list["trans"] := [40,310,0x22334F]
	currency_list["alter"] := [100,310,0x419192]
	currency_list["aug"] := [220,365,0x282935]
	currency_list["regal"] := [415,310,0x43658C]
	currency_list["scour"] := [160,490,0x8F9193]
	craft_item_x := 332
	craft_item_y := 475
	craft_magic_list := Object()
	craft_rare_list := Object()
	craft_ensure_list := Object()
	match_min_attrib_magic := 0
	match_min_attrib_rare := 0
	match_mode := 0
	;
	
	;for analyzer
	modifer_count := 30 	;check modifer count
	modifer_match_array := Object()
	modifer_match_array[1] := ("+# to maximum Life")
	modifer_match_array[2] := ("#% increased Rarity of Items found")
	modifer_match_array[3] := ("+#% to Fire Resistance")
	modifer_match_array[4] := ("+#% to Cold Resistance")
	modifer_match_array[5] := ("+#% to Lightning Resistance")
	modifer_match_array[6] := ("+#% to Chaos Resistance")
	modifer_match_array[7] := ("#% increased Movement Speed")
	modifer_match_array[8] := ("+# to Strength")
	modifer_match_array[9] := ("+# to Dexterity")
	modifer_match_array[10] := ("+# to Intelligence")
	modifer_match_array[11] := ("+# to Level of Socketed Minion Gems")
	modifer_match_array[12] := ("+#% to all Elemental Resistances")
	modifer_match_array[13] := ("+# to all Attributes")
	modifer_match_array[14] := ("#% of Physical Attack Damage Leeched as Life")
	modifer_match_array[15] := ("#% of Physical Attack Damage Leeched as Mana")
	modifer_match_array[16] := ("#% increased Global Critical Strike Chance")
	modifer_match_array[17] := ("+#% to Global Critical Strike Multiplier")
	modifer_match_array[18] := ("#% increased Attack Speed")
	modifer_match_array[19] := ("#% increased Cast Speed")
	modifer_match_array[20] := ("+# Life gained for each Enemy hit by your Attacks")
	modifer_match_array[21] := ("#% increased Elemental Damage with Attack Skills")
	modifer_match_array[22] := ("#% increased Flask Effect Duration")
	modifer_match_array[23] := ("#% increased Flask Charges gained")
	modifer_match_array[24] := ("#% reduced Flask Charges used")
	modifer_match_array[25] := ("+#% to Fire and Lightning Resistances")
	modifer_match_array[26] := ("+#% to Fire and Cold Resistances")
	modifer_match_array[27] := ("+#% to Cold and Lightning Resistances")
	modifer_match_array[28] := ("+# to Strength and Intelligence")
	modifer_match_array[29] := ("+# to Strength and Dexterity")
	modifer_match_array[30] := ("+# to Dexterity and Intelligence")
	weight_list := Object()
	weight_list[1] := 1		;life
	weight_list[2] := 0.7	;rarity
	weight_list[3] := 0.5	;elemental resistant
	weight_list[4] := 0.5
	weight_list[5] := 0.5
	weight_list[6] := 0.4	;chaos resistant
	weight_list[7] := 1		;movement speed
	weight_list[8] := 0.5	;str
	weight_list[9] := 0.25	;dex
	weight_list[10] := 0.25	;int
	weight_list[11]:= 100	;minion level
	weight_list[12] := 1.5	;all res
	weight_list[13] := 1	;all attirbutes
	weight_list[14] := 30	;life leech
	weight_list[15] := 30	;mana leech
	weight_list[16] := 1	;cri chance
	weight_list[17] := 1	;cri multi
	weight_list[18] := 4	;atk speed
	weight_list[19] := 4	;cast speed
	weight_list[20] := 5	;gain life by hit
	weight_list[21] := 0.7	;EDwAS
	weight_list[22] := 1.5	;flask duration
	weight_list[23] := 1.5	;flask charge gain
	weight_list[24] := 1.5	;flask used reduce
	weight_list[25] := 1	;Fire and Lightning Resistances
	weight_list[26] := 1	;Fire and Cold Resistances
	weight_list[27] := 1	;Cold and Lightning Resistances
	weight_list[28] := 0.75	;Strength and Intelligence
	weight_list[29] := 0.75	;Strength and Dexterity
	weight_list[30] := 0.5	;Dexterity and Intelligence
	
	mod_group_jewel := Object()
	mod_group_jewel_ES:=1
	mod_group_jewel_BASE_DEF:=2
	mod_group_jewel_MANA:=3
	mod_group_jewel_SPELL_DAMAGE:=4
	mod_group_jewel_RESIST:=5
	mod_group_jewel_CHAOS_DAMAGE:=6
	mod_group_jewel_BASE_ATTRIB:=7
	mod_group_jewel_1H_ATK:=8
	mod_group_jewel_2H_ATK:=9
	mod_group_jewel_COMMON_ATK:=10
	mod_group_jewel_MISC:=11
	mod_group_jewel[mod_group_jewel_ES]:=Object()
	mod_group_jewel[mod_group_jewel_BASE_DEF]:=Object()
	mod_group_jewel[mod_group_jewel_MANA]:=Object()
	mod_group_jewel[mod_group_jewel_SPELL_DAMAGE]:=Object()
	mod_group_jewel[mod_group_jewel_RESIST]:=Object()
	mod_group_jewel[mod_group_jewel_CHAOS_DAMAGE]:=Object()
	mod_group_jewel[mod_group_jewel_BASE_ATTRIB]:=Object()
	mod_group_jewel[mod_group_jewel_1H_ATK]:=Object()
	mod_group_jewel[mod_group_jewel_2H_ATK]:=Object()
	mod_group_jewel[mod_group_jewel_COMMON_ATK]:=Object()
	mod_group_jewel[mod_group_jewel_MISC]:=Object()
	;------ENERGY SHIELD------
	mod_group_jewel[mod_group_jewel_ES][1]:=["#% increased maximum Energy Shield",6]
	mod_group_jewel[mod_group_jewel_ES][2]:=["# to maximum Energy Shield",26]
	;------BASE DEF--------
	mod_group_jewel[mod_group_jewel_BASE_DEF][1]:=["#% increased maximum Life",5]
	mod_group_jewel[mod_group_jewel_BASE_DEF][2]:=["#% increased maximum Energy Shield",6]
	mod_group_jewel[mod_group_jewel_BASE_DEF][3]:=["# to maximum Energy Shield",26]
	mod_group_jewel[mod_group_jewel_BASE_DEF][4]:=["# to maximum Life",26]
	;------MANA-----------
	mod_group_jewel[mod_group_jewel_MANA][1]:=["#% increased maximum Mana",8]
	mod_group_jewel[mod_group_jewel_MANA][2]:=["# to maximum Mana",26]
	;------SPELL DAMAGE--------
	mod_group_jewel[mod_group_jewel_SPELL_DAMAGE][1]:=["#% to Critical Strike Multiplier with Cold Skills",15]
	mod_group_jewel[mod_group_jewel_SPELL_DAMAGE][2]:=["#% to Critical Strike Multiplier with Lightning Skills",15]
	mod_group_jewel[mod_group_jewel_SPELL_DAMAGE][3]:=["#% to Critical Strike Multiplier for Spells",12]
	mod_group_jewel[mod_group_jewel_SPELL_DAMAGE][4]:=["#% to Critical Strike Multiplier with Elemental Skills",12]
	;------RESIST-------------
	mod_group_jewel[mod_group_jewel_RESIST][1]:=["#% to Fire and Cold Resistances",10]
	mod_group_jewel[mod_group_jewel_RESIST][2]:=["#% to Fire and Lightning Resistances",10]
	mod_group_jewel[mod_group_jewel_RESIST][3]:=["#% to Cold and Lightning Resistances",10]
	mod_group_jewel[mod_group_jewel_RESIST][4]:=["#% to all Elemental Resistances",8]
	mod_group_jewel[mod_group_jewel_RESIST][5]:=["#% to Chaos Resistance",8]
	;------CHAOS--------------
	mod_group_jewel[mod_group_jewel_CHAOS_DAMAGE][1]:=["#% to Chaos Damage over Time Multiplier",3]
	mod_group_jewel[mod_group_jewel_CHAOS_DAMAGE][2]:=["#% increased Chaos Damage",9]
	mod_group_jewel[mod_group_jewel_CHAOS_DAMAGE][3]:=["#% increased Damage over Time",10]
	;------BASE ATTRIB--------
	mod_group_jewel[mod_group_jewel_BASE_ATTRIB][1]:=["# to Strength and Dexterity",8]
	mod_group_jewel[mod_group_jewel_BASE_ATTRIB][2]:=["# to Strength and Intelligence",8]
	mod_group_jewel[mod_group_jewel_BASE_ATTRIB][3]:=["# to Dexterity and Intelligence",8]
	mod_group_jewel[mod_group_jewel_BASE_ATTRIB][4]:=["# to all Attributes",6]
	;------1H ATK------
	mod_group_jewel[mod_group_jewel_1H_ATK][1]:=["#% increased Attack Speed with Swords",6]
	mod_group_jewel[mod_group_jewel_1H_ATK][2]:=["#% increased Attack Speed with One Handed Melee Weapons",6]
	mod_group_jewel[mod_group_jewel_1H_ATK][3]:=["#% increased Attack Speed while Dual Wielding",6]
	mod_group_jewel[mod_group_jewel_1H_ATK][4]:=["#% increased Attack Speed while holding a Shield",6]
	mod_group_jewel[mod_group_jewel_1H_ATK][5]:=["#% to Critical Strike Multiplier with One Handed Melee Weapons",15]
	mod_group_jewel[mod_group_jewel_1H_ATK][6]:=["#% to Critical Strike Multiplier while Dual Wielding",15]
	;------2H ATK-----
	mod_group_jewel[mod_group_jewel_2H_ATK][1]:=["#% increased Attack Speed with Two Handed Melee Weapons",6]
	mod_group_jewel[mod_group_jewel_2H_ATK][2]:=["#% to Critical Strike Multiplier with Two Handed Melee Weapons",15]
	;------COMMON ATK------
	mod_group_jewel[mod_group_jewel_COMMON_ATK][1]:=["#% to Global Critical Strike Multiplier",9]
	mod_group_jewel[mod_group_jewel_COMMON_ATK][2]:=["#% increased Attack Speed if you've dealt a Critical Strike Recently",6]
	;------MISC-------
	mod_group_jewel[mod_group_jewel_MISC][1]:=["# Life gained for each Enemy hit by your Attacks",2]
	mod_group_jewel[mod_group_jewel_MISC][2]:=["# Energy Shield gained for each Enemy hit by your Attacks",2]
	mod_group_jewel[mod_group_jewel_MISC][3]:=["#% increased Movement Speed if you've Killed Recently",4]
	mod_group_jewel[mod_group_jewel_MISC][4]:=["#% chance to Gain Unholy Might for 4 seconds on Melee Kill",4]
	mod_group_jewel[mod_group_jewel_MISC][5]:=["#% chance to gain Phasing for # seconds on Kill",6]
	;constant define end
	;
}