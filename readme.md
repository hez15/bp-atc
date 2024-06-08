Thanks for looking at this script i will be working on updates to add extra feature such as

Nui so a ui opens up like a real terminal etc 
Better callsign assigments 

This is also job locked to police and ambulance
all the items you might need to edit are in the client.lua 

if you have custom vehciles please add them to this section 

local aircraftModels


if you need to change the targer vector this is at the bottom of the client file 

exports['qb-target']:AddBoxZone("ToggleAircraftBlips", vector3(444.00, -995.66, 35.98), 1.5, 1.5, {
    name = "ToggleAircraftBlips",
    heading = 0.0,
    debugPoly = false,
    minZ = 34,
    maxZ = 36,
}, {
    options = {
        {
            type = "client",
            event = "toggleAircraftBlips", -- The name of the event to trigger
            icon = "fas fa-eye", -- Icon for the interaction
            label = "Toggle Aircraft Blips", -- Text label for the interaction
            job = "police", -- Job requirement
        },
    },
    distance = 2.5 -- Maximum distance for interaction
})