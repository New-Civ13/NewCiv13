///////////////////////////////COVER WALL BORDERS//////////////////////////////
/obj/covers/check_relatives(var/update_self = FALSE, var/update_others = FALSE)
	if (!adjusts)
		return
	var/junction
	if (update_self)
		junction = FALSE
	for (var/checkdir in cardinal)
		var/turf/T = get_step(src, checkdir)
		for(var/atom/CV in T)
			if (!can_join_with(CV))
				continue
			if (update_self)
				if (can_join_with(CV))
					junction |= get_dir(src,CV)
			if (update_others)
				CV.check_relatives(1,0)
	if (!isnull(junction))
		icon_state = "[base_icon_state][junction]"
	return

/obj/covers/can_join_with(var/atom/W)
	if (istype(W,src))
		return TRUE
	return FALSE

/obj/covers/update_icon()
	..()
	check_relatives(1,1)
	overlays.Cut()
	overlays |= bullethole_overlays
	if (moldy>0)
		overlays += image(icon = 'icons/turf/walls.dmi', icon_state = "mold[moldy]", layer = src.layer+0.02)
	if (cracked>0)
		overlays += image(icon = 'icons/turf/walls.dmi', icon_state = "cracks[cracked]", layer = src.layer+0.01)
/obj/covers/New()
	..()
	check_relatives(1,1)

/obj/covers/Destroy()
	check_relatives(0,1)
	..()

/obj/covers/proc/new_bullethole()
	if (bullethole_count.len >= 13)
		return
	if (!wall)
		return
	var/list/opts = list(1,2,3,4,5,6,7,8,9,10,11,12,13)
	for(var/i in bullethole_count)
		opts -= i
	if (isemptylist(opts))
		return
	var/chnum = pick(opts)
	var/tmp_bullethole = image(icon = 'icons/turf/walls.dmi', icon_state = "bullethole[chnum]", layer = src.layer+0.01)
	bullethole_overlays += tmp_bullethole
	bullethole_count += list(chnum)
	update_icon()

////////////////////////////////////////////////////////////

/* Wood Walls*/

/obj/covers/wood_wall
	name = "soft wood wall"
	desc = "A wood wall."
	icon = 'icons/turf/walls.dmi'
	icon_state = "b_wood_wall"
	passable = FALSE
	not_movable = TRUE
	density = TRUE
	opacity = TRUE
	amount = 4
	layer = 3
	health = 300
	wall = TRUE
	explosion_resistance = 5
	material = "Wood"
	hardness = 75

/obj/covers/wood_wall/nonadjustable
	icon_state = "new_wood0"
	base_icon_state = "new_wood"
	adjusts = FALSE

/obj/covers/wood_wall/adjustable
	icon_state = "woodwall0"
	base_icon_state = "woodwall"
	adjusts = TRUE

/obj/covers/wood_wall/abashiri
	icon_state = "abashiri0"
	base_icon_state = "abashiri"
	adjusts = TRUE
	health = 400
	explosion_resistance = 6
	mergewith = list(/obj/structure/window/classic/abashiri,/obj/structure/window_frame/abashiri,/turf/wall/abashiri,/obj/covers/wood_wall/abashiri)
/obj/covers/wood_wall/abashiri/can_join_with(var/atom/W)
	if (istype(W,src))
		return TRUE
	for (var/i in mergewith)
		if (istype(W,i))
			return TRUE
/obj/covers/wood_wall/medieval
	name = "medieval wall"
	desc = "A dark-ages wall."
	icon = 'icons/turf/walls.dmi'
	icon_state = "medieval0"
	base_icon_state = "medieval"
	health = 330
	adjusts = TRUE
	mergewith = list(/obj/structure/window/classic/medieval,/obj/structure/window_frame/medieval,/obj/covers/wood_wall/medieval)
/obj/covers/wood_wall/medieval/can_join_with(var/atom/W)
	if (istype(W,src))
		return TRUE
	for (var/i in mergewith)
		if (istype(W,i))
			return TRUE

/obj/covers/wood_wall/medieval/x
	name = "medieval wall crossbeam"
	desc = "A dark-ages wall with an x shaped support."
	icon = 'icons/turf/walls.dmi'
	icon_state = "medieval_wall_x"
	health = 335

/obj/covers/wood_wall/medieval/y/r
	name = "medieval wall crossbeam"
	desc = "A dark-ages wall with an slanted support."
	icon = 'icons/turf/walls.dmi'
	icon_state = "medieval_wall_y1"
	health = 335

/obj/covers/wood_wall/medieval/y/l
	name = "medieval wall crossbeam"
	desc = "A dark-ages wall with an slanted support."
	icon = 'icons/turf/walls.dmi'
	icon_state = "medieval_wall_y2"
	health = 335

/obj/covers/wood_wall/dark
	name =  "dark soft wood wall"
	icon_state = "oldwood0"
	base_icon_state = "oldwood"
	adjusts = TRUE

/* Asia-Themed Walls - End*/

/obj/covers/wood_wall/oriental
	name = "oriental wall"
	desc = "A east-oriental style wall."
	icon = 'icons/turf/walls.dmi'
	icon_state = "oriental"
	health = 330

/obj/covers/wood_wall/oriental/b
	name = "braced oriental wall"
	icon = 'icons/turf/walls.dmi'
	icon_state = "orientalb"
	health = 335

/obj/covers/wood_wall/oriental/doorway
	name = "oriental doorway"
	desc = "A east-oriental style doorway."
	icon = 'icons/turf/walls.dmi'
	icon_state = "oriental-door"
	density = FALSE
	opacity = FALSE
	health = 335

/obj/covers/wood_wall/oriental/twop
	name = "two panelled oriental wall"
	icon = 'icons/turf/walls.dmi'
	icon_state = "oriental_twop"
	health = 330

/obj/covers/wood_wall/oriental/twop/b
	name = "two panelled braced oriental wall"
	icon = 'icons/turf/walls.dmi'
	icon_state = "oriental_twopb"
	health = 335

/obj/covers/wood_wall/oriental/threep
	name = "three panelled oriental wall"
	icon = 'icons/turf/walls.dmi'
	icon_state = "oriental_threep"
	health = 330

/obj/covers/wood_wall/oriental/threep/b
	name = "three panelled braced oriental wall"
	icon = 'icons/turf/walls.dmi'
	icon_state = "oriental_threepb"
	health = 335

/obj/covers/wood_wall/shoji
	name = "shoji wall"
	desc = "A shoji paper wall."
	icon = 'icons/turf/walls.dmi'
	icon_state = "shoji_wall2"
	passable = TRUE
	not_movable = TRUE
	density = TRUE
	opacity = TRUE
	amount = 3
	layer = 3
	health = 70
	wall = TRUE
	explosion_resistance = 1
	material = "Wood"
	hardness = 30

/obj/covers/wood_wall/shoji_divider
	name = "shoji dividing wall"
	desc = "A shoji paper wall. This one is more meant to divide rooms."
	icon = 'icons/turf/walls.dmi'
	icon_state = "shoji_wall"
	passable = TRUE
	not_movable = TRUE
	density = TRUE
	opacity = TRUE
	amount = 3
	layer = 3
	health = 50
	wall = TRUE
	explosion_resistance = 1
	material = "Wood"
	hardness = 20

/obj/covers/wood_wall/bamboo
	name = "bamboo wall"
	desc = "A wall made from bamboo."
	icon = 'icons/obj/bamboostuff.dmi'
	icon_state = "bamboo"
	health = 230
	amount = 3
	layer = 3
	health = 70
	wall = TRUE
	explosion_resistance = 3
	material = "Wood"
	hardness = 40

/* Asia-Themed Walls - End*/

/obj/covers/wood_wall/log
	name = "log wall"
	desc = "A log wall."
	icon = 'icons/turf/walls.dmi'
	icon_state = "log_wall"
	passable = FALSE
	not_movable = TRUE
	density = TRUE
	opacity = TRUE
	amount = 4
	layer = 3
	health = 330
	wall = TRUE
	explosion_resistance = 7
	material = "Wood"
	hardness = 80

/obj/covers/wood_wall/log/corner
	icon_state = "log_wall_corner"
	material = "Wood"
	passable = FALSE

/* Wood Walls - End*/

/obj/covers/stone_wall
	name = "rough stone wall"
	desc = "A rough stone wall."
	icon = 'icons/turf/walls.dmi'
	icon_state = "b_stone_wall" // TBD; replace with rough variant.
	passable = FALSE
	not_movable = TRUE
	density = TRUE
	opacity = TRUE
	amount = 0
	layer = 3
	health = 2000
	wood = FALSE
	wall = TRUE
	flammable = FALSE
	explosion_resistance = 7
	material = "Stone"
	hardness = 100
	buildstack = /obj/item/stack/material/stone
	adjusts = FALSE
	var/in_progress // Used to keep track of on-going events like the WWinput, and prevent repeats until the original is over.
	var/design = "Rough" // Where we store the current design of the wall. (for chisels)

/obj/covers/stone_wall/plain
	name = "smooth stone wall"
	desc = "A smooth stone wall."
	design = "Smooth"

/obj/covers/stone_wall/attackby(obj/item/W as obj, mob/living/human/user as mob)
	if (istype(W, /obj/item/weapon/chisel))
		if (in_progress) return // Have we already began? ~Don't start WWinput if triggered.
		else if (!istype(user.l_hand, /obj/item/weapon/hammer) && !istype(user.r_hand, /obj/item/weapon/hammer))
			to_chat(user, SPAN_WARNING("You need to have a hammer in one of your hands to use a chisel."))
			return

		var/display = list("Smooth", "Brick", "Cobbled", "Tiled", "Rough", "Cancel") // Designs possible are "smooth", "brick", "cobbled", "tiled", "rough".
		var/input =  WWinput(user, "What design do you want to carve?", "Carving", "Cancel", display)
		if (!input) return // You cancelled!

		else if (input == design)
			to_chat(user, SPAN_WARNING("\The [src] is already carved into a [lowertext(input)] design!"))
			return

		else if (!in_progress) // Secondary check, in-case they spam the WWinput. (Prevents the do_after from cancelling.)
			if(user in range(1, src)) // To prevent carving from afar, by delaying WWinput answer and then moving away.
				in_progress = TRUE
				user.visible_message(SPAN_NOTICE("[user] starts to carve out a design into \the [src]."), SPAN_NOTICE("You start to carve out a <b>[lowertext(input)]</b> design into \the [src]."))
				playsound(src,'sound/effects/pickaxe.ogg',60,1)
				if (!do_after(user, 6 SECONDS, src))
					user.visible_message(SPAN_NOTICE("[user] changes their mind and stops carving into \the [src]."), SPAN_NOTICE("You change your mind and stop carving.")) // Niche interrupt msg.
					in_progress = FALSE
					return

				user.visible_message(SPAN_NOTICE("[user] finishes carving out a [lowertext(input)] design into \the [src]."), SPAN_NOTICE("You finish carving out the [lowertext(input)] design into \the [src]."))

				switch(input)
					if("Smooth")
						icon_state = "b_stone_wall" // TBD; replace with smooth variant.
						name = "smooth stone wall"
						desc = "A smooth stone wall."
					if("Brick")
						icon_state = "b_brick_stone_wall"
						name = "stone brick wall"
						desc = "A stone wall carved to look like its made of stone bricks."
					if("Cobbled")
						icon_state = "b_cobbled_stone_wall"
						name = "cobbled stone wall"
						desc = "A stone wall carved to look like piled up stones."
					if("Tiled")
						icon_state = "b_tiled_stone_wall"
						name = "tiled stone wall"
						desc = "A stone wall carved to have a tiled stone pattern."
					if("Rough")
						name = "rough stone wall"
						desc = "A rough stone wall."
						icon_state = "b_stone_wall" // TBD; replace with rough variant.

				in_progress = FALSE
				design = input // Store the design we just carved, to check if we will re-carve the same design next time.
				return

	else if (istype(W, /obj/item/weapon/material/kitchen/utensil/spoon) || istype(W, /obj/item/weapon/material/kitchen/utensil/fork) || istype(W, /obj/item/weapon/material/kitchen/utensil/chopsticks))	
		var/obj/item/weapon/material/kitchen/utensil/I = W // Typecast
		user.setClickCooldown(rand(8,12))

		if (I.shiv <= 10)
			I.shiv += rand(1,3) // Min of 4 times to sharpen fully if lucky.
			// playsound(src, ) - add a sound for sharpening. TODO.
			var/sharpening_verb = pick("grind", "sharpen", "whittle away", "hone", "file", "polish", "whet") // So we get the same consistency in picking on both self_message and message.
			user.visible_message(SPAN_WARNING("[user] [sharpening_verb]s \the [I] on \the [src]!"), 
								SPAN_WARNING("You <b>[sharpening_verb]</b> \the [I] on \the [src]."),
							)
			return

		else // var/shiv reaches past 10.
			user.drop_from_inventory(I)
			var/obj/item/weapon/material/kitchen/utensil/knife/shank/SHK = new /obj/item/weapon/material/kitchen/utensil/knife/shank(user, I.material.name)
			user.put_in_hands(SHK)
			to_chat(user, SPAN_NOTICE("\The [I] turns into a shank."))
			qdel(I)
			return
	
	else ..() // Anything else not caught by the checks goes straight to hitting.

/obj/covers/marble_wall
	name = "rough marble wall"
	desc = "A rough marble wall."
	icon = 'icons/turf/walls.dmi'
	icon_state = "b_marble_wall" // TBD; replace with rough variant.
	passable = TRUE
	not_movable = TRUE
	density = TRUE
	opacity = TRUE
	amount = 0
	layer = 3
	health = 2000
	wood = FALSE
	wall = TRUE
	flammable = FALSE
	explosion_resistance = 7
	material = "Stone"
	hardness = 100
	buildstack = /obj/item/stack/material/marble
	adjusts = FALSE
	var/in_progress // Used to keep track of on-going events like the WWinput, and prevent repeats until the original is over. (Until we get a functional do_after system.)
	var/design = "Rough" // Where we store the current design of the wall. (for chisels)

/obj/covers/marble_wall/attackby(obj/item/W as obj, mob/living/human/user as mob)
	if (istype(W, /obj/item/weapon/chisel))
		if (in_progress) return // Have we already began? ~Don't start WWinput if triggered.
		else if (!istype(user.l_hand, /obj/item/weapon/hammer) && !istype(user.r_hand, /obj/item/weapon/hammer))
			to_chat(user, SPAN_WARNING("You need to have a hammer in one of your hands to use a chisel."))
			return

		var/display = list("Smooth", "Brick", "Cobbled", "Tiled", "Rough", "Cancel") // Designs possible are "smooth", "brick", "cobbled", "tiled", "rough".
		var/input =  WWinput(user, "What design do you want to carve?", "Carving", "Cancel", display)
		if (!input) return // You cancelled!

		else if (input == design)
			to_chat(user, SPAN_WARNING("\The [src] is already carved into a [lowertext(input)] design!"))
			return

		else if (!in_progress) // Secondary check, in-case they spam the WWinput. (Prevents the do_after from cancelling.)
			if(user in range(1, src)) // To prevent carving from afar, by delaying WWinput answer and then moving away.
				in_progress = TRUE
				user.visible_message(SPAN_NOTICE("[user] starts to carve out a design into \the [src]."), SPAN_NOTICE("You start to carve out a <b>[lowertext(input)]</b> design into \the [src]."))
				playsound(src, 'sound/effects/pickaxe.ogg', 60, TRUE)
				if (!do_after(user, 6 SECONDS, src))
					user.visible_message(SPAN_NOTICE("[user] changes their mind and stops carving into \the [src]."), SPAN_NOTICE("You change your mind and stop carving.")) // Niche interrupt msg.
					in_progress = FALSE
					return

				user.visible_message(SPAN_NOTICE("[user] finishes carving out a [lowertext(input)] design into \the [src]."), SPAN_NOTICE("You finish carving out the [lowertext(input)] design into \the [src]."))

				switch(input) // We put this after the visb_msg so that it says the original design name, without taking any additional processing/vars to do so.
					if("Smooth")
						icon_state = "b_marble_wall" // TBD; replace with smooth variant.
						name = "smooth marble wall"
						desc = "A smooth marble wall."
					if("Brick")
						icon_state = "b_brick_marble_wall"
						name = "marble brick wall"
						desc = "A marble wall carved to look like its made of marble bricks."
					if("Cobbled")
						icon_state = "b_cobbled_marble_wall"
						name = "cobbled marble wall"
						desc = "A marble wall carved to look like piled up stones."
					if("Tiled")
						icon_state = "b_tiled_marble_wall"
						name = "tiled marble wall"
						desc = "A marble wall carved to have a tiled marble pattern."
					if("Rough")
						name = "rough marble wall"
						desc = "A rough marble wall."
						icon_state = "b_marble_wall" // TBD; replace with rough variant.

				in_progress = FALSE
				design = input // Store the design we just carved, to check if we will re-carve the same design next time.
				return

	else if (istype(W, /obj/item/weapon/material/kitchen/utensil/spoon) || istype(W, /obj/item/weapon/material/kitchen/utensil/fork) || istype(W, /obj/item/weapon/material/kitchen/utensil/chopsticks))	
		var/obj/item/weapon/material/kitchen/utensil/I = W // Typecast
		user.setClickCooldown(rand(8,12))

		if (I.shiv <= 10)
			I.shiv += rand(1,3) // Min of 4 times to sharpen fully if lucky.
			// playsound(src, ) - add a sound for sharpening. TODO.
			var/sharpening_verb = pick("grind", "sharpen", "whittle away", "hone", "file", "polish", "whet") // So we get the same consistency in picking on both self_message and message.
			user.visible_message(SPAN_WARNING("[user] [sharpening_verb]s \the [I] on \the [src]!"), 
								SPAN_WARNING("You <b>[sharpening_verb]</b> \the [I] on \the [src]."),
							)
			return

		else // var/shiv reaches past 10.
			user.drop_from_inventory(I)
			var/obj/item/weapon/material/kitchen/utensil/knife/shank/SHK = new /obj/item/weapon/material/kitchen/utensil/knife/shank(user, I.material.name)
			user.put_in_hands(SHK)
			to_chat(user, SPAN_NOTICE("\The [I] turns into a shank."))
			qdel(I)
			return
	
	else ..() // Anything else not caught by the checks goes straight to hitting.

/obj/covers/marble_wall/plain
	name = "smooth marble wall"
	desc = "A smooth marble wall."
	design = "Smooth"

/obj/covers/sandstone_wall
	name = "sandstone tiled wall"
	desc = "A sandstone tiled wall."
	icon = 'icons/turf/walls.dmi'
	icon_state = "sandstone_brick" // TBD; replace with `tiled` variant.
	passable = TRUE
	not_movable = TRUE
	density = TRUE
	opacity = TRUE
	amount = 0
	layer = 3
	health = 2000
	wood = FALSE
	wall = TRUE
	flammable = FALSE
	explosion_resistance = 7
	material = "Stone"
	hardness = 100
	buildstack = /obj/item/stack/material/sandstone

/obj/covers/sandstone_wall/attackby(obj/item/W as obj, mob/living/human/user as mob)
	if (istype(W, /obj/item/weapon/material/kitchen/utensil/spoon) || istype(W, /obj/item/weapon/material/kitchen/utensil/fork) || istype(W, /obj/item/weapon/material/kitchen/utensil/chopsticks))	
		var/obj/item/weapon/material/kitchen/utensil/I = W // Typecast
		user.setClickCooldown(rand(8,12))

		if (I.shiv <= 10)
			I.shiv += rand(1,3) // Min of 4 times to sharpen fully if lucky.
			// playsound(src, ) - add a sound for sharpening. TODO.
			var/sharpening_verb = pick("grind", "sharpen", "whittle away", "hone", "file", "polish", "whet") // So we get the same consistency in picking on both self_message and message.
			user.visible_message(SPAN_WARNING("[user] [sharpening_verb]s \the [I] on \the [src]!"), 
								SPAN_WARNING("You <b>[sharpening_verb]</b> \the [I] on \the [src]."),
							)
			return

		else // var/shiv reaches past 10.
			user.drop_from_inventory(I)
			var/obj/item/weapon/material/kitchen/utensil/knife/shank/SHK = new /obj/item/weapon/material/kitchen/utensil/knife/shank(user, I.material.name)
			user.put_in_hands(SHK)
			to_chat(user, SPAN_NOTICE("\The [I] turns into a shank."))
			qdel(I)
			return
	
	else ..() // Anything else not caught by the checks goes straight to hitting.

/obj/covers/sandstone_smooth_wall //just a parent to the real smooth sandstone wall.
	name = "rough sandstone wall"
	desc = "A rough sandstone wall."
	icon = 'icons/turf/walls.dmi'
	icon_state = "sandstone_smooth" // TBD; replace with rough variant.
	passable = TRUE
	not_movable = TRUE
	density = TRUE
	opacity = TRUE
	amount = 0
	layer = 3
	health = 2000
	wood = FALSE
	wall = TRUE
	flammable = FALSE
	explosion_resistance = 7
	material = "Stone"
	hardness = 100
	buildstack = /obj/item/stack/material/sandstone
	var/in_progress // Used to keep track of on-going events like the WWinput, and prevent repeats until the original is over. (Until we get a functional do_after system.)
	var/design = "Rough" // Where we store the current design of the wall. (for chisels)

/obj/covers/sandstone_smooth_wall/plain
	name = "smooth sandstone wall"
	desc = "A smooth sandstone wall."
	design = "Smooth"

/obj/covers/sandstone_smooth_wall/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/chisel))
		if (in_progress) return // Have we already began? ~Don't start WWinput if triggered.
		else if (!istype(user.l_hand, /obj/item/weapon/hammer) && !istype(user.r_hand, /obj/item/weapon/hammer))
			to_chat(user, SPAN_WARNING("You need to have a hammer in one of your hands to use a chisel."))
			return

		var/display = list("Smooth", "Brick", "Cobbled", "Rough", "Cancel") // Designs possible are "smooth", "cobbled", "tiled", "rough".
		var/input =  WWinput(user, "What design do you want to carve?", "Carving", "Cancel", display)
		if (!input) return // You cancelled!

		else if (input == design)
			to_chat(user, SPAN_WARNING("\The [src] is already carved into a [lowertext(input)] design!"))
			return

		else if (!in_progress) // Secondary check, in-case they spam the WWinput. (Prevents the do_after from cancelling.)
			if(user in range(1, src)) // To prevent carving from afar, by delaying WWinput answer and then moving away.
				in_progress = TRUE
				user.visible_message(SPAN_NOTICE("[user] starts to carve out a design into \the [src]."), SPAN_NOTICE("You start to carve out a <b>[lowertext(input)]</b> design into \the [src]."))
				playsound(src, 'sound/effects/pickaxe.ogg', 60, TRUE)
				if (!do_after(user, 6 SECONDS, src))
					user.visible_message(SPAN_NOTICE("[user] changes their mind and stops carving into \the [src]."), SPAN_NOTICE("You change your mind and stop carving.")) // Niche interrupt msg.
					in_progress = FALSE
					return

				user.visible_message(SPAN_NOTICE("[user] finishes carving out a [lowertext(input)] design into \the [src]."), SPAN_NOTICE("You finish carving out the [lowertext(input)] design into \the [src]."))

				switch(input) // We put this after the visb_msg so that it says the original design name, without taking any additional processing/vars to do so.
					if("Smooth")
						icon_state = "sandstone_smooth" // TBD; replace with smooth variant.
						name = "smooth sandstone wall"
						desc = "A smooth sandstone wall."
					if("Brick")
						icon_state = "sandstone_brick"
						name = "sandstone brick wall"
						desc = "A sandstone wall carved to look like its made out of sandstone bricks."
					if("Cobbled")
						icon_state = "sandstone_cobble" // TBD; replace with a same-color variant.
						name = "cobbled sandstone wall"
						desc = "A sandstone wall carved to have a cobbled sandstone pattern."
					if("Rough")
						name = "rough sandstone wall"
						desc = "A rough sandstone wall."
						icon_state = "sandstone_smooth" // TBD; replace with rough variant.

				in_progress = FALSE
				design = input // Store the design we just carved, to check if we will re-carve the same design next time.
				return

	else if (istype(W, /obj/item/weapon/material/kitchen/utensil/spoon) || istype(W, /obj/item/weapon/material/kitchen/utensil/fork) || istype(W, /obj/item/weapon/material/kitchen/utensil/chopsticks))
		var/obj/item/weapon/material/kitchen/utensil/I = W // Typecast
		user.setClickCooldown(rand(8,12))

		if (I.shiv <= 10)
			I.shiv += rand(1,3) // Min of 4 times to sharpen fully if lucky.
			// playsound(src, ) - add a sound for sharpening. TODO.
			var/sharpening_verb = pick("grind", "sharpen", "whittle away", "hone", "file", "polish", "whet") // So we get the same consistency in picking on both self_message and message.
			user.visible_message(SPAN_WARNING("[user] [sharpening_verb]s \the [I] on \the [src]!"), 
								SPAN_WARNING("You <b>[sharpening_verb]</b> \the [I] on \the [src]."),
							)
			return

		else // var/shiv reaches past 10.
			user.drop_from_inventory(I)
			var/obj/item/weapon/material/kitchen/utensil/knife/shank/SHK = new /obj/item/weapon/material/kitchen/utensil/knife/shank(user, I.material.name)
			user.put_in_hands(SHK)
			to_chat(user, SPAN_NOTICE("\The [I] turns into a shank."))
			qdel(I)
			return
	
	else ..() // Anything else not caught by the checks goes straight to hitting.

/obj/covers/sandstone_wall/classic
	name = "sandstone block wall"
	desc = "A sandstone block wall."
	icon = 'icons/turf/walls.dmi'
	icon_state = "sandstone_block_wall0"
	base_icon_state = "sandstone_block_wall"
	adjusts = TRUE

/obj/covers/sandstone_wall/classic/red
	name = "red sandstone block wall"
	desc = "A red sandstone block wall."
	icon_state = "redsandstone_block_wall0"
	base_icon_state = "redsandstone_block_wall"

/obj/covers/sandstone_wall/brick
	name = "sandstone brick wall"
	desc = "A sandstone brick wall."
	icon = 'icons/turf/walls.dmi'
	icon_state = "sandstone_brickwall0"
	base_icon_state = "sandstone_brickwall"
	passable = TRUE
	not_movable = TRUE
	density = TRUE
	opacity = TRUE
	amount = 0
	layer = 3
	health = 2000
	wood = FALSE
	wall = TRUE
	flammable = FALSE
	explosion_resistance = 7
	material = "Stone"
	hardness = 100
	buildstack = /obj/item/stack/material/sandstone
	adjusts = TRUE

/obj/covers/sandstone_wall/egyptian
	name = "egyptian sandstone wall"
	desc = "An egyptian-style sandstone wall."
	icon_state = "new_egyptian0"
	base_icon_state = "new_egyptian"
	adjusts = TRUE

/obj/covers/sandstone_wall/fortress
	name = "sandstone fortress brick wall"
	desc = "A dense sandstone fortress brick wall."
	icon_state = "sandstone_fortress0"
	base_icon_state = "sandstone_fortress"
	adjusts = TRUE
	health = 3250
	explosion_resistance = 7
	buildstack = /obj/item/stack/material/stonebrick

/obj/covers/dirt_wall
	name = "dirt wall"
	desc = "A dirt wall."
	icon = 'icons/turf/walls.dmi'
	icon_state = "drydirt_wall"
	passable = TRUE
	material = "dirt"
	not_movable = TRUE
	density = TRUE
	opacity = TRUE
	amount = 0
	layer = 3
	health = 90
	wood = FALSE
	wall = TRUE
	flammable = FALSE
	explosion_resistance = 3
	hardness = 65
	buildstack = /obj/item/weapon/barrier

/obj/covers/straw_wall
	name = "straw wall"
	desc = "A straw wall. Looks flimsy."
	icon = 'icons/turf/walls.dmi'
	icon_state = "straw_wallh"
	passable = TRUE
	not_movable = TRUE
	density = TRUE
	opacity = TRUE
	amount = 1
	layer = 3
	health = 75
	wood = TRUE
	wall = TRUE
	explosion_resistance = 2
	material = "Wood"
	hardness = 30

/obj/covers/vault
	name = "vault wall"
	desc = "A very strong wall of concrete."
	icon = 'icons/obj/structures.dmi'
	icon_state = "vault"
	passable = TRUE
	not_movable = TRUE
	density = TRUE
	opacity = TRUE
	amount = 0
	layer = 3
	health = 4000
	wood = FALSE
	wall = TRUE
	flammable = FALSE
	explosion_resistance = 100
	material = "Stone"
	hardness = 100
	buildstack = /obj/item/weapon/clay/advclaybricks/fired/cement

/obj/covers/divider_wall
	name = "divider wall"
	desc = "A divider wall so you don't see what's next to you. Looks flimsy."
	icon = 'icons/turf/walls.dmi'
	icon_state = "divider0"
	base_icon_state = "divider"
	passable = TRUE
	not_movable = TRUE
	density = TRUE
	opacity = TRUE
	amount = 0
	layer = 3
	health = 6
	wood = TRUE
	wall = TRUE
	explosion_resistance = 0
	material = "Wood"
	hardness = 1
	adjusts = TRUE

/obj/covers/tent
	name = "tent wall"
	desc = "A tent wall to protect you against the elements, neat! It looks flimsy though."
	icon = 'icons/turf/walls.dmi'
	icon_state = "tent0"
	base_icon_state = "tent"
	passable = TRUE
	not_movable = TRUE
	density = TRUE
	opacity = TRUE
	amount = 0
	layer = 3
	health = 50
	wood = FALSE
	wall = TRUE
	explosion_resistance = 2
	material = "Wood"
	hardness = 1
	adjusts = TRUE

/obj/covers/slate
	name = "slatestone wall"
	desc = "A slate wall."
	icon = 'icons/obj/structures.dmi'
	icon_state = "slate"
	passable = TRUE
	not_movable = TRUE
	density = TRUE
	opacity = TRUE
	amount = 0
	layer = 3
	health = 500
	wood = FALSE
	wall = TRUE
	flammable = FALSE
	explosion_resistance = 10
	material = "Stone"
	hardness = 100

/obj/covers/sovietwall
	name = "Soviet tiles wall"
	desc = "A cheap tiled wall."
	icon = 'icons/turf/walls.dmi'
	icon_state = "sovietwall_one"
	passable = TRUE
	not_movable = TRUE
	density = TRUE
	opacity = TRUE
	amount = 0
	layer = 3
	health = 300
	wood = FALSE
	wall = TRUE
	flammable = FALSE
	explosion_resistance = 40
	material = "Clay"
	hardness = 100

/obj/covers/wood_wall/aztec
	name = "aztec wood wall"
	desc = "A wood wall, in aztec style."
	icon_state = "aztec0"
	base_icon_state = "aztec"
	adjusts = TRUE

/obj/covers/wood_wall/nordic
	name = "nordic wood wall"
	desc = "A wood wall, in northern european style."
	icon_state = "nordic0"
	base_icon_state = "nordic"
	adjusts = TRUE

/obj/covers/stone_wall/mayan
	name = "mayan stone wall"
	desc = "A mayan-style stone wall."
	icon_state = "mayan0"
	base_icon_state = "mayan"
	adjusts = TRUE

/obj/covers/stone_wall/classic
	name = "stone block wall"
	desc = "A stone block wall."
	icon_state = "stone_block_wall0"
	base_icon_state = "stone_block_wall"
	adjusts = TRUE

/obj/covers/marble_wall/classic
	name = "marble block wall"
	desc = "A marble block wall."
	icon_state = "marble_block_wall0"
	base_icon_state = "marble_block_wall"
	adjusts = TRUE

/obj/covers/marble_wall/grecian //adjustable
	name = "grecian stone wall"
	desc = "A grecian stone wall, it is emblazened with motifs."
	icon_state = "grecian0"
	base_icon_state = "grecian"
	adjusts = TRUE

/obj/covers/stone_wall/roman
	name = "roman stone wall"
	desc = "A roman-style stone wall."
	icon_state = "roman0"
	base_icon_state = "roman"
	adjusts = TRUE

/obj/covers/stone_wall/roman/modern
	name = "tiled white brick wall"
	desc = "A contempoary white stone wall."

/obj/covers/stone_wall/brick
	name = "stone brick wall"
	desc = "A stone brick wall."
	icon_state = "new_stonebrick0"
	base_icon_state = "new_stonebrick"
	adjusts = TRUE
	health = 2750
	buildstack = /obj/item/stack/material/stonebrick

/obj/covers/stone_wall/fortress
	name = "fortress brick wall"
	desc = "A dense fortress brick wall."
	icon_state = "fortress_brickwall0"
	base_icon_state = "fortress_brickwall"
	adjusts = TRUE
	health = 3250
	explosion_resistance = 7
	buildstack = /obj/item/stack/material/stonebrick