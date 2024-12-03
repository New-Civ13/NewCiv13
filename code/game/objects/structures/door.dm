////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// *** Blocking checks for doors.
/atom/movable/proc/blocks_door()
	return density

/obj/structure/door/blocks_door()
	return FALSE

/mob/living/blocks_door()
	return TRUE

/obj/structure/closet/body_bag/blocks_door()
	if (locate(/mob) in src)
		return TRUE // Prevents doors from closing on body-bags with people inside.
	return FALSE
// *** Blocking door checks END.

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/structure/door
	/// String. Keep this the same if you want the door's name to be "[material.display_name] door". Over-write it if you don't.
	name = "door"

	// desc - No description if it's not over-rided.
	icon = 'icons/obj/doors/material_doors.dmi'

	anchored = TRUE
	density = TRUE
	// opacity = TRUE (Determined in update_material, by checking the material's opacity~)
	not_movable = TRUE
	not_disassemblable = TRUE

	/// Boolean. Whether or not the door is locked, usually by a key.
	var/locked = FALSE
	/// String. (Usually a copy of `icon_state = *`). A stored copy of icon_state before we do some calculations and apply it to icon_state.
	var/base_icon_state

	/// Boolean. For customized door locks in roleplay (RP).
	var/custom = FALSE
	/// Boolean. For customized door locks in roleplay (RP).
	var/custom_code = FALSE

	var/material/material
	var/open_sound = 'sound/machines/door_open.ogg'
	var/close_sound = 'sound/machines/door_close.ogg'

	/// Integer (One of `DOOR_OPERATING_*`). The door's operating state.
	var/operating = DOOR_OPERATING_NO
	/// Integer. The minimum amount of force needed to damage a door with a melee weapon.
	var/min_force = 10
	/// The maximum health that the door can have, current_health is set to this if current_health is null. (Integer) (Helpful for VV-edits and knowing the max_health.)
	var/max_health = 400
	/// The current health of the door. Leave to null, unless you want the object to start at a different health than max_health. (Integer)
	var/current_health

	/// Boolean. To override certain doors from retrieving their material icon from /material/ datum, set TRUE for custom-sprited doors.
	var/override_material = FALSE
	/// Boolean. To override opacity on certain doors. TRUE will only make opacity FALSE during open/closes, you must still define opacity as FALSE.
	var/override_opacity = FALSE
	/// Boolean. To override the names of certain doors from retrieving their material name, for custom-named doors. *unused*.
	// var/override_name = FALSE

	/// Persistence variables to apply saved vars later.
	map_storage_saved_vars = "density;icon_state;dir;name;pixel_x;pixel_y;keycode;haslock;custom;custom_code;locked"
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/structure/door/New(newloc, material_name)
	if(!material_name) // I'd rather people use `door/wood`; not parent `structure/door`.
		if(material)
			material_name = material // If we set material instead of doing ..("mat") then add it.
		else
			CRASH("door/new; crashed with no material var set anywhere.")

	door_list += src
	if(!current_health) // To allow people to set damaged doors in mapping so it only changes this to max_health if it's null on creation.
		current_health = max_health
	..() // Any lighting related init.

	update_material(material_name) // Handles material_name; "wood", "iron", etc.

	spawn(0) // Scheduled to happen right after other existing events that are immediately pending.
		// This notifies any roofs in the surrounding atoms to not be transparent anymore.
		for(var/obj/roof/R in range(1, src))
			R.update_transparency(FALSE)

/obj/structure/door/Destroy()
	door_list -= src	
	..()
	for(var/obj/roof/R in loc)
		R.collapse_check()
	// This notifies any roofs in the surrounding atoms to not be transparent anymore.
	for(var/obj/roof/R in range(1, src))
		R.update_transparency(FALSE)

/obj/structure/door/fire_act(temperature)
	if(!isnum(temperature) || !temperature)
		CRASH("door/fire_act; proc called without correct temperature (integer) argument.")

	var/damage = round((temperature - 365)/20)

	if (temperature >= 380)
		damage = max(damage, 5)

	take_damage(damage)
	/*
	if (istype(src, /obj/structure/door/key))
		var/obj/structure/door/key/AM = src
		AM.damage_display()
	*/
/obj/structure/door/bullet_act(obj/item/projectile/P)
	var/damage = max(P.damage/2, 2)
	visible_message(SPAN_DANGER("\The [src] is hit by \the [P.name]!"))
	take_damage(damage)
	/*
	if (istype(src, /obj/structure/door/key))
		var/obj/structure/door/key/AM = src
		AM.damage_display()
	if (current_health <= 0)
		qdel(src)
	*/

/obj/structure/door/proc/update_material(material_name)
	material = get_material_by_name(material_name)

	if (override_material)
		base_icon_state = icon_state
	else
		icon_state = material.door_icon_base
		base_icon_state = material.door_icon_base
		color = material.icon_colour

	if(override_opacity && !opacity) // To not have to set opacity after a custom New() call ..().
		return
	else if(material.opacity < 0.5)
		opacity = FALSE
	else
		opacity = TRUE

	spawn(0) // Scheduled to happen right after other existing events that are immediately pending.
		if (material == MATERIAL_WOOD || MATERIAL_BAMBOO)
			flammable = TRUE

		if (!name || (!findtext(material.display_name, name) && name == "door"))
			name = "[material.display_name] door"

/obj/structure/door/get_material()
	return material

/obj/structure/door/Bumped(atom/user)
	if (operating) return
	return TryToSwitchState(user)

/obj/structure/door/attack_hand(mob/user as mob)
	if (operating) return
	return TryToSwitchState(user)

/obj/structure/door/CanPass(atom/movable/mover, turf/target, height = FALSE, air_group = FALSE)
	if (air_group) return FALSE
	return !density

/obj/structure/door/proc/TryToSwitchState(mob/user)
	if (operating || !user.client) return

	else if (ishuman(user))
		var/mob/living/human/H = user
		if(H.handcuffed)
			return

	if (density)
		Open()
	else
		Close()

/obj/structure/door/proc/can_open()
	if (!density || operating)
		return FALSE
	return TRUE

/obj/structure/door/proc/can_close()
	if (density || operating)
		return FALSE
	// Is anything blocking this door from closing?
	for (var/turf/turf in locs)
		for (var/atom/movable/AM in turf) // Iterate over every movable object in the turf.
			if (AM.blocks_door())
				return FALSE
	return TRUE

/obj/structure/door/proc/Open()
	set waitfor = FALSE // Instantly return . value on any sleep().
	if(!can_open())
		return
	operating = DOOR_OPERATING_YES

	if(open_sound)
		playsound(loc, open_sound, 100, TRUE)
	flick("[base_icon_state]opening", src)
	density = FALSE
	update_icon()
	sleep(2)
	opacity = FALSE
	sleep(8)
	operating = DOOR_OPERATING_NO
	// It notifies (potentially) affected light sources so they can update (if needed).
	for (var/atom/movable/lighting_overlay/L in view(7*3, src))
		L.update_overlay()
	// This notifies any roofs in the surrounding atoms to become transparent.
	for (var/obj/roof/R in range(1, src))
		R.update_transparency(TRUE)

/obj/structure/door/proc/Close()
	set waitfor = FALSE // Instantly return . value on any sleep().
	if (!can_close())
		return
	operating = DOOR_OPERATING_YES

	if(close_sound)
		playsound(loc, close_sound, 100, TRUE)
	flick("[base_icon_state]closing", src)
	density = TRUE
	update_icon()
	sleep(2)
	if(override_opacity)
		opacity = FALSE
	else
		opacity = TRUE
	sleep(8)
	operating = DOOR_OPERATING_NO
	// This notifies (potentially) affected light sources so they can update (if needed).
	for (var/atom/movable/lighting_overlay/L in view(7*3, src))
		L.update_overlay()
	// This notifies any roofs in the surrounding atoms to not be transparent anymore.
	for (var/obj/roof/R in range(1, src))
		R.update_transparency(FALSE)

/obj/structure/door/Destroy()
	for (var/atom/movable/lighting_overlay/L in view(7*3, src))
		L.update_overlay()
	..()

/obj/structure/door/update_icon()
    // icon_state = override_material ? initial(icon_state) : material.door_icon_base
	if (density) // aka. if (closed)
		icon_state = base_icon_state
	else
		icon_state = "[base_icon_state]open"

/obj/structure/door/attackby(obj/item/weapon/W, mob/user)
	if(check_force(W, user))
		return
	attack_hand(user)

/obj/structure/door/proc/on_deconstruct(devastated = FALSE)
	if (istype(material))
		material.place_dismantled_product(get_turf(src))
	qdel(src)

/obj/structure/door/ex_act(severity)
	switch(severity)
		if (1)
			on_deconstruct(TRUE)
		if (2)
			if (prob(20))
				on_deconstruct(TRUE)
		else
			on_deconstruct(TRUE)

/obj/structure/door/proc/check_force(obj/item/I, mob/user)
	if(!istype(I) || !density || user.a_intent != I_HARM)
		return FALSE
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(src)
	if(I.force < min_force)
		user.visible_message(SPAN_WARNING("\The [user] hits \the [src] with \an [I] to no effect."), \
							SPAN_WARNING("You <b>hit</b> \the [src] with \the [I] to no effect."))
	else
		user.visible_message(SPAN_DANGER("\The [user] hits \the [src] with \an [I], causing damage!"), \
							SPAN_WARNING("You <b>hit</b> \the [src] with \the [I], causing damage!"))
	
	// Scuffed attack animation begin.
	pixel_x += 1.5
	pixel_y += 1.5
	sleep(1)	
	pixel_x = initial(pixel_x)
	pixel_y = initial(pixel_y)
	// END.

	take_damage(I.force)
	return TRUE // Used as; if(check_force(obj, user))
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/structure/door/key/jail
	override_material = TRUE // This has a custom icon.
	override_opacity = TRUE // This icon can be seen through the bars.
	opacity = FALSE

/obj/structure/door/key/jail/attackby(obj/item/weapon/W, mob/living/human/user)
	if(!ishuman(user)) return //; we typecast in the proc arguments.

	if (istype(W, /obj/item/weapon/key))
		if (W.code != custom_code)
			to_chat(user, SPAN_WARNING("This key does not match this lock!"))
			return
		locked = !locked
		user.visible_message(SPAN_NOTICE("[user] [locked ? "locks" : "unlocks"] \the [src]."), SPAN_NOTICE("You [locked ? "lock" : "unlock"] \the [src]"))
		playsound(get_turf(src), 'sound/effects/door_lock_unlock.ogg', 100)
		return

	else if (istype(W, /obj/item/weapon/storage/belt/keychain))
		if(!W.contents.len)
			to_chat(user, SPAN_WARNING("\The [W] has no keys!"))
			return
		for (var/obj/item/weapon/key/KK in W.contents)
			if (KK.code == custom_code) // Does any key match?
				locked = !locked
				user.visible_message(SPAN_NOTICE("[user] [locked ? "locks" : "unlocks"] \the [src]."), SPAN_NOTICE("You [locked ? "lock" : "unlock"] \the [src]."))
				playsound(get_turf(src), 'sound/effects/door_lock_unlock.ogg', 100)
				return
		if (W.code != custom_code)
			if(W.contents.len > 1)
				to_chat(user, SPAN_WARNING("None of the keys on \the [W] match this lock!"))
			else
				to_chat(user, SPAN_WARNING("\The key on \the [W] does not match this lock!"))

	else if (istype(W, /obj/item/weapon/weldingtool))
		if (density)
			to_chat(user, SPAN_WARNING("You need to open \the [src] first."))
		else
			to_chat(user, SPAN_NOTICE("You start disassembling \the [src]..."))
			playsound(loc, 'sound/effects/extinguish.ogg', 50, TRUE)
			if (!do_after(user, 30, src))
				return
			// new buildstack(get_turf(src), buildstackamount)
			qdel(src)
			return

	else if (istype(W, /obj/item/weapon/lockpick))
		if (user.getStatCoeff("dexterity") < 1.7)
			to_chat(user, SPAN_WARNING("You don't have the skills to use this."))
			return
		if (locked)
			visible_message("<span class = 'danger'>[user] starts picking the [src.name]'s lock with the [W]!</span>")
			if (!do_after(user, 35*user.getStatCoeff("dexterity"), src))
				return
			if(prob(user.getStatCoeff("dexterity")*35))
				to_chat(user, SPAN_NOTICE("You pick the lock!"))
				locked = !locked
				return
			else if (prob(60))
				qdel(W)
				to_chat(user, SPAN_WARNING("Your lockpick broke!"))
				return
			else
				to_chat(user, SPAN_WARNING("You failed to pick the lock!"))
				return
			return

	else
		attack_hand(user)//keys!

/obj/structure/door/key/jail/bullet_act(obj/item/projectile/P)
	return PROJECTILE_CONTINUE
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/structure/door/examine(mob/user)
	. = ..()
	if(material)
		to_chat(user, "It's made out of [material.display_name].")

	// Health Component. (max_health is 400 if not over-ridden.)
	if (current_health < (max_health / 4)) // 100 health or below.
		to_chat(user, SPAN_WARNING("It looks like it's about to break!"))
	else if (current_health < (max_health / 2)) // 200 health or below.
		to_chat(user, SPAN_WARNING("It looks seriously damaged!"))
	else if (current_health < (max_health * 3/4)) /// 300 health or below.
		to_chat(user, SPAN_WARNING("It shows moderate signs of damage!"))
	else if (current_health < max_health) // Any damage.
		to_chat(user, SPAN_WARNING("It has minor damage."))
	else // Fully intact.
		to_chat(user, SPAN_NOTICE("It looks fully intact."))

/obj/structure/door/proc/take_damage(damage)
	if(QDELETED(src)) // Fail-safe.
		return
	current_health = max(0, (current_health - damage))
	if(current_health == 0)
		visible_message(SPAN_DANGER("\The [src] breaks!"))
		qdel(src)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/structure/door/iron
	material = "iron"
/obj/structure/door/stone
	material = "stone"
/obj/structure/door/silver
	material = "silver"
/obj/structure/door/gold
	material = "gold"
/obj/structure/door/sandstone
	material = "sandstone"
/obj/structure/door/wood
	material = "wood"
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/obj/structure/door/wood_unwindowed
	name = "wooden door"
	material = "wood"
	base_icon_state = "wood"
	icon = 'icons/obj/doors/material_doors_leonister.dmi'
	override_material = TRUE // This has a custom icon.
	override_opacity = TRUE // Keep opacity false, even when closed.
	opacity = FALSE

/obj/structure/door/wood_windowed
	name = "windowed wooden door"
	icon = 'icons/obj/doors/material_doors_leonister.dmi'
	icon_state = "wood2"
	base_icon_state = "wood2"
	material = "wood"
	desc = "This windowed wooden door has four corner windows and a cross at the top-center, dividing each window."
	override_material = TRUE // This has a custom icon.
	override_opacity = TRUE // Keep opacity false, even when closed.
	opacity = FALSE
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/obj/structure/door/fence
	name = "fence gate"
	base_icon_state = "fence"
	icon_state = "fence"
	material = "wood"
	override_opacity = TRUE // This icon is not fully blocking vision.
	override_material = TRUE // This has a custom icon.
	opacity = FALSE

/obj/structure/door/fence/picket
	name = "picket fence gate"
	icon_state = "picketfence"
	base_icon_state = "picketfence"
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/structure/door/cell
	material = "iron"
	name = "cell"
	icon_state = "cell"
	base_icon_state = "cell"
	override_opacity = TRUE // This icon can be seen through the bars.
	override_material = TRUE // This has a custom icon.
	opacity = FALSE
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/structure/door/key/jail/wood
	icon_state = "woodcell"
	base_icon_state = "woodcell"
	material = "wood"

/obj/structure/door/key/jail/wood/abashiri
	icon = 'icons/obj/doors/material_doors_leonister.dmi'
	icon_state = "abashiricell"
	base_icon_state = "abashiricell"
	material = "wood"

/obj/structure/door/key/jail/steel
	icon_state = "cell"
	base_icon_state = "cell"
	material = "steel"
////////////////////////////////////////////////////////////////////////////////////////////////////////////////