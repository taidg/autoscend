since r27832;	// Spring Kick banish management
/***
	autoscend_header.ash must be first import
	All non-accessory scripts must be imported here

	Accessory scripts can import autoscend.ash
***/


import <autoscend/autoscend_header.ash>
import <autoscend/combat/auto_combat.ash>		//this file contains its own header. so it needs to be imported early
import <autoscend/autoscend_migration.ash>

import <autoscend/auto_acquire.ash>
import <autoscend/auto_adventure.ash>
import <autoscend/auto_bedtime.ash>
import <autoscend/auto_buff.ash>
import <autoscend/auto_consume.ash>
import <autoscend/auto_craft.ash>
import <autoscend/auto_equipment.ash>
import <autoscend/auto_familiar.ash>
import <autoscend/auto_list.ash>
import <autoscend/auto_monsterparts.ash>
import <autoscend/auto_powerlevel.ash>
import <autoscend/auto_providers.ash>
import <autoscend/auto_restore.ash>
import <autoscend/auto_routing.ash>
import <autoscend/auto_settings.ash>
import <autoscend/auto_sim.ash>
import <autoscend/auto_util.ash>
import <autoscend/auto_zlib.ash>
import <autoscend/auto_zone.ash>

import <autoscend/iotms/clan.ash>
import <autoscend/iotms/elementalPlanes.ash>
import <autoscend/iotms/eudora.ash>
import <autoscend/iotms/mr2007.ash>
import <autoscend/iotms/mr2011.ash>
import <autoscend/iotms/mr2012.ash>
import <autoscend/iotms/mr2013.ash>
import <autoscend/iotms/mr2014.ash>
import <autoscend/iotms/mr2015.ash>
import <autoscend/iotms/mr2016.ash>
import <autoscend/iotms/mr2017.ash>
import <autoscend/iotms/mr2018.ash>
import <autoscend/iotms/mr2019.ash>
import <autoscend/iotms/mr2020.ash>
import <autoscend/iotms/mr2021.ash>
import <autoscend/iotms/mr2022.ash>
import <autoscend/iotms/mr2023.ash>
import <autoscend/iotms/mr2024.ash>

import <autoscend/paths/actually_ed_the_undying.ash>
import <autoscend/paths/auto_path_util.ash>
import <autoscend/paths/avatar_of_boris.ash>
import <autoscend/paths/avatar_of_jarlsberg.ash>
import <autoscend/paths/avatar_of_sneaky_pete.ash>
import <autoscend/paths/avatar_of_shadows_over_loathing.ash>
import <autoscend/paths/avatar_of_west_of_loathing.ash>
import <autoscend/paths/bees_hate_you.ash>
import <autoscend/paths/bugbear_invasion.ash>
import <autoscend/paths/casual.ash>
import <autoscend/paths/community_service.ash>
import <autoscend/paths/dark_gyffte.ash>
import <autoscend/paths/disguises_delimit.ash>
import <autoscend/paths/fall_of_the_dinosaurs.ash>
import <autoscend/paths/g_lover.ash>
import <autoscend/paths/gelatinous_noob.ash>
import <autoscend/paths/grey_goo.ash>
import <autoscend/paths/heavy_rains.ash>
import <autoscend/paths/kingdom_of_exploathing.ash>
import <autoscend/paths/kolhs.ash>
import <autoscend/paths/legacy_of_loathing.ash>
import <autoscend/paths/license_to_adventure.ash>
import <autoscend/paths/live_ascend_repeat.ash>
import <autoscend/paths/low_key_summer.ash>
import <autoscend/paths/nuclear_autumn.ash>
import <autoscend/paths/one_crazy_random_summer.ash>
import <autoscend/paths/path_of_the_plumber.ash>
import <autoscend/paths/picky.ash>
import <autoscend/paths/pocket_familiars.ash>
import <autoscend/paths/quantum_terrarium.ash>
import <autoscend/paths/small.ash>
import <autoscend/paths/the_source.ash>
import <autoscend/paths/two_crazy_random_summer.ash>
import <autoscend/paths/way_of_the_surprising_fist.ash>
import <autoscend/paths/wildfire.ash>
import <autoscend/paths/you_robot.ash>
import <autoscend/paths/zombie_slayer.ash>

import <autoscend/quests/level_01.ash>
import <autoscend/quests/level_02.ash>
import <autoscend/quests/level_03.ash>
import <autoscend/quests/level_04.ash>
import <autoscend/quests/level_05.ash>
import <autoscend/quests/level_06.ash>
import <autoscend/quests/level_07.ash>
import <autoscend/quests/level_08.ash>
import <autoscend/quests/level_09.ash>
import <autoscend/quests/level_10.ash>
import <autoscend/quests/level_11.ash>
import <autoscend/quests/level_12.ash>
import <autoscend/quests/level_13.ash>
import <autoscend/quests/level_any.ash>
import <autoscend/quests/optional.ash>

void main(string... input)
{
	auto_meatTrainSet();
}
