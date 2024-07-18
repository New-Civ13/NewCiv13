// -------------------------------------------------
// PARENT DEFINE: DO NOT USE
// -------------------------------------------------
/obj/structure/factory // Merge this into /furnace/ when possible.
	name = ""
	desc = ""
	icon = 'icons/obj/machines/coinsmelter.dmi'
	icon_state = ""

	layer = 2.9
	density = TRUE
	anchored = TRUE

	not_movable = TRUE
	not_disassemblable = FALSE

	flags = OPENCONTAINER | NOREACT

	var/on = FALSE
	var/fuel = 0	

	var/build_stack // The variable that contains the thing it was constructed out of, to drop it on a deconstruction.
	var/cost_to_construct // The variable which contains how much the thing costs to construct. [integers only please!]

	var/max_space = 6

/*
* contained_materials List()
* * keeps track of amounts within' a furnace. contained_materials[MATERIAL_???] to access.
* * You can do operations to it such as contained_materials[MATERIAL_IRON]--
*/
	var/list/contained_materials = list(
		MATERIAL_IRON = 0,
		MATERIAL_COPPER = 0,
		MATERIAL_TIN = 0,
		MATERIAL_GOLD = 0,
		MATERIAL_SILVER = 0
	)

/*
* materials List()
* * Argument 1; path of material [key]
* * Argument 2; internal variable [value that keeps score].
*/
	var/list/materials = list(
		/obj/item/stack/ore/iron = MATERIAL_IRON,
		/obj/item/stack/material/iron = MATERIAL_IRON,
		/obj/item/stack/ore/copper = MATERIAL_COPPER,
		/obj/item/stack/material/copper = MATERIAL_COPPER,
		/obj/item/stack/ore/tin = MATERIAL_TIN,
		/obj/item/stack/material/tin = MATERIAL_TIN,
		/obj/item/stack/material/gold = MATERIAL_GOLD,
		/obj/item/stack/material/silver = MATERIAL_SILVER
	)

// -------------------------------------------------

/obj/structure/factory/New()
	..()
	processing_objects |= src

/obj/structure/factory/Del()
	processing_objects -= src
	..()

/obj/structure/factory/proc/on_deconstruct()
	return

/obj/structure/factory/update_icon() // Proc'd for simplicity sake.
	if (on)
		icon_state = "[initial(icon_state)]_on"
		set_light(4)
	else
		icon_state = initial(icon_state)
		set_light(0)

/obj/structure/factory/attackby(obj/item/I, mob/living/human/H) // We return on every else-if here because we break the cylical structure nearing the end, with the get_fuel.
	if (!istype(H))
		return
	if (H.a_intent != I_HELP)
		return ..()

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

	else if (istype(I, /obj/item/weapon/material))
		if(!on && I.get_material_name() != "wood") // Allow 'wood' items to pass the `!on` check, as they simply add fuel.
			to_chat(H, SPAN_WARNING("\The [src] must be on!"))
			return
		var/information_to_retain
		var/new_material
		switch(I.get_material_name())
			if("wood")
				H.visible_message(SPAN_NOTICE("[H] breaks \the [I] and puts it into \the [src], adding fuel."), SPAN_NOTICE("You break \the [I] in half and put it into \the [src], adding fuel."))
				fuel += 1
			if("copper")
				information_to_retain = "copper ingot"
				new_material = /obj/item/stack/material/copper
			if("silver")
				information_to_retain = "silver ingot"
				new_material = /obj/item/stack/material/silver
			if("gold")
				information_to_retain = "gold ingot"
				new_material = /obj/item/stack/material/gold
			else
				to_chat(H, SPAN_WARNING("You can't smelt this here!"))
				return
		if(information_to_retain && new_material) // Mainly to prevent "wood" from executing this, among other things.
			H.visible_message(SPAN_NOTICE("[H] places \the <b>[I]</b> into \the [src], smelting it into \a <b>[information_to_retain]</b>."), SPAN_NOTICE("You smelt \the <b>[I]</b> into \a <b>[information_to_retain]</b>."))
			playsound(src, 'sound/items/cig_snuff.ogg', 66, TRUE) // Manufacturing sound. TBD; replace?
			new new_material(loc)
		qdel(I)
		return

	else if (istype(I, /obj/item) && I.basematerials.len) // Used to recycle cans, that's about it. Hence we evaluate this at the VERY end, to save processing.
		if(!on)
			to_chat(H, SPAN_WARNING("\The [src] must be on!"))
			return
		else if (I.basematerials[1] == "tin") // Look at `weapon/material` smelting if you wish to expand this system.
			H.visible_message(SPAN_NOTICE("[H] puts \the <b>[I]</b> into \the [src], smelting it into a <b>tin ingot</b>."), SPAN_NOTICE("You smelt \the <b>[I]</b> into a <b>tin ingot</b>."))
			new/obj/item/stack/material/tin(loc)
			playsound(src, 'sound/items/cig_snuff.ogg', 66, TRUE) // Manufacturing sound. TBD; replace?
		qdel(I)
		return

	// Okay, maybe we want to add fuel, then?
	var/item_has_fuel = I.get_fuel()
	if(item_has_fuel)
		fuel += item_has_fuel // This is the line that gives the fuel.
		H.visible_message(SPAN_NOTICE("[H] places \the [I] into \the [src], adding fuel"), SPAN_NOTICE("You place \the [I] into \the [src], refueling it."))
		qdel(I)
		return

	else ..() // Anything not caught by the checks goes straight to hitting.

/obj/structure/factory/attack_hand(mob/living/human/H)
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
/obj/structure/factory/process() // Handled by the scheduler, schedule_interval = 2 SECONDS? 
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/structure/factory/smelter
	name = "smelter"
	desc = "An industrial smelter, used to <b>smelt</b> and <b>extract</b> base metals from raw <font size = 1.5>copper</font>, <font size = 1.5>tin</font> and <font size = 1.5>iron</font>. It can also form <font size = 1.5>bronze</font> if equal amounts of <font size = 1.5>tin</font> and <font size = 1.5>copper</font> are present."
	icon_state = "coinsmelter"

	materials = list(
        /obj/item/stack/ore/iron = MATERIAL_IRON,
        /obj/item/stack/ore/copper = MATERIAL_COPPER,
        /obj/item/stack/ore/tin = MATERIAL_TIN
    )

	contained_materials = list(
		MATERIAL_IRON = 0,
		MATERIAL_COPPER = 0,
		MATERIAL_TIN = 0
	)

	var/in_progress // To avoid re-verbing whilst already in a do_after, and possibly other things.
	build_stack = /obj/item/stack/material/steel
	cost_to_construct = 20
// -------------------------------------------------

/obj/structure/factory/smelter/on_deconstruct()
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

/obj/structure/factory/smelter/attackby(obj/item/I, mob/living/human/H)
	for(var/material_type in materials)
		if(istype(I, material_type))
			contained_materials[materials[material_type]] += I.amount // Add the amount to the internal variable.
			to_chat(H, SPAN_NOTICE("You place \the [I] in \the [src]."))
			qdel(I)
			return

	// Handle case where item doesn't match any expected material
	..()

/obj/structure/factory/smelter/attack_hand(mob/living/human/H)
	if (!on && fuel < 1)
		to_chat(H, SPAN_WARNING("\The [src] is out of fuel!"))
		return

	var/has_ore_inside = FALSE // Variable used keep track if we have coins stored internally, from the for loop. (must be 5, as ingots yield 5 coins on craft.)

	// Code to check if we have materials over 0. If you wish to proc this in the future, name it under /proc/has_any_materials().
	for (var/mat in contained_materials)
		if (contained_materials[mat] > 0)
			has_ore_inside = TRUE
			break // Doesn't matter what coins we find, that'll be sorted later.

	if(!has_ore_inside)
		to_chat(H, SPAN_WARNING("\The [src] does not have anything to smelt!"))
		return

	on = !on
	H.visible_message(SPAN_NOTICE("[H] turns \the [src] [on ? "on" : "off"]."), SPAN_NOTICE("You turn \the [src] [on ? "on" : "off"].")) // TODO: Use some sort of tool to start the fire? (flint/torch ?)
	update_icon()

/obj/structure/factory/smelter/process()
	if (!on) return // No processing if the furnace is off.

	fuel -= 2
	if (fuel < 1)
		on = FALSE
		update_icon()
		visible_message(SPAN_DANGER("\icon[src] \The [src] runs out of fuel!"))
		playsound(src, 'sound/items/cig_snuff.ogg', 33, TRUE) // Extinguishing Sound. TBD; replace.
		fuel = 0 // Reset the fuel counter, sometimes it can go to -1 if odd.
		return

	else if (contained_materials[MATERIAL_TIN] > 0 && contained_materials[MATERIAL_COPPER] > 0) // Tin and Copper?
		var/amountconsumed = min(contained_materials[MATERIAL_TIN], contained_materials[MATERIAL_COPPER])
		var/obj/item/stack/material/bronze/newbronze = new/obj/item/stack/material/bronze(loc)
		newbronze.amount = amountconsumed * 3 // 2 parts become 3.
		contained_materials[MATERIAL_TIN] -= amountconsumed
		contained_materials[MATERIAL_COPPER] -= amountconsumed

	var/mats_found = FALSE

	// Loop to reduce on repetitive code.
	// This goes through every other material and makes it on the same process_tick().
	for (var/mat in materials)
		var/material = "/obj/item/stack/material/[materials[mat]]" // Using the define, assign the appropriate path.
		var/material_var = materials[mat] // Use the mat to get the material define (MATERIAL_IRON, MATERIAL_COPPER, MATERIAL_TIN).

		if (contained_materials[material_var] > 0) // Whilst that variable is >0 (not while'd, so we do 1 per process_tick)
			new material(loc) // Make a new material of this type!
			contained_materials[material_var]-- // Decrease the count of the internal variable.
			mats_found = TRUE

	if(!mats_found)
		on = FALSE
		update_icon()
		visible_message(SPAN_DANGER("\icon[src] \The [src] runs out of ore to smelt!"))

	playsound(src, 'sound/items/cig_snuff.ogg', 66, TRUE) // Manufacturing sound. TBD; replace?
	if (prob(40)) visible_message(SPAN_WARNING("\icon[src] <font size = 0.5>[pick("Hisssss", "Sssss", "SSssss", "ssssss", "sSSSssss", "Siiiihhss", "Hhsssh")]</font>")) // Like "churns happily", but more friendly. Manufacturing onomatopoeia.

/obj/structure/factory/smelter/verb/empty()
	set category = null
	set name = "Empty Ore"
	set src in range(1, usr)

	if(in_progress) return // in_progress (to avoid the 'change mind' whilst still in the original do_after, if the verb is triggered again, QOL.)

	else if (on)
		to_chat(usr, SPAN_WARNING("\The [src] must be off!"))
		return

	in_progress = TRUE
	usr.face_atom(src) // Verbs don't do it automatically.
	usr.visible_message(SPAN_NOTICE("[usr] starts to peer inside \the [src]."), SPAN_NOTICE("You start to peer inside \the [src].")) // Look inside.
	if (!do_after(usr, 5 SECONDS, src))
		usr.visible_message(SPAN_NOTICE("[usr] changes their mind and stops peering inside \the [src]."), SPAN_NOTICE("You change your mind and stop peering inside.")) // Niche interrupt msg.
		in_progress = FALSE
		return

	var/ore_found = FALSE // Variable used to keep track if we have mats stored internally, from the for loop.

	for (var/mat in contained_materials) // Code to check if we have materials over 0. If you wish to proc this in the future, name it under /proc/has_any_materials().
		if (contained_materials[mat] > 0)
			ore_found = TRUE
			break // Doesn't matter what mats we find, that'll be sorted later.

	if (!ore_found) // We use a variable so that if even 1 mat was found, this is disregarded.
		usr.visible_message(SPAN_NOTICE("[usr] was about to scoop out some amount of ore from inside \the [src], but realises that it's empty."), SPAN_NOTICE("You were about to scoop out some amount of ore from inside \the [src], ") + SPAN_WARNING("but it's empty.")) // usr gets the WARNING span. *intentional*.
		in_progress = FALSE
		return

	// Ore found!
	usr.visible_message(SPAN_NOTICE("[usr] begins to scoop out some amount of ore from inside \the [src]."), SPAN_NOTICE("You see some amount of ore and begin to scoop it out from inside \the [src].")) // Look inside.
	if (!do_after(usr, 5 SECONDS, src))
		usr.visible_message(SPAN_NOTICE("[usr] changes their mind and stops scooping from inside \the [src]."), SPAN_NOTICE("You change your mind and stop scooping from inside.")) // Niche interrupt msg.
		in_progress = FALSE
		return

	for (var/material_type in materials)
		var/material_var = materials[material_type]

		while (contained_materials[material_var] > 0)
			var/amount = min(contained_materials[material_var], 50) // Ensure we don't go over 50 in a stack when creating them.
			new material_type(loc, amount) // Make the ore come out!
			contained_materials[material_var] -= amount // Update the amount in contained_materials.

	usr.visible_message(SPAN_NOTICE("[usr] scoops out some amount of ore from inside \the [src]."), SPAN_NOTICE("You scoop out some amount of ore from inside \the [src].")) // Scoop successfully!
	in_progress = FALSE

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/structure/factory/coinsmelter
	name = "coinsmelter"
	desc = "An industrial coin smelter, used to smelter coins into ingots."
	icon_state = "coinsmelter"

	materials = list(
        /obj/item/stack/money/coin/gold = MATERIAL_GOLD,
        /obj/item/stack/money/coin/copper = MATERIAL_COPPER,
        /obj/item/stack/money/coin/silver = MATERIAL_SILVER
    )

	contained_materials = list(
		MATERIAL_GOLD = 0,
		MATERIAL_COPPER = 0,
		MATERIAL_SILVER = 0
	)

	var/in_progress // To avoid re-verbing whilst already in a do_after, and possibly other things.
	build_stack = /obj/item/stack/material/steel
	cost_to_construct = 50
// -------------------------------------------------

/obj/structure/factory/coinsmelter/attackby(obj/item/I, mob/living/human/H)
	if (!istype(H))
		return
	if (H.a_intent != I_HELP)
		return ..()

	else if (istype(I, /obj/item/stack/money/coin))
		for (var/material_type in materials)
			if (istype(I, material_type)) // Path check!
				contained_materials[materials[material_type]] += I.amount // Add the amount to the internal variable.
				H.visible_message(SPAN_NOTICE("[H] places \the [I] into \the [src]."), SPAN_NOTICE("You place \the [I] into \the [src]."))
				qdel(I)
				return // Return not needed, but fail-safe in-case someone else adds code without any checks. 6-6

	else ..() // Anything not caught by the checks goes straight to parent.

/obj/structure/factory/coinsmelter/attack_hand(mob/living/human/H)
	if (!on && fuel < 1)
		to_chat(H, SPAN_WARNING("\The [src] is out of fuel!"))
		return

	var/coin_amount_satieted = FALSE // Variable used keep track if we have coins stored internally, from the for loop. (must be 5, as ingots yield 5 coins on craft.)

	// Code to check if we have materials over 0. If you wish to proc this in the future, name it under /proc/has_any_materials().
	for (var/mat in contained_materials)
		if (contained_materials[mat] >= 5)
			coin_amount_satieted = TRUE
			break // Doesn't matter what coins we find, that'll be sorted later.

	if(!coin_amount_satieted)
		to_chat(H, SPAN_WARNING("\The [src] does not have enough coins to smelt into an ingot, you believe it might take 5 coins per ingot!"))
		return

	// Turn it on/off!
	on = !on
	H.visible_message(SPAN_NOTICE("[H] turns \the [src] [on ? "on" : "off"]."), SPAN_NOTICE("You turn \the [src] [on ? "on" : "off"].")) // TODO: Use some sort of tool to start the fire? (flint/torch ?)
	update_icon()

/obj/structure/factory/coinsmelter/process()
	if (!on) return // We're not gonna process anything without it being on in the first place.

	fuel -= 2
	if (fuel < 1)
		on = FALSE
		update_icon()
		visible_message(SPAN_DANGER("\icon[src] \The [src] runs out of fuel!"))
		playsound(src, 'sound/items/cig_snuff.ogg', 33, TRUE) // Extinguishing Sound. TBD; replace.
		fuel = 0 // Reset the fuel counter, sometimes it can go to -1 if odd.
		return // And don't make ingots without a double fuel cycle.

	var/coin_amount_satieted = FALSE

	for (var/material_key in materials)
		var/ingot_path = "/obj/item/stack/material/[materials[material_key]]" // Using the define, assign the appropriate path.
		var/material_var = materials[material_key] // Use the material_key to get the material define (MATERIAL_GOLD, MATERIAL_COPPER, MATERIAL_SILVER).

		if (material_var == MATERIAL_SILVER) // 1 ingot of silver, makes 5 silver coins.
			if (contained_materials[material_var] >= 10) // Ensure there is enough silver to create an ingot.
				new ingot_path(loc) // Make a new ingot of this type for silver!
				contained_materials[material_var] -= 10 // Decrease the count by 10 if it's silver.
				coin_amount_satieted = TRUE
		else
			if (contained_materials[material_var] >= 5) // Ensure there is enough material to create an ingot.
				new ingot_path(loc) // Make a new ingot of this type for other materials!
				contained_materials[material_var] -= 5 // Decrease the count by 5 for other materials.
				coin_amount_satieted = TRUE

	if (!coin_amount_satieted)// Not enough coins? :megamind: (we put this in a VAR so it goes to it only after iterating through the entire loop.)
		on = FALSE
		update_icon()
		visible_message(SPAN_DANGER("\icon[src] \The [src] runs out of <i>enough</i> coins to smelt into an ingot!")) // Coins left in coinsmelter if value under 5, scoop it out using the empty() verb! TBD: heat?

	playsound(src, 'sound/items/cig_snuff.ogg', 66, TRUE) // Manufacturing sound. TBD; replace?
	if (prob(40)) visible_message(SPAN_WARNING("\icon[src] <font size = 0.5>[pick("Hisssss", "Sssss", "SSssss", "ssssss", "sSSSssss", "Siiiihhss", "Hhsssh")]</font>")) // Like "churns happily", but more friendly. Manufacturing onomatopoeia.

/obj/structure/factory/coinsmelter/verb/empty()
	set category = null
	set name = "Empty Coins"
	set src in range(1, usr)

	if(in_progress) return // in_progress (to avoid the 'change mind' whilst still in the original do_after, if the verb is triggered again, QOL.)

	else if (on)
		to_chat(usr, SPAN_WARNING("\The [src] must be off!"))
		return

	in_progress = TRUE
	usr.face_atom(src) // Verbs don't do it automatically.
	usr.visible_message(SPAN_NOTICE("[usr] starts to peer inside \the [src]."), SPAN_NOTICE("You start to peer inside \the [src].")) // Look inside.
	if (!do_after(usr, 5 SECONDS, src))
		usr.visible_message(SPAN_NOTICE("[usr] changes their mind and stops peering inside \the [src]."), SPAN_NOTICE("You change your mind and stop peering inside.")) // Niche interrupt msg.
		in_progress = FALSE
		return

	var/coins_found = FALSE // Variable used to keep track if we have coins stored internally, from the for loop.

	for (var/mat in contained_materials) // Code to check if we have materials over 0. If you wish to proc this in the future, name it under /proc/has_any_materials().
		if (contained_materials[mat] > 0)
			coins_found = TRUE
			break // Doesn't matter what coins we find, that'll be sorted later.

	if (!coins_found) // We use a variable so that if even 1 coin was found, this is disregarded.
		usr.visible_message(SPAN_NOTICE("[usr] was about to scoop out some amount of coin from inside \the [src], but realises that it's empty."), SPAN_NOTICE("You were about to scoop out some amount of coin from inside \the [src], ") + SPAN_WARNING("but it's empty.")) // usr gets the WARNING span. *intentional*.
		in_progress = FALSE
		return

	// Coins found!
	usr.visible_message(SPAN_NOTICE("[usr] begins to scoop out some amount of coin from inside \the [src]."), SPAN_NOTICE("You see some amount of coin and begin to scoop it out from inside \the [src].")) // Look inside.
	if (!do_after(usr, 5 SECONDS, src))
		usr.visible_message(SPAN_NOTICE("[usr] changes their mind and stops scooping from inside \the [src]."), SPAN_NOTICE("You change your mind and stop scooping from inside.")) // Niche interrupt msg.
		in_progress = FALSE
		return

	for (var/coin in materials)
		var/coin_var = materials[coin]

		while (contained_materials[coin_var] > 0) // Whilst that variable is >0
			var/amount = min(contained_materials[coin_var], 500) // Make sure we don't go over >500, the max_amount for these three coin types.
			new coin(loc, amount) // Make the new coin!
			contained_materials[coin_var] -= amount // remove the amount from the variable.

	usr.visible_message(SPAN_NOTICE("[usr] scoops out some amount of coin from inside \the [src]."), SPAN_NOTICE("You scoop out some amount of coin from inside \the [src].")) // Scoop successfully!
	in_progress = FALSE

////////////////////////////////////////////////////////////////////////////////////////////////////////////////