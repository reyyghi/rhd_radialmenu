--[[ Local Variable ]]
local radialDisable = false
local MenuReady = false

local T = {
    func = {},
    items_func = {}
}

--[[ Local Functions ]]
---@param resource string resources name
---@param export string export name
---@return fun(name: string, method: function)
local function useExport(resource, export)
	return exports[resource][export]()
end

---@param radialData table
local function addRadialItem ( radialData )
    if not radialData.id then return end
    radialData.resources = GetInvokingResource()
    Config.ItemRadial[#Config.ItemRadial+1] = radialData
end

---@param radialId string id of radial
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
            T.items_func[v.id] = nil
        end
    end
end

--- function to open radail menu
local function radialAction ()
    local Data = T.func.Filter(Config.ItemRadial)
    if Data and next(Data) then
        if not MenuReady then
            SendNUIMessage({
                state = "show",
                data = T.func.Read(Data),
                holdkey = Config.OpenRadial.hold or false
            })
            SetCursorLocation(0.5, 0.5)
            SetNuiFocus(true, true)
        
            PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
            MenuReady = true
        end
    end
end

---@param RadialTable table
---@return table
function T.func.Filter (RadialTable)
    local Result = {}
    for index, items in ipairs(RadialTable) do
        local canAdd = true
        if items.canEnable then
            canAdd = items.canEnable()
        end
        if canAdd then
            local newItem = {
                id = items.id,
                label = items.label,
                icon = items.icon,
                KeepOpen = items.KeepOpen,
            }

            T.items_func[items.id] = {}

            if items.action then
                T.items_func[items.id].action = items.action
            elseif items.event then
                T.items_func[items.id].event = items.event
            elseif items.serverEvent then
                T.items_func[items.id].serverEvent = items.serverEvent
            elseif items.command then
                T.items_func[items.id].command = items.command
            elseif items.export then
                T.items_func[items.id].export = items.export
            end
            
            if items.args then
                T.items_func[items.id].args = items.args
            end

            if items.options then
                newItem.options = T.func.Filter(items.options)
            end

            Result[#Result+1] = newItem
        end
    end

    return Result
end

---@param RadialTable table
---@return table
function T.func.Read(RadialTable)
    local Result = {}
    local PM = Result

    for index, items in ipairs(RadialTable) do
        
        if items.options then
            items.options = T.func.Read(items.options)
        end

        PM[#PM + 1] = items

        if Config.MaxItems.enable then
            if index % Config.MaxItems.max == 0 and index < #RadialTable then
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
    local Type = T.items_func[data.id]
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
    T.items_func = {}
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
