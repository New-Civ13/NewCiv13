// -------------------------------------------------
// PARENT DEFINE: DO NOT USE
// -------------------------------------------------

/obj/structure/furnace
	name = ""
	desc = ""
	icon = 'icons/obj/metallurgy.dmi'
	icon_state = ""

	layer = 2.9
	density = TRUE
	anchored = TRUE

	not_movable = TRUE
	not_disassemblable = FALSE

	flags = OPENCONTAINER | NOREACT

	var/fuel = 0 // Kept as a variable. Keeps track of the fuel amount of the obj.
	var/build_stack // The variable that contains the thing it was constructed out of, to drop it on a deconstruction.
	var/cost_to_construct // The variable which contains how much the thing costs to construct. [integers only please!]
	var/on = FALSE

	/*
	* contained_materials List()
	* * keeps track of amounts within' a furnace. contained_materials[MATERIAL_???] to access.
	* * You can do operations to it such as contained_materials[MATERIAL_IRON]--
	*/
	var/list/contained_materials = list(
		MATERIAL_IRON = 0,
	)

	/*
	* materials List()
	* * Argument 1; path of material [key]
	* * Argument 2; internal variable [value that keeps score].
	*/
	var/list/materials = list(
		/obj/item/stack/ore/iron = MATERIAL_IRON,
	)

	var/in_progress // To avoid re-verbing whilst already in a do_after, and possibly other things.
// -------------------------------------------------

/obj/structure/furnace/New()
	..()
	processing_objects |= src

/obj/structure/furnace/Del()
	processing_objects -= src
	..()

/obj/structure/furnace/proc/on_deconstruct()
	return

/obj/structure/furnace/update_icon() // Proc'd for simplicity sake.
	if (on)
		icon_state = "[initial(icon_state)]_on"
		set_light(4)
	else
		icon_state = initial(icon_state)
		set_light(0)

/obj/structure/furnace/attackby(obj/item/I, mob/living/human/H)
	if (!istype(H))
		return
	if (H.a_intent != I_HELP)
		return ..() // Return to the parent-procs version.

	if (istype(I, /obj/item/weapon/wrench))
		H.visible_message(SPAN_WARNING("[H] starts to [anchored ? "unsecure" : "secure"] \the [src] [anchored ? "from" : "to"] the ground."), SPAN_WARNING("You start to [anchored ? "unsecure" : "secure"] \the [src] [anchored ? "from" : "to"] the ground."))
		playsound(src, 'sound/items/Ratchet.ogg', 100, TRUE)
		if (!do_after(H, 5 SECONDS, src))
			return // return so we don't reach the fuel code.
		H.visible_message(SPAN_WARNING("[H] [anchored ? "unsecures" : "secures"] \the [src] [anchored ? "from" : "to"] the ground."), SPAN_WARNING("You [anchored ? "unsecure" : "secure"] \the [src] [anchored ? "from" : "to"] the ground."))
		playsound(src, 'sound/items/Ratchet.ogg', 100, TRUE)
		anchored = !anchored
		return

	else if (istype(I, /obj/item/weapon/hammer))
		H.visible_message(SPAN_WARNING("[H] starts to deconstruct \the [src]."), SPAN_WARNING("You start to deconstruct \the [src]."))
		playsound(src, 'sound/items/Ratchet.ogg', 100, TRUE)
		if (!do_after(H, 5 SECONDS, src))
			return // return so we don't reach the fuel code; again.
		H.visible_message(SPAN_WARNING("[H] deconstructs \the [src]."), SPAN_WARNING("You deconstruct \the [src]."))
		playsound(src, 'sound/items/Ratchet.ogg', 100, TRUE)
		on_deconstruct()
		return

	// Okay, maybe we want to add fuel, then?
	var/item_has_fuel = I.get_fuel()
	if(item_has_fuel)
		fuel += item_has_fuel // This is the line that gives the fuel.
		H.visible_message(SPAN_NOTICE("[H] places \the [I] into \the [src], adding fuel"), SPAN_NOTICE("You place \the [I] into \the [src], refueling it."))
		qdel(I)
		return

/obj/structure/furnace/attack_hand(mob/living/human/H)
	var/turf/T = get_step(src, NORTH) // TODO: All furnaces sprites currently face south ONLY. `Dir` only changes if unwrenched and pulled across x/y axis.

	if(H.loc == T)
		to_chat(H, SPAN_WARNING("You must be near the front of \the [src] to interact with it!"))
		return

	else if (!on && fuel < 1)
		to_chat(H, SPAN_WARNING("\The [src] is out of fuel!"))
		return

	on = !on
	H.visible_message(SPAN_NOTICE("[H] turns \the [src] [on ? "on" : "off"]."), SPAN_NOTICE("You turn \the [src] [on ? "on" : "off"].")) // TODO: Use some sort of tool to start the fire? (flint/torch ?)
	update_icon()

/* PROCESS CODE; UNCOMMENT TO MAKE ALL CHILDS HAVE SOMETHING IN COMMON.
* TODO: Calculate Delta-Time (dont use world.time as it is based on tick-rate); so we don't lose our consistency of fuel transfers.
* TODO: Update our subsystems so we can use START_PROCESSING(), to calculate the Delta-Time?
* I have it set to 1 fuel per process-tick, except in the case of the bloomery, it needs to cycle twice with fuel, or else no iron_sponge.
/obj/structure/furnace/process() // Handled by the scheduler, schedule_interval = 2 SECONDS?
*/

/obj/structure/furnace/verb/empty()
	set category = null
	set name = "Empty Contents" // Empty the var/iron into ore on the ground.
	set src in range(1, usr)

	var/turf/T = get_step(src, NORTH) // TODO: All furnaces sprites currently face south ONLY. `Dir` only changes if unwrenched and pulled across x/y axis.
	usr.face_atom(src) // Verbs don't do it automatically.

	if(usr.loc == T)
		to_chat(usr, SPAN_WARNING("You must be near the entrance of \the [src]!"))
		return

	if(!contained_materials[MATERIAL_IRON] && !in_progress) // !in_progress (to avoid the 'change mind' whilst still in the original do_after, if the verb is triggered again, QOL.)
		in_progress = TRUE
		usr.visible_message(SPAN_NOTICE("[usr] begins to peer inside \the [src]."), SPAN_NOTICE("You begin to peer inside \the [src].")) // Look inside.
		if (!do_after(usr, 5 SECONDS, src))
			usr.visible_message(SPAN_NOTICE("[usr] changes their mind and stops peering inside \the [src]."), SPAN_NOTICE("You change your mind and stop peering inside.")) // Niche interrupt msg.
			in_progress = FALSE
			return
		usr.visible_message(SPAN_NOTICE("[usr] peers inside \the [src]."), SPAN_NOTICE("You peer inside \the [src], ") + SPAN_WARNING("it's empty.")) // usr gets the WARNING span. *intentional*.
		in_progress = FALSE

	else if (contained_materials[MATERIAL_IRON] > 0) // We have iron!
		in_progress = TRUE
		usr.visible_message(SPAN_NOTICE("[usr] begins to peer inside \the [src]."), SPAN_NOTICE("You begin to peer inside \the [src].")) // Look inside.
		if (!do_after(usr, 5 SECONDS, src))
			usr.visible_message(SPAN_NOTICE("[usr] changes their mind and stops peering inside \the [src]."), SPAN_NOTICE("You change your mind and stop peering inside.")) // Niche interrupt msg.
			in_progress = FALSE
			return

		while (contained_materials[MATERIAL_IRON] > 0) // Gimme that iron!
			var/amount = min(contained_materials[MATERIAL_IRON], 50) // Don't go over 50, the max_amount.
			new/obj/item/stack/ore/iron(loc, amount) // stack/New(var/loc, var/_amount=0) --> Arg1; loc <-> Arg2; Amount <--
			contained_materials[MATERIAL_IRON] -= amount // Remove the amount we just created from the furnace's internal counter.

		usr.visible_message(SPAN_NOTICE("[usr] empties \the [src]."), SPAN_WARNING("You empty \the [src].")) // Successful empty.
		in_progress = FALSE

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/structure/furnace/bloomery
	name = "bloomery"
	desc = "An industrial bloomery, primarily used to <b>only smelt <font size = 1.5>iron</font> ore</b> into <b><font size = 1.5>sponge iron</font></b>."
	icon_state = "bloomery"

	build_stack = /obj/item/stack/material/clay
	cost_to_construct = 10 // clay
// -------------------------------------------------

/obj/structure/furnace/bloomery/on_deconstruct()
	for (var/mat in materials) // Gimme those materials!
		var/mat_var = materials[mat] // We runtime if we try and compare 'mat' by itself because it is e.g; defined as "iron", so we assign it to `mat_var` here.
		var/ore_path = "/obj/item/stack/ore/[mat_var]" // Using the define, assign the appropriate path.

		while(contained_materials[mat_var] > 0)
			var/amount = min(contained_materials[mat_var], 50) // Make sure we don't go over >50, the max_amount.
			new ore_path(loc, amount) // Make the new material!
			contained_materials[mat_var] -= amount // remove the amount from the variable.

	if(build_stack && cost_to_construct) // Fail-safe.
		new build_stack(loc, cost_to_construct)
	qdel(src)
	return

/obj/structure/furnace/bloomery/attackby(obj/item/I, mob/living/human/H)
	var/turf/T = get_step(src, NORTH) // TODO: All furnaces sprites currently face south ONLY. `Dir` only changes if unwrenched and pulled across x/y axis.

	if(H.loc == T)
		if(istype(I, /obj/item/weapon/wrench) || istype(I, /obj/item/weapon/hammer)) // Wrench and Hammers should be omnidirectional. (!istype(x) || !istype(y) is always true)
			return ..() // Return to the anchoring/deconstruction handling code.
		to_chat(H, SPAN_WARNING("You must be near the front of \the [src] to interact with it!"))
		return

	else if (I.type == /obj/item/stack/ore/iron) // Why not in the parent attackby()? Saving micro-seconds of processing by having stack/ore/iron evaluated here. Kilns don't smelt iron.
		contained_materials[MATERIAL_IRON] += I.amount
		H.visible_message(SPAN_NOTICE("[H] places \the [I] into \the [src]."), SPAN_NOTICE("You place \the [I] into \the [src]."))
		qdel(I)
		return

	else ..() // Consult the rest.

/obj/structure/furnace/bloomery/process()
	if(!on) return // We're not gonna process anything without it being on in the first place.

	fuel--
	if (fuel < 1)
		on = FALSE
		update_icon()
		visible_message(SPAN_DANGER("\icon[src] \The [src] runs out of fuel!"))
		playsound(src, 'sound/items/cig_snuff.ogg', 33, TRUE) // Extinguishing Sound. TBD; replace.
		return // And don't make iron without a double fuel cycle.

	else if (contained_materials[MATERIAL_IRON] > 0) // Cycle must run twice to get here. (If given 50 fuel and 50 iron, will smelt 49 iron and run out of fuel, leaving 1 iron. A blast-furnace would smelt it all 1:1.)
		new/obj/item/stack/ore/iron_sponge(loc) // (GENERALLY 2 fuel per 1 iron); since we evaluate (fuel < 1) straight after `fuel--`, *on purpose, less efficient energy transfers on a bloomery*.
		contained_materials[MATERIAL_IRON]-- // Decrease the furnace's internal iron count.
		playsound(src, 'sound/items/cig_snuff.ogg', 66, TRUE) // Manufacturing sound. TBD; replace?
		if(prob(40)) visible_message(SPAN_WARNING("\icon[src] <font size = 0.5>[pick("Hisssss", "Sssss", "SSssss", "ssssss", "sSSSssss", "Siiiihhss", "Hhsssh")]</font>")) // Like 'churns happily', but more friendly. Manufacturing onomatoepia.

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/structure/furnace/blast_furnace // TBD; Smelt-;[lead or copper.]}~
	name = "blast furnace"
	desc = "An industrial blast furnace, primarily used to <b>only smelt <font size = 1.5>iron</font> ore</b> into <b><font size = 1.5>pig iron</font></b>. It can also <b>recycle</b> items back into their material compounds."
	icon_state = "blast_furnace"

	build_stack = /obj/item/stack/material/iron
	cost_to_construct = 15 // iron
// -------------------------------------------------

/obj/structure/furnace/blast_furnace/on_deconstruct()
	for (var/mat in materials) // Gimme those materials!
		var/mat_var = materials[mat] // We runtime if we try and compare 'mat' by itself because it is e.g; defined as "iron", so we assign it to `mat_var` here.
		var/ore_path = "/obj/item/stack/ore/[mat_var]" // Using the define, assign the appropriate path.

		while(contained_materials[mat_var] > 0)
			var/amount = min(contained_materials[mat_var], 50) // Make sure we don't go over >50, the max_amount.
			new ore_path(loc, amount) // Make the new material!
			contained_materials[mat_var] -= amount // remove the amount from the variable.

	if(build_stack && cost_to_construct) // Fail-safe.
		new build_stack(loc, cost_to_construct)
	qdel(src)
	return

/obj/structure/furnace/blast_furnace/attackby(obj/item/I, mob/living/human/H) // Why not in main? Recycling should be a blast-furnace's job. Saving micro-seconds of processing by having stack/ore/iron evaluated here. Kilns don't smelt iron.
	var/turf/T = get_step(src, NORTH) // TODO: All furnaces sprites currently face south ONLY. `Dir` only changes if unwrenched and pulled across x/y axis.

	if(H.loc == T)
		if(istype(I, /obj/item/weapon/wrench) || istype(I, /obj/item/weapon/hammer)) // Wrench and Hammers should be omnidirectional. (!istype(x) || !istype(y) is always true)
			return ..() // Return to the anchoring/deconstruction handling code.
		to_chat(H, SPAN_WARNING("You must be near the front of \the [src] to interact with it!"))
		return

	else if (I.type == /obj/item/stack/ore/iron) // Check the main-usage first, then recycling. THEN parent ..()
		contained_materials[MATERIAL_IRON] += I.amount
		H.visible_message(SPAN_NOTICE("[H] places \the [I] into \the [src]."), SPAN_NOTICE("You place \the [I] into \the [src]."))
		qdel(I)
		return

	else if (istype(I, /obj/item/weapon/material)) // Else-if to save nano-seconds of processing times (if the last check was false.)
		if(!on && I.get_material_name() != "wood") // Allow 'wood' items to pass the `!on` check, as they simply add fuel.
			to_chat(H, SPAN_WARNING("\The [src] must be on!"))
			return
		var/information_to_retain
		var/new_material
		switch(I.get_material_name()) // get_material_name() is a obj/ level proc, so we don't need to typecast I to the path of weapon/material.
			if("wood")
				H.visible_message(SPAN_NOTICE("[H] places \the <b>[I]</b> into \the <b>[src]</b>, adding fuel."), SPAN_NOTICE("You place \the <b>[I]</b> into \the <b>[src]</b>, adding fuel."))
				fuel += 1
			if("bronze")
				information_to_retain = "bronze ingot"
				new_material = /obj/item/stack/material/bronze
			if("copper")
				information_to_retain = "copper ingot"
				new_material = /obj/item/stack/material/copper
			if("tin")
				information_to_retain = "tin ingot"
				new_material = /obj/item/stack/material/tin
			if("iron")
				information_to_retain = "iron ingot"
				new_material = /obj/item/stack/material/iron
			if("steel")
				information_to_retain = "steel sheet"
				new_material = /obj/item/stack/material/steel
			else
				to_chat(H, SPAN_WARNING("You can't smelt this here!"))
				return // Early return.
		if(information_to_retain && new_material) // Mainly to prevent "wood" from executing this, among other things.
			H.visible_message(SPAN_NOTICE("[H] places \the <b>[I]</b> into \the [src], smelting it into \a <b>[information_to_retain]</b>."), SPAN_NOTICE("You smelt \the <b>[I]</b> into \a <b>[information_to_retain]</b>."))
			playsound(src, 'sound/items/cig_snuff.ogg', 66, TRUE) // Manufacturing sound. TBD; replace?
			new new_material(loc)
		qdel(I)
	
	else if (istype(I, /obj/item) && I.basematerials.len) // Used to recycle cans, that's about it. Hence we evaluate this at the VERY end, to save processing.
		if(!on)
			to_chat(H, SPAN_WARNING("\The [src] must be on!"))
			return
		else if (I.basematerials[1] == "tin") // Look at `weapon/material` smelting if you wish to expand this system.
			H.visible_message(SPAN_NOTICE("[H] puts \the <b>[I]</b> into \the [src], smelting it into a <b>tin ingot</b>."), SPAN_NOTICE("You smelt \the <b>[I]</b> into a <b>tin ingot</b>."))
			new/obj/item/stack/material/tin(loc)
			playsound(src, 'sound/items/cig_snuff.ogg', 66, TRUE) // Manufacturing sound. TBD; replace?
		qdel(I)

	else ..() // Consult the rest.

/obj/structure/furnace/blast_furnace/process()
	if(!on) return // We're not gonna process anything without it being on in the first place.

	fuel--
	if (contained_materials[MATERIAL_IRON] > 0)
		new/obj/item/stack/ore/iron_pig(loc) // Blast Furnaces are MUCH more efficient with energy. 1 fuel per 1 iron; since we evaluate (iron > 0) straight after `fuel--`.
		contained_materials[MATERIAL_IRON]-- // Decrease the furnace's internal iron count.
		playsound(src, 'sound/items/cig_snuff.ogg', 66, TRUE) // Manufacturing sound. TBD; replace?
		if(prob(70)) visible_message(SPAN_WARNING("\icon[src] <font size = 0.5>[pick("Hisssss", "Sssss", "SSssss", "ssssss", "sSSSssss", "Siiiihhss", "Hhsssh")]</font>"))

	if (fuel < 1) // else if() only executes if the previous check is false, if we had else if() here, it would only move to here when iron is 0, making all the iron for 1 fuel.
		on = FALSE
		update_icon()
		visible_message(SPAN_DANGER("\The [src] runs out of fuel!"))
		playsound(src, 'sound/items/cig_snuff.ogg', 33, TRUE) // Extinguishing Sound. TBD; replace.

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// -------------------------------------------------
// PARENT DEFINE: DO NOT USE
// -------------------------------------------------

/obj/structure/furnace/kiln
	name = ""
	desc = ""
	icon = 'icons/obj/metallurgy.dmi'
	icon_state = ""

	cost_to_construct = 10 // Each kiln is 10 no matter the material, as of 7.17.2024.
// -------------------------------------------------

/obj/structure/furnace/on_deconstruct()
	if(istype(src, /obj/structure/furnace/kiln)) // Not the cleanest, but it will do.
		for (var/obj/item/weapon/clay/mold/MCC in contents)
			MCC.loc = loc
		visible_message(SPAN_DANGER("\icon[src] \The contents of \the [src] fall out!"))
		if(build_stack && cost_to_construct) // Fail-safe.
			new build_stack(loc, cost_to_construct)
		qdel(src)
		return

/obj/structure/furnace/kiln/attackby(obj/item/I, mob/living/human/H)
	var/turf/T = get_step(src, NORTH) // TODO: All furnaces sprites currently face south ONLY. `Dir` only changes if unwrenched and pulled across x/y axis.

	if(H.loc == T)
		if(istype(I, /obj/item/weapon/wrench) || istype(I, /obj/item/weapon/hammer)) // Wrench and Hammers should be omnidirectional. (!istype(x) || !istype(y) is always true)
			return ..() // Return to the anchoring/deconstruction handling code.
		to_chat(H, SPAN_WARNING("You must be near the front of \the [src] to interact with it!"))
		return

	else if (istype(I, /obj/item/weapon/clay/mold))
		var/obj/item/weapon/clay/mold/MC = I // Typecast to access vars.
		if (MC.fired && MC.capacity == 0 && MC.max_capacity > 0 && MC.contents_materials.len)
			H.remove_from_mob(I)
			I.loc = src
			H.visible_message(SPAN_NOTICE("[H] puts \the [I] in \the [src]."), SPAN_NOTICE("You put \the [I] into \the [src]."))
			return

	else if (I.type == /obj/item/stack/ore/iron)
		to_chat(H, SPAN_WARNING("You can't use \the [src] to smelt this!"))
		return
	
	else ..() // Consult the rest.

/obj/structure/furnace/kiln/process()
	if(!on) return // We're not gonna process anything without it being on in the first place.

	fuel--
	if (fuel < 1) // else if() only executes if the previous check is false, if we had else if() here, it would only move to here when iron is 0, making all the iron for 1 fuel.
		on = FALSE
		update_icon()
		visible_message(SPAN_DANGER("\The [src] runs out of fuel!"))
		playsound(src, 'sound/items/cig_snuff.ogg', 33, TRUE) // Extinguishing Sound. TBD; replace.
		return

	// Processing molds.
	for (var/obj/item/weapon/clay/mold/MCC in contents)
		if (MCC.fired && MCC.capacity == 0 && MCC.max_capacity > 0 && MCC.contents_materials.len)
			if (("copper" in MCC.contents_materials) && ("tin" in MCC.contents_materials))
				MCC.capacity = min(MCC.contents_materials["copper"],MCC.contents_materials["tin"])
				MCC.contents_materials["copper"] -= MCC.capacity
				MCC.contents_materials["tin"] -= MCC.capacity
				MCC.current_material = "bronze"
			else
				for(var/i in MCC.contents_materials)
					MCC.capacity = MCC.contents_materials[i]
					MCC.current_material = i
			MCC.contents_materials = list()
			MCC.loc = src.loc
			MCC.update_icon()

// -------------------------------------------------

/obj/structure/furnace/kiln/clay
	name = "clay kiln"
	desc = "A clay brick kiln, used for <font size = 1.5><b>metallurgy</b>."
	icon_state = "clay_kiln"
	build_stack = /obj/item/stack/material/clay

/obj/structure/furnace/kiln/stone
	name = "stone kiln"
	desc = "A stone kiln, used for <font size = 1.5><b>metallurgy</b>."
	icon_state = "stone_kiln"
	build_stack = /obj/item/stack/material/stone

/obj/structure/furnace/kiln/sandstone
	name = "sandstone kiln"
	desc = "A sandstone kiln, used for <font size = 1.5><b>metallurgy</b></font>."
	icon_state = "sandstone_kiln"
	build_stack = /obj/item/stack/material/sandstone

////////////////////////////////////////////////////////////////////////////////////////////////////////////////