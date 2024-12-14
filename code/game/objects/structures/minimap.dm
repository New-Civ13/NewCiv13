/obj/structure/sign/map
	name = "area map"
	desc = "A detailed area map for planning operations."
	icon_state = "areamap"
	var/image/img
	var/list/overlay_list = list()
/obj/structure/sign/map/New()
	..()
	img = image(icon = 'icons/minimaps.dmi', icon_state = "minimap")

/obj/structure/sign/map/examine(mob/user)
	user << browse(getFlatIcon(img),"window=popup;size=630x630")

/obj/structure/sign/map/attackby(obj/item/I as obj, mob/user as mob)
	if (istype(I, /obj/item/weapon/pen))
		var/nr = ""
		var/ico_dir = 2
		var/c_color = WWinput(user,"Which color do you want to use?","Color","Cancel",list("Cancel","White","Red","Green","Yellow","Blue"))
		switch(c_color)
			if ("Cancel")
				return
			if ("White")
				c_color = COLOR_WHITE
			if ("Red")
				c_color = COLOR_RED
			if ("Green")
				c_color = COLOR_GREEN
			if ("Yellow")
				c_color = COLOR_YELLOW
			if ("Blue")
				c_color = COLOR_BLUE
		var/c_icon = WWinput(user,"Which icon do you want to use?","Icon","Cancel",list("Cancel","Circle","X","Arrow","Number"))
		switch(c_icon)
			if ("Cancel")
				return
			if ("Circle")
				c_icon = "map_circle"
			if ("X")
				c_icon = "map_x"
			if ("Arrow")
				c_icon = "map_arrow"
				ico_dir = WWinput(user,"Choose a direction:","Number","Cancel",list("Cancel","North","South","East","West","Northeast","Northwest","Southeast","Southwest"))
				if (ico_dir == "Cancel")
					return
				else
					ico_dir = text2dir(ico_dir)
			if ("Number")
				nr = WWinput(user,"Choose a number:","Number","Cancel",list("Cancel","1","2","3","4","5","6","7","8","9"))
				if (nr == "Cancel")
					return
				else
					c_icon = "map_number_[nr]"
		var/x_dist = 0
		var/y_dist = 0
		var/c_location = WWinput(user,"Where do you want to place it (column)?","Location","Cancel",list("Cancel","A","B","C","D","E","F","G","H","I","J"))
		var/c_location2 = WWinput(user,"Where do you want to place it (line)?","Location","Cancel",list("Cancel","1","2","3","4","5","6","7","8","9","10"))
		y_dist = 600-(text2num(c_location2)*60)
		switch(c_location)
			if ("A")
				x_dist = 0
			if ("B")
				x_dist = 60*1
			if ("C")
				x_dist = 60*2
			if ("D")
				x_dist = 60*3
			if ("E")
				x_dist = 60*4
			if ("F")
				x_dist = 60*5
			if ("G")
				x_dist = 60*6
			if ("H")
				x_dist = 60*7
			if ("I")
				x_dist = 60*8
			if ("J")
				x_dist = 60*9
		var/image/symbol_ico = image(icon='icons/minimap_effects.dmi', icon_state = c_icon, dir=ico_dir, layer=src.layer+1)
		symbol_ico.pixel_x = x_dist
		symbol_ico.pixel_y = y_dist
		symbol_ico.color = c_color
		overlay_list+=symbol_ico
		img.overlays += symbol_ico
		return
	else
		..()

/obj/structure/sign/map/verb/clear()
	set name = "Clear"
	set category = null
	set src in oview(1)

	if (!ishuman(usr))
		return
	usr << "You clear the map."
	overlay_list = list()
	img.overlays.Cut()

/obj/structure/sign/map/update_icon()
	..()
	img.overlays.Cut()
	for (var/image/I in overlay_list)
		img.overlays += I

/obj/structure/sign/map/attack_hand(mob/user)
	examine(user)

//////////////////////////////////////////

/obj/item/weapon/map
	desc = "A portable map of the area."
	name = "folding map"
	icon = 'icons/obj/decals.dmi'
	icon_state = "portable_areamap"
	item_state = "map"
	var/image/img
	var/image/playerloc
	throwforce = WEAPON_FORCE_HARMLESS
	force = WEAPON_FORCE_HARMLESS
	w_class = ITEM_SIZE_TINY
	flags = FALSE

/obj/item/weapon/map/New()
	img = image(icon = 'icons/minimaps.dmi', icon_state = "minimap")
	playerloc = image(icon = 'icons/effects/mapeffects.dmi', icon_state = "whiteandred",layer=src.layer+1)

/obj/item/weapon/map/examine(mob/user)
	update_icon()
	user << browse(getFlatIcon(img),"window=popup;size=630x630")

/obj/item/weapon/map/update_icon()
	..()
	img.overlays.Cut()
	var/turf/T = get_turf(src) // We use a macro and RU-CIV uses a proc for get_turf() so we must assign a var for direct-access.
	playerloc.pixel_x = min(600, ceil(T.x * 2.72))
	playerloc.pixel_y = min(600, ceil(T.y * 2.72))
	img.overlays += playerloc

/obj/item/weapon/map/attack_self(mob/user)
	update_icon()
	examine(user)

/obj/item/weapon/map_tdm
	icon = 'icons/obj/decals.dmi'
	icon_state = "portable_areamap"
	throwforce = WEAPON_FORCE_HARMLESS
	force = WEAPON_FORCE_HARMLESS
	w_class = ITEM_SIZE_TINY
	flags = FALSE
	var/image/img
	var/x_scale = 1 // (To be counted as such: 600/world.maxx)
	var/y_scale = 1 // (To be counted as such: 600/world.maxy)

/obj/item/weapon/map_tdm/examine(mob/living/human/user)
	if (!img || !user.Adjacent(src))
		..()
		return
	img.overlays.Cut()
	if (map.fob_spawns)
		for (var/obj/structure/fob_spawnpoint/F in world)
			if (F.faction_text == user.faction_text)
				var/turf/T = get_turf(F)
				var/image/fob_loc = image(icon = 'icons/effects/mapeffects.dmi', icon_state = "whiteandblue",layer=src.layer+1)
				fob_loc.pixel_x = min(600,ceil(T.x*x_scale))
				fob_loc.pixel_y = min(600,ceil(T.y*y_scale))
				img.overlays += fob_loc
	var/image/playerloc = image(icon = 'icons/effects/mapeffects.dmi', icon_state = "yellowdot",layer=src.layer+1)
	var/turf/T = get_turf(user)
	playerloc.pixel_x = min(600,ceil(T.x*x_scale))
	playerloc.pixel_y = min(600,ceil(T.y*y_scale))
	img.overlays += playerloc
	user << browse(getFlatIcon(img),"window=popup;size=630x630")

/obj/item/weapon/map_tdm/attack_self(mob/user)
	examine(user)

/obj/item/weapon/map_tdm/abashiri/New()
	desc = "A portable map of Abashiri Prison."
	name = "abashiri prison map"
	img = image(icon = 'icons/minimaps.dmi', icon_state = "abashiri_map")

/obj/item/weapon/map_tdm/sovafghan/New()
	desc = "A portable map of the Kandahar region."
	name = "Kandahar region map"
	img = image(icon = 'icons/minimaps.dmi', icon_state = "sovafghan_map")

/obj/item/weapon/map_tdm/clash/New()
	desc = "The Bear clan king has drawn battle plan on an area map."
	name = "Area map"
	img = image(icon = 'icons/minimaps.dmi', icon_state = "clash_map")

/obj/item/weapon/map_tdm/operation_falcon/New()
	desc = "A folding map of the area of operations."
	name = "area map"
	img = image(icon = 'icons/minimaps.dmi', icon_state = "operation_falcon_map")

///MAP BOARD///

/obj/structure/sign/map_board
	name = "map of the area"
	desc = "A large board with the map of the area."
	icon_state = "map_board"
	density = TRUE
	var/image/img
	var/list/stored_img = list()
	var/x_scale = 1 // (To be counted as such: 600/world.maxx)
	var/y_scale = 1 // (To be counted as such: 600/world.maxy)

/obj/structure/sign/map_board/New()
	..()
	switch (map.ID)
		if (MAP_KANDAHAR)
			img = image(icon = 'icons/minimaps.dmi', icon_state = "sovafghan_map")
			x_scale = 2.31
			y_scale = 2
		if (MAP_OPERATION_FALCON)
			img = image(icon = 'icons/minimaps.dmi', icon_state = "operation_falcon_map")
			x_scale = 1.5
			y_scale = 1.5

/obj/structure/sign/map_board/examine(mob/user)
	if (!img)
		..()
		return
	img.overlays.Cut()
	stored_img = list()
	if (map.fob_spawns)
		for (var/obj/structure/fob_spawnpoint/F in world)
			var/mob/living/human/H = user
			if (F.faction_text == H.faction_text)
				var/turf/T = get_turf(F)
				var/image/fob_loc = image(icon = 'icons/effects/mapeffects.dmi', icon_state = "whiteandblue",layer=src.layer+1)
				fob_loc.pixel_x = min(600,ceil(T.x*1.5))
				fob_loc.pixel_y = min(600,ceil(T.y*1.5))
				img.overlays += fob_loc
				stored_img += fob_loc
	for (var/mob/living/human/H in human_mob_list)
		var/mob/living/human/U = user
		if (H != U && H.faction_text == U.faction_text && H.stat != DEAD)
			var/turf/T = get_turf(H)
			var/image/allied_loc = image(icon = 'icons/effects/mapeffects.dmi', icon_state = "greendot",layer=src.layer+1.1)
			allied_loc.pixel_x = min(600,ceil(T.x*x_scale))
			allied_loc.pixel_y = min(600,ceil(T.y*y_scale))
			img.overlays += allied_loc
			stored_img += allied_loc
	var/turf/TT = get_turf(user)
	var/image/self_loc = image(icon = 'icons/effects/mapeffects.dmi', icon_state = "yellowdot",layer=src.layer+1.1)
	self_loc.pixel_x = min(600,ceil(TT.x*x_scale))
	self_loc.pixel_y = min(600,ceil(TT.y*y_scale))
	img.overlays += self_loc
	stored_img += self_loc
	user << browse(getFlatIcon(img),"window=popup;size=630x630")

/obj/structure/sign/map_board/attack_hand(mob/user)
	examine(user)

/obj/structure/sign/map_board/grozny/New()
	..()
	img = image(icon = 'icons/minimaps.dmi', icon_state = "grozny_map")

/obj/structure/sign/map_board/falcon_artillery_ru/New()
	..()
	img = image(icon = 'icons/minimaps.dmi', icon_state = "operation_falcon_map_artillery_ru")

/obj/structure/sign/map_board/falcon_artillery_du/New()
	..()
	img = image(icon = 'icons/minimaps.dmi', icon_state = "operation_falcon_map_artillery_du")