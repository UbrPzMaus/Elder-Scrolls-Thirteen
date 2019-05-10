// TES13 restoration spells!

/obj/effect/proc_holder/spell/magicka/channelled/inhand/healinghands
	name = "Healing Hands"
	desc = "Conduct restorative energy through your hands, allowing you to heal anyone near you (or yourself) with a sustained channel of magic."
	human_req = TRUE
	holder_var_amount = 0
	drain = 10
	school = "restoration"
	sound = 'sound/magic/staff_healing.ogg'
	action_icon_state = "bonechill" //placeholder
	inhand_type = /obj/item/gun/medbeam/healinghands

/datum/spellbook_entry/healinghands
	name = "Healing Hands"
	spell_type = /obj/effect/proc_holder/spell/magicka/channelled/inhand/healinghands

/obj/item/gun/medbeam/healinghands
	name = "healing hand"
	desc = "A hand charged with restorative energy."
	icon = 'icons/obj/items_and_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/misc/touchspell_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/touchspell_righthand.dmi'
	icon_state = "zapper"
	item_state = "zapper"
	item_flags = ABSTRACT | DROPDEL
	w_class = WEIGHT_CLASS_HUGE
	force = 0
	throwforce = 0
	throw_range = 0
	throw_speed = 0
	healamt = 2.5 //approximately 10 brute/burn and 2.5 oxy/tox per Life().
	max_range = 4
	pin = /obj/item/firing_pin/magic

/obj/item/gun/medbeam/healinghands/Initialize()
	. = ..()
	add_trait(ABSTRACT_ITEM_TRAIT)

/obj/item/gun/medbeam/healinghands/handle_suicide() //Stops people trying to commit suicide to heal themselves
	return

/obj/item/gun/medbeam/healinghands/dropped(mob/user) //if you drop it, cancel the spell.
	if(user.mind)
		if(user.mind.spell_list)
			for(var/obj/effect/proc_holder/spell/magicka/channelled/inhand/healinghands/spell in user.mind.spell_list)
				if(spell.channel == 1):
					spell.channel = 0

/obj/effect/proc_holder/spell/magicka/channelled/inhand/grandhealing
	name = "Grand Healing"
	desc = "Unleash a burst of restorative magicka, healing yourself and everyone near you of even the most serious injuries."

	holder_var_amount = 30
	drain = 30
	school = "restoration"
	sound = 'sound/magic/staff_healing.ogg'
	action_icon_state = "bonechill" //placeholder
	inhand_type = /obj/item/melee/spellholder/grandhealing

/datum/spellbook_entry/grandhealing
	name = "Grand Healing"
	spell_type = /obj/effect/proc_holder/spell/magicka/channelled/inhand/grandhealing

/obj/item/melee/spellholder/grandhealing
	name = "\improper grand healing"
	desc = "An overwhelmingly powerful restoration spell. You're not sure you can contain this much magicka for long."
	linkedspell = /obj/effect/proc_holder/spell/magicka/channelled/inhand/grandhealing

//WIP - we want this to check for living mobs within 8 tiles and heal. won't bring back the dead, but will do everything else.

/obj/item/melee/spellholder/grandhealing/attack_self(mob/living/user)
	user.visible_message("<span class='warning'>[user] begins to cast a powerful spell!</span>", "<span class='notice'>You begin to cast a powerful spell!</span>")
	if(do_after(user, 30, target=user)) //3 seconds
		to_chat(user, "Debug: spell success!")
		user.reagents.remove_all_type(/datum/reagent/toxin, 100, 0, 1)
		user.setCloneLoss(0, 0)
		user.setOxyLoss(0, 0)
		user.radiation = 0
		user.heal_bodypart_damage(100,100)
		user.adjustToxLoss(-5, 0, TRUE)
		user.hallucination = 0
		user.setBrainLoss(0)
		user.set_blurriness(0)
		user.set_blindness(0)
		user.SetKnockdown(0, FALSE)
		user.SetStun(0, FALSE)
		user.SetUnconscious(0, FALSE)
		user.SetParalyzed(0, FALSE)
		user.SetImmobilized(0, FALSE)
		user.SetSleeping(0, 0)
		qdel(src)

	else
		user.visible_message("<span class='warning'>[user] loses focus on the spell!</span>", "<span class='notice'>You lose focus on the spell!</span>")
		qdel(src)