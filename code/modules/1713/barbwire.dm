/obj/structure/barbwire
	name = "barbwire"
	icon_state = "barbwire"

	anchored = TRUE
	not_movable = TRUE
	not_disassemblable = TRUE

	var/allow_passage = TRUE // So we snag otherwise. (To allow the user to get off the src-turf and not punish them.)
	layer = 2.98

/obj/structure/barbwire/ex_act(severity)
	switch (severity)
		if (3)
			if (prob(50))
				qdel(src)
		else
			qdel(src)

/obj/structure/barbwire/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	return TRUE

/mob/living/human/var/next_barbwire_trip = -1 // TO:DO, Put this else-where if possible, debloat.

/obj/structure/barbwire/Crossed(mob/living/human/H) // TODO: NPCs randomly walk over barbed-wire. Including simple_mobs, maybe deny them?
	if (!src || !src.loc) return // An attempt at fixing invisible barbed-wires - Treez
	if (!ishuman(H)) return //; we type-cast in the argument of the proc.

	var/obj/item/organ/external/affecting = H.get_organ(pick("l_foot", "r_foot", "l_leg", "r_leg"))
	var/deep_cut = rand(12, 14)
	var/moderate_cut = rand(6, 8)
	var/slight_cut = rand(3, 5)

	switch (rand(1, 100))
		if (1 to 20) // 20% chance.
			if (affecting)
				affecting.take_damage(slight_cut, FALSE) // Slight cut gives around 6.16~ shock_stage.
				to_chat(H, SPAN_WARNING("Your <b>[affecting.name]</b> gets <b>slightly</b> cut by the [src]!"))
		if (21 to 60) // 40% chance.
			if (affecting)
				affecting.take_damage(moderate_cut, FALSE) // Gives around 15~ shock_stage.
				to_chat(H, SPAN_WARNING("Your <b>[affecting.name]</b> gets <b>cut</b> by the [src]!"))
		if (61 to 90) // 30% chance.
			if (affecting)
				affecting.take_damage(deep_cut, FALSE) // Gives around 25~ shock_stage.
				to_chat(H, SPAN_WARNING("Your <b>[affecting.name]</b> gets <b>[pick("deeply", "heavily", "seriously")]</b> cut by the [src]!"))
		if (91 to 100) // 10% chance.
			to_chat(H, SPAN_WARNING("You snag on the [src]!"))

	if (affecting && affecting.damage > 0)
		H.UpdateDamageIcon()
	if(prob(80) && H.next_barbwire_trip <= world.time)
		H.next_barbwire_trip = world.time + 3 SECONDS // To prevent spam on crossing mapped barbwire. (2 or more barbed-wire on turfs.)
		spawn(rand(7,9)) // TODO; signal this or callback it. (Call this more consistently.)
			if(H.weakened)
				to_chat(H, SPAN_DANGER("[pick("<font size = 1.5><b>You trip!</b></font>", "<font size = 1.5><b>You get tangled in \the [src] and trip!</b></font>")]"))
				H.weakened -= min(7, H.weakened) // Most of the time it is 20, so we set it to `7`, allowing some crawls before another pause. (Doesn't account for more weaken deductions due to next_barbwire_trip cooldown.)
				affecting = H.get_organ(pick("head", "chest", "l_leg", "r_leg", "l_arm", "r_arm"))
				if(affecting) affecting.take_damage(rand(1,2), FALSE) // Gives around 3~ shock_stage.
				playsound(get_turf(H), 'sound/effects/gore/fallsmash.ogg', 160, TRUE) // Can walk off in time of fallin' so call on turf of H/triggered mob.
	else // 20% chance here or if next-barb-trip is not over and we failed prob(80).
		if(prob(50)) // 50% chance to 'almost' trip/tangle.
			to_chat(H, SPAN_WARNING("[pick("<font size = 1.5><b>You almost trip!</b></font>", "<font size = 1.5><b>You almost get tangled in \the [src]!</b></font>")]")) // Spammy for each instance, add cooldown~ [?] ]
		if(prob(35) && H.stat == CONSCIOUS) // 35% chance to scream on pain. (If not next-barb-trip/prob(80)).
			H.emote("painscream") // Has an internal cooldown, so won't spam.
	playsound(loc, pick('sound/effects/barbwire1.ogg', 'sound/effects/barbwire2.ogg', 'sound/effects/barbwire3.ogg'), 50, TRUE)

/obj/structure/barbwire/Uncross(mob/living/human/M) // Non-Humans will never get stuck in here.
	if(!ishuman(M)) return TRUE //; we type-cast in the argument of the proc.

	var/turf/TT = get_turf(M) // Start-Turf
	var/turf/T = get_step(M, M.dir) // Gutted `neighbor_turf_passable` to check if the turf we are moving into is blocked or not. (This is target-turf)

	if (!T || !istype(T) || T.density) // `M.Adjacent(T)` Handles movement into barriers SPECIFICALLY in our way. (Applies for turf/wall and any other things that block passage.)
		to_chat(M, SPAN_WARNING("You can't <b>go</b> this way, it's <b>blocked</b>!")) // NOTE: Not everything comes off as dense, for example `junk`.
		return FALSE

	for (var/obj/structure/S in TT) // Iterate over all objects in the start-turf. (TODO: FIX-Climbing and attempting to collide whilst climbing will bypass these checks for whatever reason)
		if(S.dir == M.dir && S.can_climb(M, suppress_feedback = TRUE))
			to_chat(M, SPAN_WARNING("You can't <b>go</b> this way, <b>Try climbing!</b>"))
			return FALSE
	for (var/obj/O in T)  // Iterate over all objects in the target-turf. (TODO: FIX-Climbing and attempting to collide whilst climbing will bypass these checks for whatever reason)
		if (istype(O, /obj/structure)) // Type-cast to the superclass which gives us access to structure procs and variables.
			var/obj/structure/S = O
			if (!(S.flags & ON_BORDER)) //ON_BORDER structures are handled a bit differently.
				if(S.can_climb(M, suppress_feedback = TRUE)) // Does a `climbable` var-check internally also.
					to_chat(M, SPAN_WARNING("You can't <b>go</b> this way, <b>Try climbing!</b>"))
					return FALSE
				else if (S.density || istype(S, /obj/structure/props/junk)) // TODO: Junk density whilst still allowing bullets, etc.
					to_chat(M, SPAN_WARNING("You can't <b>go</b> this way, it's <b>blocked</b>!")) // NOTE: Not everything comes off as dense, for example `junk`.
					return FALSE
			if (S.flags & ON_BORDER)
				if (!M.Adjacent(S)) // Niche fix to walk on other barriers around us. BORDER flags are handled here.
					if(S.can_climb(M, suppress_feedback = TRUE))
						to_chat(M, SPAN_WARNING("You can't <b>go</b> this way, <b>Try climbing!</b>"))
						return FALSE
		if (O && O.density && !(O.flags & ON_BORDER)) // For cover walls [not just structures] and what-not.
			to_chat(M, SPAN_WARNING("You can't <b>go</b> this way, it's <b>blocked</b>!")) // NOTE: Not everything comes off as dense, for example `junk`.
			return FALSE

	if (allow_passage) // After we pass collision checks.
		allow_passage = FALSE
		return TRUE // Allow them/other mobs to leave once.

	if (prob(55)) // Pain will get you from initial cuts, if the barbed defense is not manned, then sure, you can generally pass without much issue.
		M.visible_message(SPAN_DANGER("[M] frees themself from the barbed wire!"), SPAN_WARNING("You <b>free</b> yourself from the barbed wire!"))
		return TRUE // Pass.
	else
		M.visible_message(SPAN_DANGER("[M] struggles to free themselves from the barbed wire!"), SPAN_WARNING("You <b>struggle</b> to free yourself from the barbed wire!"))
		var/obj/item/organ/external/affecting = M.get_organ(pick("l_foot", "r_foot", "l_leg", "r_leg"))
		playsound(loc, "stab_sound", 40, TRUE)
		if (affecting.take_damage(2, FALSE))
			M.UpdateDamageIcon()
		return FALSE // Deny.

/obj/structure/barbwire/attackby(obj/item/W, mob/living/human/H)
	if(!anchored) return
	if(!ishuman(H)) return

	if (istype(W, /obj/item/weapon/wirecutters))
		H.visible_message(SPAN_NOTICE("[H] starts to cut through \the [src] with \the [W]."))
		if (!do_after(H, 5 SECONDS))
			H.visible_message(SPAN_NOTICE("[H] decides not to cut through \the [src]."))
			return
		H.visible_message(SPAN_NOTICE("[H] finishes cutting through \the [src]!"))
		playsound(loc, 'sound/items/Wirecutter.ogg', 60, TRUE)
		qdel(src)
		return

	else if (W.sharp)
		H.visible_message(SPAN_NOTICE("[H] starts to hack through \the [src] with \the [W]."))
		if (!do_after(H, 8 SECONDS))
			H.visible_message(SPAN_NOTICE("[H] decides to not hack through \the [src]."))
			return

		if (prob(66)) // More than likely.
			H.visible_message(SPAN_NOTICE("[H] finishes hacking through \the [src]!"), SPAN_NOTICE("You finish hacking through \the [src]!"))
			playsound(loc, 'sound/items/Wirecutter.ogg', 45, TRUE)
			qdel(src)
		else
			var/obj/item/organ/external/affecting = H.hand // 0 for right. 1 for left.
			if (affecting == 0) 
				affecting = H.get_organ("r_hand") // left...
			else
				affecting = H.get_organ("l_hand") // right...

			playsound(loc, pick('sound/effects/barbwire1.ogg','sound/effects/barbwire2.ogg','sound/effects/barbwire3.ogg'), 50, TRUE)
			if (affecting.take_damage(15, FALSE))
				H.UpdateDamageIcon()
			H.updatehealth()
			to_chat(H, SPAN_DANGER("Your hand slips, causing \the [src] to [pick("gauge", "rend", "rip", "lacerate", "tear", "slice")] your [affecting.name] open!"))

/obj/item/stack/material/barbwire/attack_self(mob/living/human/H) // Quality-of-Life that doesn't let the build-menu open. But people can still toggle the menu and walk over the barb-wire, though there is other code to prevent that.
	if(!ishuman(H)) return

	for (var/obj/structure/barbwire/B in get_turf(H))
		to_chat(H, SPAN_WARNING("There's already barbed wire here!"))
		return
	..()