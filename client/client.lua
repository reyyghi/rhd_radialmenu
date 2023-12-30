--[[ Local Variable ]]
local RHDITEMS = {}
local radialDisable = false
local MenuReady = false

--[[ Local Functions ]]
local function useExport(resource, export)
	return exports[resource][export]()
end

local function addRadialItem ( radialData )
    if not radialData.id then return end
    radialData.resources = GetInvokingResource()
    Config.ItemRadial[#Config.ItemRadial+1] = radialData
end

local function removeRadialItem ( radialId )
    if not radialId then
        return
    end

    if type(radialId) ~= "string" then
        return
    end

    for k, v in pairs(Config.ItemRadial) do
        if v.id == radialId then
            table.remove(Config.ItemRadial, k)
        end
    end
end


local function radialAction ()
    local enableMenu = {} RHDITEMS = {}
    local Data = Config.ItemRadial
    if Data and next(Data) then
        enableMenu = ReadTable(Data)
        if not MenuReady then
            SendNUIMessage({
                state = "show",
                data = enableMenu,
            })
            SetCursorLocation(0.5, 0.5)
            SetNuiFocus(true, true)
        
            PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
            MenuReady = true
        end
    end
end

--[[ Global Function ]]
function ReadTable(data)
    local Result = {}
    for _, item in ipairs(data) do
        local canAdd = true
        if item.canEnable then
            canAdd = item.canEnable()
        end
        if canAdd then
            local newItem = {
                id = item.id,
                label = item.label,
                icon = item.icon,
                KeepOpen = item.KeepOpen
            }
            if item.options then
                newItem.options = ReadTable(item.options)
            else
                RHDITEMS[item.id] = {
                    action = item.action,
                    event = item.event,
                    serverEvent = item.serverEvent,
                    command = item.command,
                    export = item.export,
                }
            end
            Result[#Result+1] = newItem
        end
    end
    return Result
end

--[[ NUI Callback ]]
RegisterNUICallback('closemenu', function(data, cb)
    Citizen.SetTimeout(100, function ()
        MenuReady = false
    end)

    MenuReady = true
    SetNuiFocus(false, false)
    SendNUIMessage({
        state = 'destroy'
    })
    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
    cb('ok')
end)

RegisterNUICallback("recieveData", function ( data, cb )
    local Type = RHDITEMS[data.id]
    if Type then
        if Type.action then
            Type.action()
        elseif Type.event then
            TriggerEvent(Type.event, Type.args)
        elseif Type.serverEvent then
            TriggerServerEvent(Type.event, Type.args)
        elseif Type.command then
            ExecuteCommand(Type.command)
        elseif Type.export then
            useExport(string.strsplit('.', Type.export))
        end
    end
    cb('ok')
end)

--[[ Command & Key Mapping ]]
RegisterCommand("oprenradial", function ()
    if radialDisable then return
        
    end
    radialAction()
end, false)

RegisterCommand("closeradial", function ()
    SetNuiFocus(false, false)
    SendNUIMessage({
        state = 'destroy'
    })
end, false)

RegisterKeyMapping("oprenradial", "Radial Menu", "keyboard", Config.OpenRadial)

--[[ Event Handler ]]
AddEventHandler('onClientResourceStop', function(resource)
    for i = #Config.ItemRadial, 1, -1 do
        local item = Config.ItemRadial[i]
        if item.resources == resource then
            table.remove(Config.ItemRadial, i)
        end
    end
end)

--[[ Export Handler ]]
exports('addRadialItem', addRadialItem)
exports('removeRadialItem', removeRadialItem)
exports('disableRadial', function ( boolean )
    radialDisable = boolean or not radialDisable
end)