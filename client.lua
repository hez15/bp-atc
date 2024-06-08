-- List of helicopter and airplane models with their call signs
local aircraftModels = {
    ["cargoplane"] = "Cargo",
    ["luxor"] = "Luxor",
    ["luxor2"] = "Luxor2",
    ["jet"] = "Jet",
    ["miljet"] = "Miljet",
    ["shamal"] = "Shamal",
    ["vestra"] = "Vestra",
    ["velum"] = "Velum",
    ["velum2"] = "Velum2",
    ["dodo"] = "Dodo",
    ["mammatus"] = "Mammatus",
    ["duster"] = "Duster",
    ["stunt"] = "Stunt",
    ["maverick"] = "Maverick",
    ["polmav"] = "Polmav",
    ["annihilator"] = "Annihilator",
    ["buzzard"] = "Buzzard",
    ["buzzard2"] = "Buzzard2",
    ["frogger"] = "Frogger",
    ["frogger2"] = "Frogger2",
    ["skylift"] = "Skylift",
    ["supervolito"] = "Supervolito",
    ["supervolito2"] = "Supervolito2",
    ["volatus"] = "Volatus",
    ["swift"] = "Swift",
    ["swift2"] = "Swift2",
    ["havok"] = "Havok",
    ["seasparrow"] = "Seasparrow",
    ["savage"] = "Savage",
    ["hunter"] = "Hunter"
}

QBCore = exports['qb-core']:GetCoreObject()

-- Initialize call sign counters
local callSignCounters = {}

-- Function to create a blip for an entity with a call sign
function createBlipForEntity(entity, callSign)
    local blip = AddBlipForEntity(entity)
    SetBlipSprite(blip, 90)  -- Blip icon
    SetBlipColour(blip, 43)  -- Blip color
    SetBlipScale(blip, 1.25) -- Blip scale
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Aircraft #" .. callSign)
    EndTextCommandSetBlipName(blip)
    return blip
end

-- Generate a unique call sign for each aircraft type using the license plate
function generateCallSign(vehicle)
    -- Get the vehicle's license plate
    local plate = GetVehicleNumberPlateText(vehicle)

    -- If no plate is found, return "Unknown"
    if not plate or plate == "" then
        return "Unknown"
    end

    return plate
end

-- Variable to track blip visibility
local blipsVisible = true

-- Event to toggle blips on and off
RegisterNetEvent('toggleAircraftBlips')
AddEventHandler('toggleAircraftBlips', function()
    blipsVisible = not blipsVisible
    local msg = blipsVisible and 'Aircraft blips enabled.' or 'Aircraft blips disabled.'
    QBCore.Functions.Notify(msg, 'success')
end)

-- Check every second for new aircraft and create blips for police
Citizen.CreateThread(function()
    local aircraftBlips = {}

    while true do
        Citizen.Wait(1000)  -- Check every second

        -- Get the player's job
        local playerPed = PlayerPedId()
        local playerData = QBCore.Functions.GetPlayerData()
        local isPolice = playerData.job and playerData.job.name == 'police'
        local isAmbulance = playerData.job and playerData.job.name == 'ambulance'

        if isPolice and blipsVisible then
            -- Get all vehicles
            local vehicles = GetGamePool('CVehicle')

            for _, vehicle in ipairs(vehicles) do
                local model = GetEntityModel(vehicle)

                -- Check if the vehicle is an aircraft
                for aircraftModel, _ in pairs(aircraftModels) do
                    if model == GetHashKey(aircraftModel) then
                        if not aircraftBlips[vehicle] then
                            -- Generate a call sign and create a blip for the aircraft
                            local callSign = generateCallSign(vehicle)
                            local blip = createBlipForEntity(vehicle, callSign)
                            aircraftBlips[vehicle] = blip
                        end
                        break
                    end
                end
            end

            -- Clean up blips for aircraft that no longer exist
            for vehicle, blip in pairs(aircraftBlips) do
                if not DoesEntityExist(vehicle) then
                    RemoveBlip(blip)
                    aircraftBlips[vehicle] = nil
                end
            end
        else
            -- Remove blips if player is no longer police or blips are toggled off
            for _, blip in pairs(aircraftBlips) do
                RemoveBlip(blip)
            end
            aircraftBlips = {}
        end
    end
end)

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
