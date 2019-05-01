//example/debug self spell:

/obj/effect/proc_holder/spell/magicka/self //Targets only the caster, fire-and-forget.
	range = -1 //Duh

/obj/effect/proc_holder/spell/magicka/self/choose_targets(mob/user = usr)
	if(!user)
		revert_cast()
		return
	perform(null,user=user)

/*
/obj/effect/proc_holder/spell/magicka/self/basic_heal //Debug self-cast F&F magicka spell
	name = "Lesser Heal"
	desc = "Heals a small amount of brute and burn damage."
	human_req = TRUE
	holder_var_amount = 10
	school = "restoration"
	sound = 'sound/magic/staff_healing.ogg'

/obj/effect/proc_holder/spell/magicka/self/basic_heal/cast(mob/living/carbon/human/user) //Note the lack of "list/targets" here. Instead, use a "user" var depending on mob requirements.
	//Also, notice the lack of a "for()" statement that looks through the targets. This is, again, because the spell can only have a single target.
	user.visible_message("<span class='warning'>A wreath of gentle light passes over [user]!</span>", "<span class='notice'>You wreath yourself in healing light!</span>")
	user.adjustBruteLoss(-10)
	user.adjustFireLoss(-10)

/datum/spellbook_entry/lesserheal
	name = "Lesser Heal"
	spell_type = /obj/effect/proc_holder/spell/magicka/self/basic_heal
*/

/obj/effect/proc_holder/spell/magicka/channelled //for spells that can be toggled on and off. These spells must affect the caster- to affect others, give them an in-hand item or something.
	var/drain = 0 //drain per 2 seconds
	var/channel = 0
	holder_var_amount = 0 //base cost to activate and deactivate. keep this at 0, since effects only happen on Life() when drain magicka is removed.
	range = -1 //ONLY for self-target spells! see Disintegrate if you want to force an item into their hand that they can affect others with.

/obj/effect/proc_holder/spell/magicka/channelled/proc/disable(mob/user = usr) //custom proc required for each channel to remove any active buffs.
	return

/obj/effect/proc_holder/spell/magicka/channelled/proc/effect(mob/user = usr) //custom proc required for each channel- effect refreshes every 2 seconds (e.g. invisibility).
	return

/obj/effect/proc_holder/spell/magicka/channelled/choose_targets(mob/user = usr)
	if(!user)
		revert_cast()
		return
	perform(null,user=user)

//example/debug channelled spell:

/*
/obj/effect/proc_holder/spell/magicka/channelled/basic_heal_over_time //Debug self-cast heal-over-time magicka spell
	name = "Lesser Heal Over Time"
	desc = "Heals a small amount of brute and burn damage over time."
	human_req = TRUE
	holder_var_amount = 0 //free to activate
	drain = 5 //but costs 5 per 2s to keep it active
	school = "restoration"
	sound = 'sound/magic/staff_healing.ogg'

/obj/effect/proc_holder/spell/magicka/channelled/basic_heal_over_time/cast(mob/living/carbon/human/user)
	if(user.magicka == 0) //no magicka (or antimagic, or dead...)? can't cast
		return 0
	else if(channel == 0)
		user.visible_message("<span class='warning'>A wreath of gentle light passes over [user]!</span>", "<span class='notice'>You wreath yourself in healing light!</span>")
		channel = 1
	else
		channel = 0
		user.visible_message("<span class='warning'>The light around [user] fades!</span>", "<span class='notice'>The healing light around you fades!</span>")

/obj/effect/proc_holder/spell/magicka/channelled/basic_heal_over_time/effect(mob/living/carbon/user) //only checked while active.
	to_chat(user, "<span class='notice'>(DEBUG) You can feel your flesh knitting together!</span>")
	user.adjustBruteLoss(-5)
	user.adjustFireLoss(-5)

/obj/effect/proc_holder/spell/magicka/channelled/basic_heal_over_time/disable(mob/living/carbon/user) //if force disable
	channel = 0
	user.visible_message("<span class='warning'>The light around [user] fades!</span>", "<span class='notice'>The healing light around you fades!</span>")

/datum/spellbook_entry/lesserhealovertime
	name = "Lesser Heal Over Time"
	spell_type = /obj/effect/proc_holder/spell/magicka/channelled/basic_heal_over_time
*/