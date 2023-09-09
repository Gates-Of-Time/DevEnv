DROP TABLE IF EXISTS `goallists`;
CREATE TABLE `goallists` (
  `listid` int(10) unsigned NOT NULL,
  `entry` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`listid`,`entry`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `mercs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mercs` (
  `MercID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `OwnerCharacterID` int(10) unsigned NOT NULL,
  `Slot` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `Name` varchar(64) NOT NULL,
  `TemplateID` int(10) unsigned NOT NULL DEFAULT '0',
  `SuspendedTime` int(11) unsigned NOT NULL DEFAULT '0',
  `IsSuspended` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `TimerRemaining` int(11) unsigned NOT NULL DEFAULT '0',
  `Gender` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `MercSize` float NOT NULL DEFAULT '5',
  `StanceID` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `HP` int(11) unsigned NOT NULL DEFAULT '0',
  `Mana` int(11) unsigned NOT NULL DEFAULT '0',
  `Endurance` int(11) unsigned NOT NULL DEFAULT '0',
  `Face` int(10) unsigned NOT NULL DEFAULT '1',
  `LuclinHairStyle` int(10) unsigned NOT NULL DEFAULT '1',
  `LuclinHairColor` int(10) unsigned NOT NULL DEFAULT '1',
  `LuclinEyeColor` int(10) unsigned NOT NULL DEFAULT '1',
  `LuclinEyeColor2` int(10) unsigned NOT NULL DEFAULT '1',
  `LuclinBeardColor` int(10) unsigned NOT NULL DEFAULT '1',
  `LuclinBeard` int(10) unsigned NOT NULL DEFAULT '0',
  `DrakkinHeritage` int(10) unsigned NOT NULL DEFAULT '0',
  `DrakkinTattoo` int(10) unsigned NOT NULL DEFAULT '0',
  `DrakkinDetails` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`MercID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

-- Drop tables to reload data
drop table IF EXISTS merc_merchant_entries;
drop table IF EXISTS merc_merchant_template_entries;
drop table IF EXISTS merc_merchant_templates;
drop table IF EXISTS merc_stance_entries;
drop table IF EXISTS merc_templates;
drop table IF EXISTS merc_npc_types;
drop table IF EXISTS merc_name_types;
drop table IF EXISTS merc_subtypes;
drop table IF EXISTS merc_types;

-- What's displayed in merc merchant's dropdown (Apprentice Mercenaries (Dark Elf))
create table merc_types
(
	merc_type_id 	int 	UNSIGNED 	NOT NULL	AUTO_INCREMENT,
	race_id		int	UNSIGNED 	NOT NULL,
	proficiency_id	tinyint	UNSIGNED 	NOT NULL,
	dbstring	varchar(12)	NOT NULL,
	clientversion	int	UNSIGNED 	NOT NULL ,   			-- limits mercs by clientversion for available models
	PRIMARY KEY (merc_type_id)
);

-- other data relevant to mercs - could be in merc_templates, but is repeated (class & tier)
create table merc_subtypes
(
	merc_subtype_id 	int 	UNSIGNED 	NOT NULL	AUTO_INCREMENT,
	class_id		int	UNSIGNED 	NOT NULL,
	tier_id			tinyint	UNSIGNED 	NOT NULL,
	confidence_id		tinyint	UNSIGNED 	NOT NULL,
	PRIMARY KEY (merc_subtype_id)
);

create table merc_name_types
(
	name_type_id 	int 	UNSIGNED 	NOT NULL,
	class_id		int	UNSIGNED 	NOT NULL,
	prefix	varchar(25)	NOT NULL,
	suffix	varchar(25)	NOT NULL,
	PRIMARY KEY (name_type_id, class_id)
);

-- mostly for reference so there's just not a random merc_npc_type_id thrown in
create table merc_npc_types
(
	merc_npc_type_id		int 	UNSIGNED 	NOT NULL	AUTO_INCREMENT,
	proficiency_id			tinyint	UNSIGNED 	NOT NULL,
	tier_id					tinyint	UNSIGNED 	NOT NULL,
	class_id				int		UNSIGNED 	NOT NULL,
	name					varchar(255)		NULL,
	PRIMARY KEY (merc_npc_type_id)
);

-- ties together basic merc info to be displayed
create table merc_templates
(
	merc_template_id	int		UNSIGNED 	NOT NULL	AUTO_INCREMENT,
	merc_type_id 	int 		UNSIGNED 	NOT NULL,
	merc_subtype_id int	 	UNSIGNED 	NOT NULL,
	merc_npc_type_id int(11)	UNSIGNED 	NOT NULL,
	dbstring	varchar(12)	NOT NULL,			-- could be determined on the fly, but would require a lot of string manipulation
	name_type_id	tinyint	DEFAULT 0 NOT NULL,		-- determines whether or not merc gets a name or 'a goblin mercenary'
	clientversion	int	UNSIGNED 	NOT NULL ,
	PRIMARY KEY (merc_template_id),
	KEY FK_merc_templates_1 (merc_type_id),
	CONSTRAINT FK_merc_templates_1 FOREIGN KEY (merc_type_id) REFERENCES merc_types (merc_type_id),
	KEY FK_merc_templates_2 (merc_subtype_id),
	CONSTRAINT FK_merc_templates_2 FOREIGN KEY (merc_subtype_id) REFERENCES merc_subtypes (merc_subtype_id)
);

-- lists stances available per class & proficiency (apprentice has passive and balanced, journeyman has more)
create table merc_stance_entries
(
	merc_stance_entry_id	int 	UNSIGNED 	NOT NULL	AUTO_INCREMENT,
	class_id				int		UNSIGNED 	NOT NULL,
	proficiency_id			tinyint	UNSIGNED 	NOT NULL,
	stance_id				tinyint	UNSIGNED 	NOT NULL,
	isdefault				bool				NOT NULL,
	PRIMARY KEY (merc_stance_entry_id)
);

-- named record to link templates to, and assign to a merchant (a merchant may have more than one)
create table merc_merchant_templates
(
	merc_merchant_template_id	int UNSIGNED 	NOT NULL	AUTO_INCREMENT,
	name						varchar(50)		NOT NULL,
	qglobal						varchar(255),   -- quest global - could be on merc_templates
	PRIMARY KEY (merc_merchant_template_id)
);

-- assigns templates to merchant named template list (similar to loottable & lootdrops)
create table merc_merchant_template_entries
(
	merc_merchant_template_entry_id 	int 	UNSIGNED 	NOT NULL	AUTO_INCREMENT,
	merc_merchant_template_id			int 	UNSIGNED 	NOT NULL,
	merc_template_id					int		UNSIGNED 	NOT NULL,
	PRIMARY KEY (merc_merchant_template_entry_id),
	KEY FK_merc_merchant_template_entries_1 (merc_merchant_template_id),
	CONSTRAINT FK_merc_merchant_template_entries_1 FOREIGN KEY (merc_merchant_template_id) REFERENCES merc_merchant_templates (merc_merchant_template_id),
	KEY FK_merc_merchant_template_entries_2 (merc_template_id),
	CONSTRAINT FK_merc_merchant_template_entries_2 FOREIGN KEY (merc_template_id) REFERENCES merc_templates (merc_template_id)
);

-- links merc template lists to merchants (merchant_id references npc_types.id)
create table merc_merchant_entries
(
	merc_merchant_entry_id 		int 	UNSIGNED 	NOT NULL	AUTO_INCREMENT,
	merc_merchant_template_id	int		UNSIGNED 	NOT NULL,
	merchant_id					int(11)		UNSIGNED 	NOT NULL,
	PRIMARY KEY (merc_merchant_entry_id),
	KEY FK_merc_merchant_entries_1 (merc_merchant_template_id),
	CONSTRAINT FK_merc_merchant_entries_1 FOREIGN KEY (merc_merchant_template_id) REFERENCES merc_merchant_templates (merc_merchant_template_id)
);

-- Drop tables to reload data
DROP VIEW IF EXISTS vwMercNpcTypes;
DROP TABLE IF EXISTS merc_spell_list_entries;
DROP TABLE IF EXISTS merc_spell_lists;
DROP TABLE IF EXISTS merc_armorinfo;
DROP TABLE IF EXISTS merc_weaponinfo;
DROP TABLE IF EXISTS merc_stats;

CREATE TABLE merc_stats (
  	merc_npc_type_id int(11) unsigned NOT NULL,
	clientlevel tinyint(2) unsigned NOT NULL default '1',
	level tinyint(2) unsigned NOT NULL default '1',
  	hp int(11) NOT NULL default '1',
  	mana int(11) NOT NULL default '0',
  	AC smallint(5) NOT NULL default '1',
  	ATK mediumint(9) NOT NULL default '1',
  	STR mediumint(8) unsigned NOT NULL default '75',
  	STA mediumint(8) unsigned NOT NULL default '75',
  	DEX mediumint(8) unsigned NOT NULL default '75',
  	AGI mediumint(8) unsigned NOT NULL default '75',
  	_INT mediumint(8) unsigned NOT NULL default '80',
  	WIS mediumint(8) unsigned NOT NULL default '80',
  	CHA mediumint(8) unsigned NOT NULL default '75',
  	MR smallint(5) NOT NULL default '15',
  	CR smallint(5) NOT NULL default '15',
  	DR smallint(5) NOT NULL default '15',
  	FR smallint(5) NOT NULL default '15',
  	PR smallint(5) NOT NULL default '15',
  	Corrup smallint(5) NOT NULL default '15',
  	mindmg int(10) unsigned NOT NULL default '1',
  	maxdmg int(10) unsigned NOT NULL default '1',
	attack_count smallint(6) NOT NULL default '0',
  	attack_speed tinyint(3) NOT NULL default '0',
  	specialattks varchar(36) NOT NULL default '',
  	Accuracy mediumint(9) NOT NULL default '0',
  	hp_regen_rate int(11) unsigned NOT NULL default '1',
  	mana_regen_rate int(11) unsigned NOT NULL default '1',
  	runspeed float NOT NULL default '0',
	spellscale float NOT NULL default '100',
	healscale float NOT NULL default '100',
  	PRIMARY KEY  (merc_npc_type_id, clientlevel)
);

CREATE TABLE merc_armorinfo (
  	id int(11) NOT NULL auto_increment,
  	merc_npc_type_id int(11) unsigned NOT NULL,
  	minlevel tinyint(2) unsigned NOT NULL default '1',
	maxlevel tinyint(2) unsigned NOT NULL default '255',
	texture tinyint(2) unsigned NOT NULL default '0',
  	helmtexture tinyint(2) unsigned NOT NULL default '0',
  	armortint_id int(10) unsigned NOT NULL default '0',
  	armortint_red tinyint(3) unsigned NOT NULL default '0',
  	armortint_green tinyint(3) unsigned NOT NULL default '0',
  	armortint_blue tinyint(3) unsigned NOT NULL default '0',
  	PRIMARY KEY  (id)
);

CREATE TABLE merc_weaponinfo (
  	id int(11) NOT NULL auto_increment,
  	merc_npc_type_id int(11) NOT NULL,
  	minlevel tinyint(2) unsigned NOT NULL default '0',
	maxlevel tinyint(2) unsigned NOT NULL default '0',
  	d_meele_texture1 int(10) unsigned NOT NULL default '0',
  	d_meele_texture2 int(10) unsigned NOT NULL default '0',
  	prim_melee_type tinyint(4) unsigned NOT NULL default '28',
  	sec_melee_type tinyint(4) unsigned NOT NULL default '28',
  	PRIMARY KEY  (id)
);

create table merc_spell_lists
(
	merc_spell_list_id 	int 	UNSIGNED 	NOT NULL	AUTO_INCREMENT,
	class_id			int		UNSIGNED 	NOT NULL,
	proficiency_id		tinyint	UNSIGNED 	NOT NULL,
	name				varchar(50)	NOT NULL,
	PRIMARY KEY (merc_spell_list_id)
);

create table merc_spell_list_entries
(
	merc_spell_list_entry_id	int 	UNSIGNED 	NOT NULL	AUTO_INCREMENT,
	merc_spell_list_id			int 	UNSIGNED 	NOT NULL,
	spell_id					int 	UNSIGNED,
	spell_type					int		UNSIGNED 	NOT NULL	default '0',
	stance_id					tinyint	UNSIGNED 	NOT NULL	default '0',
	minlevel					tinyint	UNSIGNED 	NOT NULL	default '1',
	maxlevel					tinyint	UNSIGNED 	NOT NULL	default '255',
	slot						tinyint	NOT NULL	default '-1',
	procChance					tinyint	UNSIGNED 	NOT NULL	default '0',
	PRIMARY KEY (merc_spell_list_entry_id),
	KEY FK_merc_spell_lists_1 (merc_spell_list_id),
	CONSTRAINT FK_merc_spell_lists_1 FOREIGN KEY (merc_spell_list_id) REFERENCES merc_spell_lists (merc_spell_list_id)
);

CREATE VIEW vwMercNpcTypes AS
SELECT
			ms.merc_npc_type_id,
			'' AS name,
			ms.clientlevel,
			ms.level,
			mtyp.race_id,
			mstyp.class_id,
			ms.hp,
			ms.mana,
			0 AS gender,
			mai.texture,
			mai.helmtexture,
			ms.attack_speed,
			ms.STR,
			ms.STA,
			ms.DEX,
			ms.AGI,
			ms._INT,
			ms.WIS,
			ms.CHA,
			ms.MR,
			ms.CR,
			ms.DR,
			ms.FR,
			ms.PR,
			ms.Corrup,
            ms.mindmg,
            ms.maxdmg,
            ms.attack_count,
			ms.specialattks AS npcspecialattks,
			mwi.d_meele_texture1,
            mwi.d_meele_texture2,
			mwi.prim_melee_type,
			mwi.sec_melee_type,
			ms.runspeed,
			ms.hp_regen_rate,
			ms.mana_regen_rate,
			1 AS bodytype,
			mai.armortint_id,
			mai.armortint_red,
			mai.armortint_green,
			mai.armortint_blue,
			ms.AC,
			ms.ATK,
			ms.Accuracy,
			ms.spellscale,
			ms.healscale
			FROM merc_stats ms
			INNER JOIN merc_armorinfo mai
			ON ms.merc_npc_type_id = mai.merc_npc_type_id
			AND mai.minlevel <= ms.level AND mai.maxlevel >= ms.level
			INNER JOIN merc_weaponinfo mwi
			ON ms.merc_npc_type_id = mwi.merc_npc_type_id
			AND mwi.minlevel <= ms.level AND mwi.maxlevel >= ms.level
			INNER JOIN merc_templates mtem
			ON mtem.merc_npc_type_id = ms.merc_npc_type_id
			INNER JOIN merc_types mtyp
      ON mtem.merc_type_id = mtyp.merc_type_id
      INNER JOIN merc_subtypes mstyp
      ON mtem.merc_subtype_id = mstyp.merc_subtype_id;

DROP TABLE IF EXISTS proximities;
CREATE TABLE proximities (
`zoneid` int(10) unsigned NOT NULL,
`exploreid` int(10) unsigned NOT NULL,
`minx` float(14,6) NOT NULL DEFAULT '0.000000',
`maxx` float(14,6) NOT NULL DEFAULT '1.000000',
`miny` float(14,6) NOT NULL DEFAULT '0.000000',
`maxy` float(14,6) NOT NULL DEFAULT '1.000000',
`minz` float(14,6) NOT NULL DEFAULT '0.000000',
`maxz` float(14,6) NOT NULL DEFAULT '1.000000',
PRIMARY KEY (`zoneid`,`exploreid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
