/// 313 EPOCH doors ///

#define AN_CODE 1000

/obj/item/weapon/key/ancient
	name = "\improper Ancient Key"
	code = AN_CODE

/obj/structure/door/key/ancient
	name = "\improper Ancient door"
	custom_code = AN_CODE
#undef AN_CODE

#define AN_CODE2_ROMAN 11546

/obj/item/weapon/key/ancient/roman
	code = AN_CODE2_ROMAN
	name = "\improper Roman Fortress Key"

/obj/structure/door/key/ancient/roman
	name = "\improper Roman Fortress door"
	custom_code = AN_CODE2_ROMAN
#undef AN_CODE2_ROMAN

#define AN_CODE3_GREEK 11311
/obj/item/weapon/key/ancient/greek
	code = AN_CODE3_GREEK
	name = "\improper Greek Fortress Key"

/obj/structure/door/key/ancient/greek
	name = "\improper Greek Fortress door"
	custom_code = AN_CODE3_GREEK
#undef AN_CODE3_GREEK


/// 1713 EPOCH doors ///

#define CV_CUSTOM 999
/obj/structure/door/key/custom
	custom = TRUE
	custom_code = 999
	name = "\improper Private door"
#undef CV_CUSTOM





#define CV_CUSTOM_WOODJAIL 999
/obj/structure/door/key/jail/wood
	custom = TRUE
	custom_code = 999
	name = "\improper Private door"
	opacity = 0
#undef CV_CUSTOM_WOODJAIL





#define CV_CUSTOM_STEELJAIL 999
/obj/structure/door/key/jail/steel
	custom = TRUE
	custom_code = 999
	name = "\improper Private door"
	opacity = 0
#undef CV_CUSTOM_STEELJAIL





#define CV_CODE 1000
/obj/item/weapon/key/civ
	code = CV_CODE

/obj/structure/door/key/civ
	custom_code = CV_CODE
#undef CV_CODE




#define CV_CODE_HALL 11546
/obj/item/weapon/key/civ/hall
	code = CV_CODE_HALL
	name = "\improper Guard's Key"

/obj/structure/door/key/civ/hall
	name = "\improper Colony Hall"
	custom_code = CV_CODE_HALL
#undef CV_CODE_HALL





#define CV_CODE_GOV 11311
/obj/item/weapon/key/civ/gov
	code = CV_CODE_GOV
	name = "\improper Leader's Key"

/obj/structure/door/key/civ/gov
	name = "\improper Governor's Office"
	custom_code = CV_CODE_GOV
#undef CV_CODE_GOV





#define CV_ROOM1 12311
/obj/item/weapon/key/civ/room1
	code = CV_ROOM1
	name = "\improper Room #1 Key"

/obj/structure/door/key/civ/room1
	name = "Room #1"
	custom_code = CV_ROOM1
#undef CV_ROOM1







#define CV_ROOM2 22322
/obj/item/weapon/key/civ/room2
	code = CV_ROOM2
	name = "\improper Room #2 Key"

/obj/structure/door/key/civ/room2
	name = "Room #2"
	custom_code = CV_ROOM2
#undef CV_ROOM2





#define CV_ROOM3 32333
/obj/item/weapon/key/civ/room3
	code = CV_ROOM3
	name = "\improper Room #3 Key"

/obj/structure/door/key/civ/room3
	name = "Room #3"
	custom_code = CV_ROOM3
#undef CV_ROOM3





#define CV_ROOM4 42344
/obj/item/weapon/key/civ/room4
	code = CV_ROOM4
	name = "\improper Room #4 Key"

/obj/structure/door/key/civ/room4
	name = "Room #4"
	custom_code = CV_ROOM4
#undef CV_ROOM4





#define CV_ROOM5 52355
/obj/item/weapon/key/civ/room5
	code = CV_ROOM5
	name = "\improper Room #5 Key"

/obj/structure/door/key/civ/room5
	name = "Room #5"
	custom_code = CV_ROOM5
#undef CV_ROOM5







#define CV_ROOM6 62366
/obj/item/weapon/key/civ/room6
	code = CV_ROOM6
	name = "\improper Room #6 Key"

/obj/structure/door/key/civ/room6
	name = "Room #6"
	custom_code = CV_ROOM6
#undef CV_ROOM6









#define CV_ROOM7 72377
/obj/item/weapon/key/civ/room7
	code = CV_ROOM7
	name = "\improper Room #7 Key"

/obj/structure/door/key/civ/room7
	name = "Room #7"
	custom_code = CV_ROOM7
#undef CV_ROOM7






#define CV_ROOM8 82388
/obj/item/weapon/key/civ/room8
	code = CV_ROOM8
	name = "\improper Room #8 Key"

/obj/structure/door/key/civ/room8
	name = "Room #8"
	custom_code = CV_ROOM8
#undef CV_ROOM8







#define CV_INN 82111
/obj/item/weapon/key/civ/inn
	code = CV_INN
	name = "\improper Private Inn Key"

/obj/structure/door/key/civ/inn
	name = "\improper Inn"
	custom_code = CV_INN

/obj/structure/door/key/jail/steel/inn
	locked = TRUE
	custom_code = CV_INN

/obj/structure/closet/crate/cash_register/inn
	name = "\improper Inn till"
	icon = 'icons/obj/modern_structures.dmi'
	icon_state = "cash_register_antique"
	icon_opened = "cash_register_antique_opened"
	icon_closed = "cash_register_antique"
	custom_code = CV_INN
	locked = TRUE
/obj/structure/closet/cabinet/ceiling/liquer
	name = "\improper Liquer cabinet"
	custom_code = CV_INN
	locked = TRUE
#undef CV_INN




/obj/item/weapon/key/civ/businessred
	color = "#ff0000"

/obj/item/weapon/key/civ/businessred
	code = AOTD_REDCODE
	name = "\improper Headquarter's door-key"
/obj/item/weapon/key/civ/businessred/ceo
	code = AOTD_REDCODE+9
	name = "\improper CEO key"




/obj/structure/door/key/civ/businessred
	name = "Red's Headquarters (door)"
	custom_code = AOTD_REDCODE

/obj/structure/door/key/civ/businessred/ceo
	name = "\improper Red CEO's door"
	custom_code = AOTD_REDCODE+9



/obj/item/weapon/key/civ/businessblue
	color = "#0000FF"
/obj/item/weapon/key/civ/businessblue
	code = AOTD_BLUECODE
	name = "\improper Headquarter's door-key"
/obj/item/weapon/key/civ/businessblue/ceo
	code = AOTD_BLUECODE+9
	name = "\improper CEO key"





/obj/structure/door/key/civ/businessblue
	name = "Blue's Headquarters (door)"
	custom_code = AOTD_BLUECODE
/obj/structure/door/key/civ/businessblue/ceo
	name = "\improper Blue CEO's door"
	custom_code = AOTD_BLUECODE+9


/obj/item/weapon/key/civ/businessgreen
	color = "#008000"
/obj/item/weapon/key/civ/businessgreen
	code = AOTD_GREENCODE
	name = "\improper Headquarter's door-key"

/obj/item/weapon/key/civ/businessgreen/ceo
	code = AOTD_GREENCODE+9
	name = "\improper CEO key"






/obj/structure/door/key/civ/businessgreen
	name = "Green's Headquarters (door)"
	custom_code = AOTD_GREENCODE
/obj/structure/door/key/civ/businessgreen/ceo
	name = "\improper Green CEO's door"
	custom_code = AOTD_GREENCODE+9





/obj/item/weapon/key/civ/businessyellow
	color = "#FFFF00"
/obj/item/weapon/key/civ/businessyellow
	code = AOTD_YELLOWCODE
	name = "\improper Headquarter's door-key"
/obj/item/weapon/key/civ/businessyellow/ceo
	code = AOTD_YELLOWCODE+9
	name = "\improper CEO key"




/obj/structure/door/key/civ/businessyellow
	name = "Yellow's Headquarters (door)"
	custom_code = AOTD_YELLOWCODE
/obj/structure/door/key/civ/businessyellow/ceo
	name = "\improper Yellow CEO's door"
	custom_code = AOTD_YELLOWCODE+9




#define CV_BANK 82111
/obj/item/weapon/key/civ/bank
	code = CV_BANK
	name = "\improper Bank key"

/obj/structure/door/key/civ/bank
	name = "\improper Bank door"
	custom_code = CV_BANK
#undef CV_BANK






#define CV_SHERIFF 42111
/obj/item/weapon/key/civ/sheriff
	code = CV_SHERIFF
	name = "\improper Sheriff's Office key"

/obj/structure/door/key/civ/sheriff
	name = "\improper Sheriff's Office door"
	custom_code = CV_SHERIFF
#undef CV_SHERIFF




#define PI_CODE 995
/obj/item/weapon/key/pirates
	code = PI_CODE
	name = "\improper Pirate key"

/obj/structure/door/key/pirates
	name = "\improper Pirate door"
	custom_code = PI_CODE
#undef PI_CODE







#define RN_CODE 995 * 2
/obj/item/weapon/key/british
	code = RN_CODE
	name = "\improper British key"

/obj/structure/door/key/british
	name = "\improper British door"
	custom_code = RN_CODE
#undef RN_CODE




#define SP_CODE 995 * 3
/obj/item/weapon/key/spanish
	code = SP_CODE
	name = "\improper Spanish Key"

/obj/structure/door/key/spanish
	name = "\improper Spanish door"
	custom_code = SP_CODE
#undef SP_CODE



#define FR_CODE 995 * 4
/obj/item/weapon/key/french
	code = FR_CODE
	name = "\improper French key"

/obj/structure/door/key/french
	name = "\improper French door"
	custom_code = FR_CODE
#undef FR_CODE

#define PT_CODE 995 * 5
/obj/item/weapon/key/portuguese
	code = PT_CODE
	name = "\improper Portuguese key"

/obj/structure/door/key/portuguese
	name = "\improper Portuguese door"
	custom_code = PT_CODE
#undef PT_CODE

#define RU_CODE 995 * 5
/obj/item/weapon/key/russian
	code = RU_CODE
	name = "\improper Russian key"

/obj/structure/door/key/russian
	name = "\improper Russian door"
	custom_code = RU_CODE

/obj/item/weapon/key/soviet
	code = RU_CODE
	name = "\improper Soviet key"

/obj/item/weapon/key/soviet/guard
	code = RU_CODE
	name = "\improper GULAG guard key"
	health = 90000
/obj/item/weapon/key/soviet/guard/max
	code = RU_CODE+2
	name = "\improper Maximum Security guard key"
/obj/item/weapon/key/soviet/guard/max/command
	code = RU_CODE+8
	name = "\improper Maximum Security commander key"

/obj/structure/door/key/soviet
	material = "iron"
	name = "\improper Soviet door"
	custom_code = RU_CODE

/obj/structure/door/key/soviet/guard
	name = "\improper GULAG chain-linked door"
	custom_code = RU_CODE
/obj/structure/door/key/soviet/guard/chainlink
	icon_state = "chainlink"
	base_icon_state = "chainlink"
	override_opacity = TRUE // This can be seen through.
	override_material = TRUE // This has a custom icon.
	open_sound = 'sound/machines/click.ogg'
	close_sound = 'sound/machines/click.ogg'
	opacity = FALSE

/obj/structure/door/key/soviet/guard/max
	name = "\improper Maximum Security door"
	custom_code = RU_CODE+2
/obj/structure/door/key/soviet/guard/max/command
	name = "\improper Maximum Security - Command Only door"
/obj/structure/door/key/jail/steel/guard
	name = "\improper GULAG door"
	locked = TRUE
	custom_code = RU_CODE
/obj/structure/door/key/jail/steel/guard/max
	name = "\improper Maximum Security door"
	custom_code = RU_CODE+2
/obj/structure/door/key/jail/steel/guard/max/command
	name = "\improper Maximum Security - Command Only door"
	custom_code = RU_CODE+8

/obj/structure/door/key/jail/steel/guard/open
	locked = FALSE
	custom_code = RU_CODE
	New()
		..()
		icon_state = "cellopen"
		density = FALSE
#undef RU_CODE

#define NL_CODE 995 * 6
/obj/item/weapon/key/dutch
	code = NL_CODE
	name = "\improper Dutch key"

/obj/structure/door/key/dutch
	name = "\improper Dutch door"
	custom_code = NL_CODE
#undef NL_CODE



#define JP_CODE 995 * 6
/obj/item/weapon/key/japanese
	code = JP_CODE
	name = "\improper Japanese key"

/obj/structure/door/key/japanese
	name = "\improper Japanese door"
	custom_code = JP_CODE
#undef JP_CODE


#define JPABA_CODE 994 * 6
/obj/item/weapon/key/abashiri
	code = JPABA_CODE
	name = "\improper Abashiri Guard key"

/obj/structure/door/key/abashiri
	name = "\improper Abashiri door"
	custom_code = JPABA_CODE

/obj/item/weapon/key/abashiri/head
	code = JPABA_CODE + 2
	name = "\improper Abashiri Head Guard key"

/obj/structure/door/key/abashiri/head
	name = "\improper Abashiri Head Guard's door"
	custom_code = JPABA_CODE + 2
#undef JPABA_CODE

/obj/item/weapon/key/japanese/german////yeah ik i'm just lazy and already mapped so stfu bish
	name = "\improper German Officer key"

#define JP_OFF_CODE 995 * 7
/obj/item/weapon/key/japanese_officer
	code = JP_OFF_CODE
	name = "\improper Japanese Officer key"

/obj/structure/door/key/japanese_officer
	name = "\improper Japanese door"
	custom_code = JP_OFF_CODE
#undef JP_OFF_CODE

#define DE_CODE 995 * 12
/obj/item/weapon/key/german
	code = DE_CODE
	name = "\improper German key"

/obj/structure/door/key/german
	name = "\improper German door"
	custom_code = DE_CODE

/obj/structure/door/key/jail/steel/german
	name = "\improper German door"
	locked = TRUE
	custom_code = DE_CODE

/obj/structure/closet/crate/cash_register/germ
	icon = 'icons/obj/modern_structures.dmi'
	icon_state = "cash_register_antique"
	icon_opened = "cash_register_antique_opened"
	icon_closed = "cash_register_antique"
	custom_code = DE_CODE
	locked = TRUE
#undef DE_CODE

#define DE_CODE_OFF 995 * 1
/obj/item/weapon/key/german/officer
	code = DE_CODE_OFF
	name = "\improper German Officer key"

/obj/structure/door/key/german/officer
	name = "\improper German door"
	custom_code = DE_CODE_OFF
#undef DE_CODE_OFF

#define IT_CODE 995 * 24
/obj/item/weapon/key/italian
	code = IT_CODE
	name = "\improper Italian key"

/obj/structure/door/key/italian
	name = "\improper Italian door"
	custom_code = IT_CODE
#undef IT_CODE

#define VC_CODE 995 * 8
/obj/item/weapon/key/vietnamese
	code = VC_CODE
	name = "\improper Vietnamese key"

/obj/structure/door/key/vietnamese
	name = "\improper Vietnamese locked"
	custom_code = VC_CODE
#undef VC_CODE

#define CH_CODE 995 * 11
/obj/item/weapon/key/chinese
	code = CH_CODE
	name = "\improper Chinese key"

/obj/structure/door/key/chinese
	name = "\improper Chinese door"
	custom_code = CH_CODE
#undef CH_CODE

#define INS_CODE 995 * 9
/obj/item/weapon/key/insurgent
	code = INS_CODE
	name = "\improper Insurgent key"

/obj/structure/door/key/insurgent
	name = "\improper Insurgent door"
	custom_code = INS_CODE

/obj/structure/door/key/wood
	name = "\improper Insurgent wooden door"
	material = "wood"

#undef INS_CODE

#define US_CODE 995 * 10
/obj/item/weapon/key/american
	code = US_CODE
	name = "\improper American key"

/obj/item/weapon/key/american/facility
	desc = "A facility key."
	name = "\improper Facility key"

/obj/structure/door/key/american
	name = "\improper American door"
	custom_code = US_CODE
#undef US_CODE


/obj/item/weapon/key/civ/police
	code = 13443
	name = "\improper Police Officer key"
	health = 90000

/obj/item/weapon/key/civ/police/chief
	code = 13444
	name = "\improper Police Chief key"

/obj/structure/door/key/civ/police
	name = "\improper Police Station door"
	custom_code = 13443
	locked = TRUE

/obj/structure/door/key/civ/police/chief
	name = "\improper Police Chief's door"
	custom_code = 13444
	locked = TRUE

/obj/structure/door/key/jail/steel/police
	locked = TRUE
	custom_code = 13443

/obj/item/weapon/key/civ/paramedics
	code = 12443
	name = "\improper Hospital Key"
	health = 90000

/obj/structure/door/key/civ/paramedics
	name = "\improper Hospital door"
	custom_code = 12443
	locked = TRUE

/obj/item/weapon/key/civ/mechanic
	code = 12448
	name = "\improper Mechanic key"
	health = 2500

/obj/structure/door/key/civ/mechanic
	name = "\improper Mechanic's door"
	custom_code = 12448
	locked = TRUE

/obj/item/weapon/key/civ/mckellen
	code = 211919
	name = "\improper McKellen's key"

/obj/structure/door/key/civ/mckellen
	name = "\improper McKellen's door"
	custom_code = 211919
	locked = TRUE

/obj/item/weapon/key/civ/mckellen/manager
	code = 121922
	name = "\improper McKellen's Manager key"

/obj/structure/door/key/civ/mckellen/manager
	name = "\improper McKellen's Manager door"
	custom_code = 121922
	locked = TRUE

/obj/item/weapon/key/tribal
	code = 666999
	name = "\improper Tribal key"

/obj/structure/door/key/jail/wood/tribal
	name = "\improper Tribal door"
	custom_code = 666999
	locked = TRUE
