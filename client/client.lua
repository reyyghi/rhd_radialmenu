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
                holdkey = Config.OpenRadial.hold or false
            })
            SetCursorLocation(0.5, 0.5)
            SetNuiFocus(true, true)
        
            PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
            MenuReady = true
        end
    end
end

function ReadTable(data)
    local Result = {}
    local PM = Result

    for index, item in ipairs(data) do
        local canAdd = true

        if item.canEnable then
            canAdd = item.canEnable()
        end

        if canAdd then
            local newItem = {
                id = item.id,
                label = item.label,
                icon = item.icon,
                KeepOpen = item.KeepOpen,
            }

            RHDITEMS[item.id] = {}

            if item.action then
                RHDITEMS[item.id].action = item.action
            elseif item.event then
                RHDITEMS[item.id].event = item.event
            elseif item.serverEvent then
                RHDITEMS[item.id].serverEvent = item.serverEvent
            elseif item.command then
                RHDITEMS[item.id].command = item.command
            elseif item.export then
                RHDITEMS[item.id].export = item.export
            end
            
            if item.args then
                RHDITEMS[item.id].args = item.args
            end

            if item.options then
                newItem.options = ReadTable(item.options)
            end

            PM[#PM + 1] = newItem

            if Config.MaxItems.enable then
                if index % Config.MaxItems.max == 0 and index < #data then
                    local moreItem = {
                        id = "_more",
                        label = "More",
                        icon = "ellipsis-h",
                        options = {}
                    }
    
                    PM[Config.MaxItems.max + 1] = moreItem
                    PM = moreItem.options
                end
            end
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

RegisterKeyMapping("oprenradial", "Radial Menu", "keyboard", Config.OpenRadial.key)

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
