-- This is a compiled list of scripts in one file for use with the Stand Menu =D
-- Also contains comments/names for new coders to learn whats going on
-- Special thanks to HoppaC4 for this script and Ayrapheyr for adding to it
-- Sorted, commented and added to by Koda
-- I would also like to thank JayMontana36, Bunny_, Jixx, Sainan, Ren and allah for all their help
-- This is not all my code so I've credited the makers. Feel free to edit this code at anytime but please give everyone credit
-- I plan to add much more to this file. I'm learning Lua and using this as a dump for my scripts. My entity dropper is included in this toolbox
--=====================================================================================--
-----------------------------------------------------------------------------------------
---------------------------------[Stand Lua Toolbox v1.0]--------------------------------
-----------------------------------------------------------------------------------------
--=====================================================================================--
require("natives-1614644776")
script = {}
prop = 3872089630
tabble_prop = {attach}
attach = 1
playerped3 = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
--=====================================================================================--
-----------------------------------------------------------------------------------------
-----------------------------------[Functions to Call]-----------------------------------
-----------------------------------------------------------------------------------------
--=====================================================================================--

--------------------------------------[Entity drop]--------------------------------------
--just change the prop = value to any entity hash you want to Drop
function prop_attach(hash, xPos, zPos, yPos, xRot, yRot, zRot, visible, pid)

    while not STREAMING.HAS_MODEL_LOADED(hash) do
        STREAMING.REQUEST_MODEL(hash)
        util.yield()
    end

    playerped3 = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    tabble_prop[attach] = OBJECT.CREATE_OBJECT(hash, 0, 0, 0, true, true)

    ENTITY.ATTACH_ENTITY_TO_ENTITY(tabble_prop[attach], playerped3, 0, xPos, zPos, yPos, xRot, zRot, yRot, false, true, true, false, 0, false)
    ENTITY.DETACH_ENTITY(tabble_prop[attach], true, true)
    ENTITY.SET_ENTITY_VISIBLE(tabble_prop[attach], true)
    ENTITY._SET_ENTITY_CLEANUP_BY_ENGINE(tabble_prop, true)
    --ENTITY.APPLY_FORCE_TO_ENTITY(entity, 1, distanceRate*dx,distanceRate*dy,distanceRate*dz, math.random()*math.random(-1,1),math.random()*math.random(-1,1),math.random()*math.random(-1,1), true, false, true, true, true, true)

    STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(3872089630)
    attach = attach + 1
    end
---------------------------------[Request Entity Control]--------------------------------
function RequestControlOfEnt(entity)
    local tick = 0
	local tries = 0
	NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(entity)
	while not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(entity) and tick <= 1000 do
		NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(entity)
		tick = tick + 1
		tries = tries + 1
		if tries == 50 then 
			util.yield()
			tries = 0
		end
	end
	--if NETWORK.NETWORK_IS_SESSION_STARTED() --idk if needed
	--	int netID = NETWORK.NETWORK_GET_NETWORK_ID_FROM_ENTITY(entity)
	--	RequestControlOfid(netID)
	--	NETWORK.SET_NETWORK_ID_CAN_MIGRATE(netID, 1)
	--end
	return NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(entity)
end
--------------------------------[Get Player Vehicle]--------------------------------
function get_player_veh(pid,with_access)
	local ped = PLAYER.GET_PLAYER_PED(pid)	
	if PED.IS_PED_IN_ANY_VEHICLE(ped,true) then
		local vehicle = PED.GET_VEHICLE_PED_IS_IN(ped, false)
		if not with_access then
			return vehicle
		end
		if RequestControlOfEnt(vehicle) then
			return vehicle
		end
	end
	return 0
end
---------------------------------[Teleport Vehicle]----------------------------------
function tp_veh_to(pid,x,y,z)
	local tries = 0
	local ped = PLAYER.GET_PLAYER_PED(pid)	
	if PED.IS_PED_IN_ANY_VEHICLE(ped,true) then
		local vehicle = get_player_veh(pid,false)	
		while tries <= 1000 do --bad coooooood >:( but idk anything better
			if RequestControlOfEnt(vehicle) then			
				ENTITY.SET_ENTITY_COORDS_NO_OFFSET(vehicle, x, y, z, 0, 0, 1);
				tries = tries + 1
			end
		end
	end
end

function marqee(text)
	local temp = text
    text = text:sub(2)
	return text .. temp:sub(1, 1)
end
--------------------------------[Upgrade Vehicle]-------------------------------
function upgrade_vehicle(player)
	local vehicle = get_player_veh(player,true)
	if vehicle then
		DECORATOR.DECOR_SET_INT(vehicle, "MPBitset", 0)
		VEHICLE.SET_VEHICLE_MOD_KIT(vehicle, 0)
		for i = 0 ,50 do
			VEHICLE.SET_VEHICLE_MOD(vehicle, i, VEHICLE.GET_NUM_VEHICLE_MODS(vehicle, i) - 1, false)
		end	
		VEHICLE.SET_VEHICLE_CUSTOM_PRIMARY_COLOUR(vehicle, 0, 0, 0)
		VEHICLE.SET_VEHICLE_CUSTOM_SECONDARY_COLOUR(vehicle,0, 0, 0)
		VEHICLE.TOGGLE_VEHICLE_MOD(vehicle, 22, true)
		VEHICLE._SET_VEHICLE_XENON_LIGHTS_COLOR(vehicle, 10)
		VEHICLE.TOGGLE_VEHICLE_MOD(vehicle, 18, true)
		VEHICLE.TOGGLE_VEHICLE_MOD(vehicle, 20, true)
		for i = 0 ,4 do
			if not VEHICLE._IS_VEHICLE_NEON_LIGHT_ENABLED(vehicle, i) then
				VEHICLE._SET_VEHICLE_NEON_LIGHT_ENABLED(vehicle, i, true)
			end
		end
		VEHICLE._SET_VEHICLE_NEON_LIGHTS_COLOUR(vehicle, 255, 0, 255)
		VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT(vehicle, "cokc")
	end
end
--------------------------------[Launch Vehicle]--------------------------------
function launch_vehicle(pid)
	local vehicle = get_player_veh(pid,true)
	if vehicle then
		ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(vehicle, 1, 0, 0, 10000, true, false, true)
	end
end
--------------------------------[Launch North]----------------------------------
function northp_vehicle(pid)
	local vehicle = get_player_veh(pid,true)
	if vehicle then
		ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(vehicle, 1, 0, 10000, 0, true, false, true)
	end
end
--=====================================================================================--
-----------------------------------------------------------------------------------------
----------------------------------[Menu List Functions]----------------------------------
-----------------------------------------------------------------------------------------
--=====================================================================================--
GenerateFeatures = function(pid)
    main = menu.list(menu.player_root(pid), "Stand Lua Toolbox v1.0", {}, "", function() end)

    lock_sub_vehicle_tab = menu.list(main, "Lock Options", {}, "", function() end)
    mov_sub_vehicle_tab = menu.list(main, "Movement Options", {}, "", function() end)
    health_sub_vehicle_tab = menu.list(main, "Health and Appereance Options", {}, "", function() end)
    --[[lsc_health_sub_vehicle_tab = menu.list(health_sub_vehicle_tab, "Remote LSC", {}, "", function(); end) <-- Wanted to be able to fully customize other players vehicles but then realized that requires a lotta work and im lazy
    armor_lsc_health_sub_vehicle_tab = menu.list(lsc_health_sub_vehicle_tab, "Armor", {}, "", function(); end)
    engine_lsc_health_sub_vehicle_tab = menu.list(lsc_health_sub_vehicle_tab, "Engine", {}, "", function(); end)
    transmiss_lsc_health_sub_vehicle_tab = menu.list(lsc_health_sub_vehicle_tab, "Transmission", {}, "", function(); end)
    suspen_lsc_health_sub_vehicle_tab = menu.list(lsc_health_sub_vehicle_tab, "Suspension", {}, "", function(); end)
    turbo_lsc_health_sub_vehicle_tab = menu.list(lsc_health_sub_vehicle_tab, "Turbo", {}, "", function(); end)
    colors_lsc_health_sub_vehicle_tab = menu.list(lsc_health_sub_vehicle_tab, "Respray", {}, "", function(); end)
    pri_colors_lsc_health_sub_vehicle_tab = menu.list(colors_lsc_health_sub_vehicle_tab, "Primary Color", {}, "", function(); end)
    sec_colors_lsc_health_sub_vehicle_tab = menu.list(colors_lsc_health_sub_vehicle_tab, "Secondary Color", {}, "", function(); end)
    both_colors_lsc_health_sub_vehicle_tab = menu.list(colors_lsc_health_sub_vehicle_tab, "Both Color", {}, "", function(); end)]]
    detach_sub_vehicle_tab = menu.list(main, "Detach Options", {}, "", function() end)
    plane_sub_vehicle_tab = menu.list(main, "Plane and Helicopter Options", {}, "", function() end)
    car_sub_vehicle_tab = menu.list(main, "Car Options", {}, "", function() end)
--=====================================================================================--
-----------------------------------------------------------------------------------------
----------------------------------[Koda's List Options]----------------------------------
-----------------------------------------------------------------------------------------
--=====================================================================================--
----------------------------------[Invert Veh Controls]----------------------------------
menu.action(car_sub_vehicle_tab,"Invert Controls", {"invertcont"}, "Inverts controls for vehicles",function()
    local vehicle = get_player_veh(pid,true)
    if vehicle then
        VEHICLE._SET_VEHICLE_CONTROLS_INVERTED(vehicle, true) 
    end
end)
------------------------------------[Delete Vehicles]------------------------------------
menu.action(main,"delete vehicle", {"delveh"}, "Deletes player's vehicle",function()
	local vehicle = get_player_veh(pid,true)
	if vehicle then
		RequestControlOfEnt(vehicle)
		if NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(vehicle) then
			ENTITY.SET_ENTITY_AS_MISSION_ENTITY(vehicle, true, true)
			VEHICLE.SET_VEHICLE_ENGINE_HEALTH(vehicle, -4000)
			local ptr = memory.alloc(4)
			memory.write_int(ptr, vehicle)
			VEHICLE.DELETE_VEHICLE(ptr)
			memory.free(ptr)
		end
	end
end)
------------------------------------[Explode Vehicles]-----------------------------------
menu.action(health_sub_vehicle_tab, "Explode Vehicle v2", {"explodeveh"}, "Explodes vehicle", function()
    local vehicle = get_player_veh(pid,true)
    if vehicle then
        RequestControlOfEnt(vehicle)
        if NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(vehicle) then
        NETWORK.NETWORK_EXPLODE_VEHICLE(vehicle, true, false, 0)
		end
    end
end)
---------------------------------[Drop entity on player]---------------------------------
menu.action(main,"Dildo Drop", {"dildrop"}, "Drops a dildo on players heads",function()
    prop_attach(3872089630, 0, 0, 1.50, 0, 0, 0, false, pid)
end)
--=====================================================================================--
-----------------------------------------------------------------------------------------
---------------------------------[Kodas Feature Testing]---------------------------------
-----------------------------------------------------------------------------------------
--=====================================================================================--
--This is where i test scripts

--=====================================================================================--
-----------------------------------------------------------------------------------------
------------------------------------[Feature Testing]------------------------------------
-----------------------------------------------------------------------------------------
--=====================================================================================--
--Test your scripts here

--=====================================================================================--
-----------------------------------------------------------------------------------------
---------------------------------[Original List Options]---------------------------------
-----------------------------------------------------------------------------------------
--=====================================================================================--

------------------------------------[Fixes your car]-------------------------------------
menu.action(health_sub_vehicle_tab,"Repair Vehicle", {"fixveh"}, "Repairs player's vehicle", function()
	local vehicle = get_player_veh(pid,true)
	if vehicle then
		VEHICLE.SET_VEHICLE_FIXED(vehicle)
	end
end)
-----------------------------[Repairs the appearance of your car]------------------------
menu.action(health_sub_vehicle_tab,"Repair Vehicle Shell", {"fixvehshl"}, "Repairs player's vehicle but don't repair it's engine", function()
	local vehicle = get_player_veh(pid,true)
	if vehicle then
		VEHICLE.SET_VEHICLE_DEFORMATION_FIXED(vehicle)
	end
end)
-----------------------------------[editthisforname]-----------------------------------
menu.action(health_sub_vehicle_tab,"Quick Upgrade Vehicle", {"ugveh"}, "Upgrades player's vehicle",function()
	upgrade_vehicle(pid)
end)
-----------------------------------[editthisforname]-----------------------------------
menu.action(health_sub_vehicle_tab,"Disable Invincibility", {"removeinv"}, "Removes invincibility from player's vehicle",function()
	local vehicle = get_player_veh(pid,true)
	if vehicle then	
		ENTITY.SET_ENTITY_INVINCIBLE(vehicle, false) 
	end
end)
-----------------------------------[editthisforname]-----------------------------------
menu.action(health_sub_vehicle_tab,"Enable Invincibility", {"giveinv"}, "Gives invincibility to player's vehicle",function()
	local vehicle = get_player_veh(pid,true)
	if vehicle then	
		ENTITY.SET_ENTITY_INVINCIBLE(vehicle, true) 
	end
end)
-----------------------------------[editthisforname]-----------------------------------
menu.action(health_sub_vehicle_tab,"Destroy Engine", {"killveh"}, "Destroys vehicle engine", function()
	local vehicle = get_player_veh(pid,true)
	if vehicle then
		VEHICLE.SET_VEHICLE_ENGINE_HEALTH(vehicle, -4000)
		VEHICLE.SET_VEHICLE_BODY_HEALTH(vehicle, -4000)
		VEHICLE.SET_VEHICLE_PETROL_TANK_HEALTH(vehicle, -4000)
	end
end)
-----------------------------------[editthisforname]-----------------------------------
menu.action(health_sub_vehicle_tab,"Revive Engine", {"reviveh"}, "Revives vehicle engine", function()
	local vehicle = get_player_veh(pid,true)
	if vehicle then
		VEHICLE.SET_VEHICLE_ENGINE_HEALTH(vehicle, 1000)
		VEHICLE.SET_VEHICLE_BODY_HEALTH(vehicle, 1000)
		VEHICLE.SET_VEHICLE_PETROL_TANK_HEALTH(vehicle, 1000)
	end
end)
-----------------------------------[editthisforname]-----------------------------------
menu.action(health_sub_vehicle_tab,"Explode Vehicle", {"explodeveh"}, "Explodes vehicle",function()
	local vehicle = get_player_veh(pid,false)
	if vehicle then
		local pos = ENTITY.GET_ENTITY_COORDS(vehicle)
		FIRE.ADD_EXPLOSION(pos.x,pos.y,pos.z, 7, 1000, true, false, 1, false)
	end
end)
-----------------------------------[editthisforname]-----------------------------------
menu.action(mov_sub_vehicle_tab,"Reset Acceleration", {"reacc"}, "Resets max speed of vehicle",function()
	local vehicle = get_player_veh(pid,true)
	if vehicle then
		VEHICLE.MODIFY_VEHICLE_TOP_SPEED(vehicle, 1) 
	end
end)
-----------------------------------[editthisforname]-----------------------------------
menu.action(mov_sub_vehicle_tab,"Boost Acceleration", {"boostacc"}, "Sets max speed of vehicle to 9999999",function()
	local vehicle = get_player_veh(pid,true)
	if vehicle then
		VEHICLE.MODIFY_VEHICLE_TOP_SPEED(vehicle, 9999999) 
	end
end)
-----------------------------------[editthisforname]-----------------------------------
menu.action(mov_sub_vehicle_tab,"Trash Acceleration", {"tacc"}, "Sets max speed of vehicle to INT_MIN",function()
	local vehicle = get_player_veh(pid,true)
	if vehicle then
		VEHICLE.MODIFY_VEHICLE_TOP_SPEED(vehicle, -2147483647) 
	end
end)
-----------------------------------[editthisforname]-----------------------------------
menu.action(mov_sub_vehicle_tab,"Northpole", {"northpole"}, "Boosts player in the North direction.",function()
	northp_vehicle(pid)
end)
-----------------------------------[editthisforname]-----------------------------------
menu.action(mov_sub_vehicle_tab,"Launch Up", {"launchup"}, "Shoots player up",function()
	launch_vehicle(pid)
end)
-----------------------------------[editthisforname]-----------------------------------
menu.action(detach_sub_vehicle_tab,"Detach Trailer", {"detachtrailer"}, "Detaches attached trailer",function()
	local vehicle = get_player_veh(pid,true)
	if vehicle then
		VEHICLE.DETACH_VEHICLE_FROM_TRAILER(vehicle) 
	end
end)
-----------------------------------[editthisforname]-----------------------------------
menu.action(detach_sub_vehicle_tab,"Detach from Cargobob", {"detachcbob"}, "Detaches from Cargobob",function()
	local vehicle = get_player_veh(pid,true)
	if vehicle then
		VEHICLE.DETACH_VEHICLE_FROM_ANY_CARGOBOB(vehicle) 
	end
end)
-----------------------------------[editthisforname]-----------------------------------
menu.action(lock_sub_vehicle_tab,"Lock Doors", {"lockveh"}, "Locks the doors",function()
	local vehicle = get_player_veh(pid,true)
	if vehicle then
		VEHICLE.SET_VEHICLE_DOORS_LOCKED(vehicle, 4) 
	end
end)
-----------------------------------[editthisforname]-----------------------------------
menu.action(lock_sub_vehicle_tab,"Unlock Doors", {"unlockveh"}, "Unlocks the doors",function()
	local vehicle = get_player_veh(pid,true)
	if vehicle then
		VEHICLE.SET_VEHICLE_DOORS_LOCKED(vehicle, 1)		
	end
end)
-----------------------------------[editthisforname]-----------------------------------
menu.action(lock_sub_vehicle_tab,"Make Vehicle Drivable", {"engineon"}, "Makes player's vehicle drivable again",function()
	local vehicle = get_player_veh(pid,true)
	if vehicle then
		VEHICLE.SET_VEHICLE_UNDRIVEABLE(vehicle, false)		
	end
end)
-----------------------------------[editthisforname]-----------------------------------
menu.action(lock_sub_vehicle_tab,"Make Vehicle Undrivable", {"engineoff"}, "Makes player's vehicle undrivable",function()
	local vehicle = get_player_veh(pid,true)
	if vehicle then
		VEHICLE.SET_VEHICLE_UNDRIVEABLE(vehicle, true)		
	end
end)
-----------------------------------[editthisforname]-----------------------------------
menu.action(plane_sub_vehicle_tab,"Deploy Landing Gear", {"landing1"}, "",function()
	local vehicle = get_player_veh(pid,true)
	if vehicle then
		VEHICLE.CONTROL_LANDING_GEAR(vehicle, 0)		
	end
end)
-----------------------------------[editthisforname]-----------------------------------
menu.action(plane_sub_vehicle_tab,"Retract Landing Gear", {"landing0"}, "",function()
	local vehicle = get_player_veh(pid,true)
	if vehicle then
		VEHICLE.CONTROL_LANDING_GEAR(vehicle, 3)		
	end
end)
-----------------------------------[editthisforname]-----------------------------------
menu.action(plane_sub_vehicle_tab,"Disable Cargobob's Hook", {"nohook"}, "Disables cargobob's hook. when used, that cargobob's hook will no longer work",function()
	local vehicle = get_player_veh(pid,true)
	if vehicle then
		VEHICLE.REMOVE_PICK_UP_ROPE_FOR_CARGOBOB(vehicle)		
	end
end)
-----------------------------------[editthisforname]-----------------------------------
menu.action(plane_sub_vehicle_tab,"Strong Turbulence", {"turb1"}, "Makes turbulence stronger",function()
	local vehicle = get_player_veh(pid,true)
	if vehicle then
		VEHICLE.SET_PLANE_TURBULENCE_MULTIPLIER(vehicle, 1.0)		
	end
end)
-----------------------------------[editthisforname]-----------------------------------
menu.action(plane_sub_vehicle_tab,"No Turbulence", {"turb0"}, "Makes turbulence weaker",function()
	local vehicle = get_player_veh(pid,true)
	if vehicle then
		VEHICLE.SET_PLANE_TURBULENCE_MULTIPLIER(vehicle, 0.0)		
	end
end)
-----------------------------------[editthisforname]-----------------------------------
menu.action(plane_sub_vehicle_tab,"Set Propeller Speed at 100%", {"propel100"}, "",function()
	local vehicle = get_player_veh(pid,true)
	if vehicle then
		VEHICLE.SET_HELI_BLADES_SPEED(vehicle, 1.0)		
	end
end)
-----------------------------------[editthisforname]-----------------------------------
menu.action(plane_sub_vehicle_tab,"Set Propeller Speed at 0%", {"propel0"}, "",function()
	local vehicle = get_player_veh(pid,true)
	if vehicle then
		VEHICLE.SET_HELI_BLADES_SPEED(vehicle, 0.0)		
	end
end)
-------------------------------[Destroys heli rear rotor]------------------------------
menu.action(plane_sub_vehicle_tab,"Destroy Rear Helicopter Roter", {"bunlockcar"}, "",function()
	local vehicle = get_player_veh(pid,true)
	if vehicle then
		VEHICLE._SET_HELI_TAIL_ROTOR_HEALTH(vehicle, -100)		
	end
end)
-----------------------------------[editthisforname]-----------------------------------
menu.action(lock_sub_vehicle_tab,"Lock that bich in", {"blockcar"}, "Locks the doors, paints the car Hot Pink, changes plate text to 'LOCKED'",function()
	local vehicle = get_player_veh(pid,true)
	if vehicle then
		VEHICLE.SET_VEHICLE_DOORS_LOCKED(vehicle, 4) 
		VEHICLE.SET_VEHICLE_COLOURS(vehicle, 135, 135)
		VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT(vehicle, "LOCKED")
	end
end)
-----------------------------------[editthisforname]-----------------------------------
menu.action(lock_sub_vehicle_tab,"Release that bich out", {"bunlockcar"}, "Unlocks the doors, paints the vehicle Green, changes plate text to 'URFREE'",function()
	local vehicle = get_player_veh(pid,true)
	if vehicle then
		VEHICLE.SET_VEHICLE_DOORS_LOCKED(vehicle, 1)
        VEHICLE.SET_VEHICLE_COLOURS(vehicle, 92, 92)
		VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT(vehicle, "URFREE")		
	end
end)
-----------------------------------[editthisforname]-----------------------------------
menu.action(mov_sub_vehicle_tab,"Teleport to me", {"tp2me"}, "Tries to teleport player's vehicle to you",function()
	local coords = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), true)
	tp_veh_to(pid,coords.x,coords.y,coords.z)
end)
-----------------------------------[editthisforname]-----------------------------------
menu.action(mov_sub_vehicle_tab,"Teleport to ocean", {"tp2sea"}, "Tries to teleport player's vehicle to the ocean",function()	
	tp_veh_to(pid,15000,15000,0)
end)

end

for pid = 0,30 do 
	if players.exists(pid) then
		GenerateFeatures(pid)
	end
end
--[[players.on_join(GenerateFeatures)  --remove if issues
while true do
    util.yield()
end]]

players.on_join(GenerateFeatures)
local last_call_time = util.current_time_millis()
local redo_boost = false
while true do
	--onTick()
	if bFunkyPlate then
		local veh = util.get_vehicle()
		if veh then
			local delta = util.current_time_millis() - last_call_time
			if delta > 200 then
				licenseplate_text = marqee (licenseplate_text)
				last_call_time = util.current_time_millis()
			end
			VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT(veh ,licenseplate_text)
		end
	end

	if bOnKeyBoost then --funky
		local veh = util.get_vehicle() 
		if veh then --menu.trigger_commands("boostmod infinite") --ayyy
			if not PLAYER.IS_PLAYER_PRESSING_HORN(players.user()) and redo_boost then
				menu.trigger_commands("boostmod empty")
				redo_boost = false	
			else
				menu.trigger_commands("boostmod infinite")
				if PLAYER.IS_PLAYER_PRESSING_HORN(players.user()) then
					redo_boost = true
				end
			end
		end
	end
	util.yield()
end





















































































































































































































































