#!/bin/bash
set -e

mkdir -p $5
rm -f $5/*.sql

TABLES=(
account
account_ip
account_flags
account_rewards
adventure_details
adventure_stats
buyer
char_recipe_list
character_activities
character_alt_currency
character_alternate_abilities
character_auras
character_bandolier
character_bind
character_buffs
character_corpse_items
character_corpses
character_currency
character_data
character_disciplines
character_enabledtasks
character_expedition_lockouts
character_exp_modifiers
character_inspect_messages
character_instance_safereturns
character_item_recast
character_languages
character_leadership_abilities
character_material
character_memmed_spells
character_pet_buffs
character_pet_info
character_pet_inventory
character_peqzone_flags
character_potionbelt
character_skills
character_spells
character_task_timers
character_tasks
character_tribute
completed_tasks
data_buckets
discovered_items
faction_values
friends
guild_bank
guild_members
guild_ranks
guild_relations
guilds
instance_list_player
inventory
inventory_snapshots
keyring
mail
petitions
player_titlesets
quest_globals
sharedbank
spell_buckets
spell_globals
timers
trader
trader_audit
zone_flags
adventure_members
banned_ips
bug_reports
bugs
completed_shared_task_activity_state
completed_shared_task_members
completed_shared_tasks
discord_webhooks
dynamic_zone_members
dynamic_zones
eventlog
expedition_lockouts
expeditions
gm_ips
group_id
group_leaders
hackers
instance_list
ip_exemptions
item_tick
lfguild
merchantlist_temp
object_contents
raid_details
raid_leaders
raid_members
reports
respawn_times
saylink
server_scheduled_events
shared_task_activity_state
shared_task_dynamic_zones
shared_task_members
shared_tasks
login_accounts
login_api_tokens
login_server_admins
login_server_list_types
login_world_servers
bot_buffs
bot_command_settings
bot_create_combinations
bot_data
bot_group_members
bot_groups
bot_guild_members
bot_heal_rotation_members
bot_heal_rotation_targets
bot_heal_rotations
bot_inspect_messages
bot_inventories
bot_owner_options
bot_pet_buffs
bot_pet_inventories
bot_pets
bot_spell_casting_chances
bot_spells_entries
bot_stances
bot_timers
vw_bot_character_mobs
vw_bot_groups
qs_merchant_transaction_record
qs_merchant_transaction_record_entries
qs_player_aa_rate_hourly
qs_player_delete_record
qs_player_delete_record_entries
qs_player_events
qs_player_handin_record
qs_player_handin_record_entries
qs_player_move_record
qs_player_move_record_entries
qs_player_npc_kill_record
qs_player_npc_kill_record_entries
qs_player_speech
qs_player_trade_record
qs_player_trade_record_entries
);

for T in ${TABLES[@]}
do
    echo "Backing up schema for $T"
    mysqldump --no-data --skip-comments --compact -u $1 -h $2 --password=$3 $4 $T > $5/$T.sql || true 2>&1
done;


CONTENT_TABLES=(
aa_ability
aa_rank_effects
aa_rank_prereqs
aa_ranks
adventure_template
adventure_template_entry
adventure_template_entry_flavor
alternate_currency
auras
base_data
blocked_spells
books
char_create_combinations
char_create_point_allocations
damageshieldtypes
doors
faction_base_data
faction_list
faction_list_mod
fishing
forage
global_loot
graveyard
grid
grid_entries
ground_spawns
horses
items
ldon_trap_entries
ldon_trap_templates
lootdrop
lootdrop_entries
loottable
loottable_entries
merchantlist
npc_emotes
npc_faction
npc_faction_entries
npc_scale_global_base
npc_spells
npc_spells_effects
npc_spells_effects_entries
npc_spells_entries
npc_types
npc_types_tint
object
pets
pets_beastlord_data
pets_equipmentset
pets_equipmentset_entries
skill_caps
spawn2
spawn_conditions
spawnentry
spawngroup
spells_new
start_zones
starting_items
task_activities
tasks
tasksets
tradeskill_recipe
tradeskill_recipe_entries
traps
tribute_levels
tributes
veteran_reward_templates
zone
zone_points
chatchannels
command_settings
content_flags
db_str
eqtime
launcher
launcher_zones
spawn_condition_values
spawn_events
level_exp_mods
logsys_categories
name_filter
perl_event_export_settings
profanity_list
rule_sets
titles
rule_values
variables
db_version
inventory_versions
);


for T in ${CONTENT_TABLES[@]}
do
    echo "Backing up data for $T"
    mysqldump --skip-comments --compact -u $1 -h $2 -p$3 $4 $T > $5/$T.sql || true 2>&1
done;

zip $5/latest.zip $5/*.sql
rm $5/*.sql