ConvertMaps()
{
	new query[1000];
	for(new i; i < 27; i++)
	{
		printf("Attempting %d", i);

		new Map_file[64];
		format(Map_file, sizeof(Map_file), "/ZL/Maps/%d.ini", i);
		INI_ParseFile(Map_file, "load_Map_%s", .bExtra = true, .extra = i);

		format(query, sizeof query, "INSERT INTO "TABLE_MAPS" \
			("FIELD_MAP_FS_NAME", "FIELD_MAP_NAME", "FIELD_MAP_HUMAN_SPAWN_X", "FIELD_MAP_HUMAN_SPAWN_Y", "FIELD_MAP_HUMAN_SPAWN_Z", \
			"FIELD_MAP_HUMAN_SPAWN2_X", "FIELD_MAP_HUMAN_SPAWN2_Y", "FIELD_MAP_HUMAN_SPAWN2_Z", "FIELD_MAP_ZOMBIE_SPAWN_X", "FIELD_MAP_ZOMBIE_SPAWN_Y", "FIELD_MAP_ZOMBIE_SPAWN_Z", \
			"FIELD_MAP_INTERIOR", "FIELD_MAP_GATE_X", "FIELD_MAP_GATE_Y", "FIELD_MAP_GATE_Z", "FIELD_MAP_GATE2_X", "FIELD_MAP_GATE2_Y", "FIELD_MAP_GATE2_Z", \
			"FIELD_MAP_CP_X", "FIELD_MAP_CP_Y", "FIELD_MAP_CP_Z", "FIELD_MAP_MOVE_GATE", "FIELD_MAP_GATE_ID", "FIELD_MAP_WATER", "FIELD_MAP_EVAC_TYPE", \
			"FIELD_MAP_WEATHER", "FIELD_MAP_TIME") \
			VALUES('%s', '%s', '%f', '%f', '%f', \
			'%f', '%f', '%f', '%f', '%f', '%f', \
			'%d', '%f', '%f', '%f', '%f', '%f', '%f', \
			'%f', '%f', '%f', '%d', '%d', '%d', '%d', \
			'%d', '%d')",
			Map[FSMapName], Map[MapName], Map[HumanSpawnX], Map[HumanSpawnY], Map[HumanSpawnZ],
			Map[HumanSpawn2X], Map[HumanSpawn2Y], Map[HumanSpawn2Z], Map[ZombieSpawnX], Map[ZombieSpawnY], Map[ZombieSpawnZ],
			Map[Interior], Map[GateX], Map[GateY], Map[GateZ], Map[GaterX], Map[GaterY], Map[GaterZ],
			Map[CPx], Map[CPy], Map[CPz], Map[MoveGate], Map[GateID], Map[AllowWater], Map[EvacType],
			Map[Weather], Map[Time]);
		db_free_result(db_query(gSQL, query));
		//print(query);
	}
}

forward load_Map_basic(Mapid, name[], value[]);
public load_Map_basic(Mapid, name[], value[])
{
	if (strcmp(name, "FSMapName", true) == 0) strmid(Map[FSMapName], value, false, strlen(value), 128);
	if (strcmp(name, "MapName", true) == 0) strmid(Map[MapName], value, false, strlen(value), 128);

	if (strcmp(name, "HumanSpawnX", true) == 0) Map[HumanSpawnX] = floatstr(value);
	if (strcmp(name, "HumanSpawnY", true) == 0) Map[HumanSpawnY] = floatstr(value);
	if (strcmp(name, "HumanSpawnZ", true) == 0) Map[HumanSpawnZ] = floatstr(value);
	if (strcmp(name, "HumanSpawn2X", true) == 0) Map[HumanSpawn2X] = floatstr(value);
	if (strcmp(name, "HumanSpawn2Y", true) == 0) Map[HumanSpawn2Y] = floatstr(value);
	if (strcmp(name, "HumanSpawn2Z", true) == 0) Map[HumanSpawn2Z] = floatstr(value);
	if (strcmp(name, "ZombieSpawnX", true) == 0) Map[ZombieSpawnX] = floatstr(value);
	if (strcmp(name, "ZombieSpawnY", true) == 0) Map[ZombieSpawnY] = floatstr(value);
	if (strcmp(name, "ZombieSpawnZ", true) == 0) Map[ZombieSpawnZ] = floatstr(value);
	if (strcmp(name, "Interior", true) == 0) Map[Interior] = strval(value);
	if (strcmp(name, "GateX", true) == 0) Map[GateX] = floatstr(value);
	if (strcmp(name, "GateY", true) == 0) Map[GateY] = floatstr(value);
	if (strcmp(name, "GateZ", true) == 0) Map[GateZ] = floatstr(value);
	if (strcmp(name, "CPx", true) == 0) Map[CPx] = floatstr(value);
	if (strcmp(name, "CPy", true) == 0) Map[CPy] = floatstr(value);
	if (strcmp(name, "CPz", true) == 0) Map[CPz] = floatstr(value);
	if (strcmp(name, "GaterX", true) == 0) Map[GaterX] = floatstr(value);
	if (strcmp(name, "GaterY", true) == 0) Map[GaterY] = floatstr(value);
	if (strcmp(name, "GaterZ", true) == 0) Map[GaterZ] = floatstr(value);
	if (strcmp(name, "MoveGate", true) == 0) Map[MoveGate] = strval(value);
	if (strcmp(name, "GateID", true) == 0) Map[GateID] = strval(value);
	if (strcmp(name, "AllowWater", true) == 0) Map[AllowWater] = strval(value);
	if (strcmp(name, "EvacType", true) == 0) Map[EvacType] = strval(value);
	if (strcmp(name, "Weather", true) == 0) Map[Weather] = strval(value);
	if (strcmp(name, "Time", true) == 0) Map[Time] = strval(value);
	return 1;
}
