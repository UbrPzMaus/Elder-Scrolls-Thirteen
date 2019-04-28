//for TES13 magicka-based spells.

/obj/effect/proc_holder/spell/magicka
	name = "Spell"
	desc = "A magic spell using magicka."
	panel = "Spells"
	sound = null //The sound the spell makes when it is cast
	anchored = TRUE // Crap like fireball projectiles are proc_holders, this is needed so fireballs don't get blown back into your face via atmos etc.
	school = "restoration" //restoration for healing, destruction for elemental damage, illusion for mind tricks, conjuration for summons, and alteration for changing the physical world

	charge_type = "holdervar" //consumes magicka
	holder_var_type = "magicka" //^
	holder_var_amount = 20 //base magicka cost of default spell (overridden by every spell, ever). negative values = spell regenerates magicka.
	holder_var_name = "magicka" //for displaying

	clothes_req = FALSE //see if it requires magic clothes (note: these give +magicka regen anyway)
	nonabstract_req = FALSE //spell can only be cast by mobs that are physical entities
	stat_allowed = FALSE //see if it requires being conscious/alive, need to set to 1 for ghostpells
	phase_allowed = FALSE // If true, the spell can be cast while phased, eg. blood crawling, ethereal jaunting
	antimagic_allowed = FALSE // If false, the spell cannot be cast while under the effect of antimagic
	invocation = "FUS RO DAH!" //what is uttered when the wizard casts the spell
	invocation_emote_self = null
	invocation_type = "none" //can be none, whisper, emote and shout
	range = 7 //the range of the spell; outer radius for aoe spells
	message = "" //whatever it says to the guy affected by it
	selection_type = "view" //can be "range" or "view"
	spell_level = 0 //if a spell can be taken multiple times, this raises
	level_max = 0 //you can't learn spells more than once
	cooldown_min = 0 //see above
	player_lock = TRUE //If it can be used by simple mobs

	overlay = 0
	overlay_icon = 'icons/obj/wizard.dmi'
	overlay_icon_state = "spell"
	overlay_lifespan = 0

	action_icon = 'icons/mob/actions/actions_spells.dmi'
	action_icon_state = "spell_default"
	action_background_icon_state = "bg_spell"
	base_action = /datum/action/spell_action/spell


/obj/effect/proc_holder/spell/magicka/self //Targets only the caster. Good for buffs and heals. Oakflesh, Healing, etc
	range = -1 //Duh

/obj/effect/proc_holder/spell/magicka/self/choose_targets(mob/user = usr)
	if(!user)
		revert_cast()
		return
	perform(null,user=user)


/obj/effect/proc_holder/spell/magicka/self/basic_heal //This spell exists mainly for debugging purposes, and also to show how casting works
	name = "Lesser Heal"
	desc = "Heals a small amount of brute and burn damage."
	human_req = TRUE
	holder_var_amount = 10
	invocation = "Victus sano!"
	invocation_type = "whisper"
	school = "restoration"
	sound = 'sound/magic/staff_healing.ogg'

/obj/effect/proc_holder/spell/magicka/self/basic_heal/cast(mob/living/carbon/human/user) //Note the lack of "list/targets" here. Instead, use a "user" var depending on mob requirements.
	//Also, notice the lack of a "for()" statement that looks through the targets. This is, again, because the spell can only have a single target.
	user.visible_message("<span class='warning'>A wreath of gentle light passes over [user]!</span>", "<span class='notice'>You wreath yourself in healing light!</span>")
	to_chat(user, "Debug: spell cast. -10 magicka. Magicka remaining: [user.magicka]")
	user.adjustBruteLoss(-10)
	user.adjustFireLoss(-10)
