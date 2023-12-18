local MAX_MENU_ITEMS = 7
local radialDisable = false
local MenuReady = false

local function useExport(resource, export)
	return exports[resource][export]()
end

local function ExecuteData ( var )
    local func, err = load("return " .. var)

    if func then
       return func()
    else
        error(err)
    end
end

local function addRadialItem ( radialData )
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

local isActionData = function ( config )
    return config.action or config.event or config.serverEvent
    or config.command or config.exports
end

local function radialAction (active)
    local enabledMenus = {}

    for num, menuConfig in ipairs(Config.ItemRadial) do

        if menuConfig.canEnable then
            if not menuConfig.canEnable() then
                goto continue
            end
        end

        local dataElements = {}
        local hasSubMenus = false
        
        if menuConfig.options and not isActionData(menuConfig) and #menuConfig.options > 0 then
            hasSubMenus = true
            local previousMenu = dataElements
            local currentElement = {}
            local kntl, asu = {}, false

            for i = 1, #menuConfig.options do
                local optionsData = menuConfig.options[i]

                if optionsData.canEnable then
                    if not optionsData.canEnable() then
                        goto next
                    end
                end

                currentElement[#currentElement+1] = {
                    number = num,
                    menuId = i,
                    id = optionsData.id,
                    title = optionsData.label,
                    icon = optionsData.icon,
                    isOptions = true,
                    KeepOpen = optionsData.KeepOpen or false
                }

                if optionsData.event then
                    currentElement[#currentElement].type = "clientEvent"
                elseif optionsData.serverEvent then
                    currentElement[#currentElement].type = "serverEvent"
                elseif optionsData.command then
                    currentElement[#currentElement].type = "command"
                elseif optionsData.exports then
                    currentElement[#currentElement].type = "exports"
                elseif optionsData.action then
                    currentElement[#currentElement].type = "function"
                end
                
                if optionsData.options and not isActionData(optionsData) and #optionsData.options > 0 then

                    local inputSubMenu,inputSubMenu2, over = {}, {}, false
                    for m, rd in pairs(optionsData.options) do

                        if rd.canEnable then
                            if not rd.canEnable() then
                                goto nextlagi
                            end
                        end

                        inputSubMenu[#inputSubMenu+1] = {
                            number = num,
                            menuId = i,
                            subMenuId = m,
                            id = rd.id,
                            title = rd.label,
                            icon = rd.icon,
                            isSubmenu = true,
                            KeepOpen = rd.KeepOpen or false
                        }
                    
                        if rd.event then
                            inputSubMenu[#inputSubMenu].type = "clientEvent"
                        elseif rd.serverEvent then
                            inputSubMenu[#inputSubMenu].type = "serverEvent"
                        elseif rd.command then
                            inputSubMenu[#inputSubMenu].type = "command"
                        elseif rd.exports then
                            inputSubMenu[#inputSubMenu].type = "exports"
                        elseif rd.action then
                            inputSubMenu[#inputSubMenu].type = "function"
                        end
                    end

                    currentElement[#currentElement].items = inputSubMenu
                    
                    :: nextlagi ::
                end

                if i % MAX_MENU_ITEMS == 0 and i < (#menuConfig.options - 1) then
                    previousMenu[MAX_MENU_ITEMS] = {
                        id = "_more",
                        title = "More",
                        icon = "#ellipsis-h",
                        items = currentElement
                    }
                    previousMenu = currentElement
                    currentElement = {}
                end

                :: next ::
            end

            if #currentElement > 0 then
                previousMenu[MAX_MENU_ITEMS] = {
                    id = "_more",
                    title = "More",
                    icon = "#ellipsis-h",
                    items = currentElement
                }
            end

            if #kntl > 0 and asu then
                currentElement[#currentElement].items[MAX_MENU_ITEMS] = {
                    id = "_more",
                    title = "More",
                    icon = "#ellipsis-h",
                    items = kntl
                }
            end

            dataElements = dataElements[MAX_MENU_ITEMS].items
        end

        enabledMenus[#enabledMenus+1] = {
            number = num,
            id = menuConfig.id,
            title = menuConfig.label,
            icon = menuConfig.icon,
            KeepOpen = menuConfig.KeepOpen or false
        }

        if menuConfig.event then
            enabledMenus[#enabledMenus].type = "clientEvent"
        elseif menuConfig.serverEvent then
            enabledMenus[#enabledMenus].type = "serverEvent"
        elseif menuConfig.command then
            enabledMenus[#enabledMenus].type = "command"
        elseif menuConfig.exports then
            enabledMenus[#enabledMenus].type = "exports"
        elseif menuConfig.action then
            enabledMenus[#enabledMenus].type = "function"
        end

        if hasSubMenus then
            enabledMenus[#enabledMenus].items = dataElements
        end

        :: continue ::
    end

    if not MenuReady then
        SendNUIMessage({
            state = "show",
            data = enabledMenus,
        })
        SetCursorLocation(0.5, 0.5)
        SetNuiFocus(true, true)
    
        PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
        MenuReady = true
    end
end

local keybind = lib.addKeybind({
    name = 'rhd_radialaction:jnck',
    description = 'Radial Menu',
    defaultKey = Config.OpenRadialKey,
    onPressed = radialAction,
})

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
    if data.type == "exports" then
        useExport(string.strsplit('.', ExecuteData(data.export)))
    else
        ExecuteData(data.action)
    end
    cb('ok')
end)

RegisterCommand("closeradial", function ()
    SetNuiFocus(false, false)
    SendNUIMessage({
        state = 'destroy'
    })
end)

AddEventHandler('onClientResourceStop', function(resource)
    for i = #Config.ItemRadial, 1, -1 do
        local item = Config.ItemRadial[i]
        if item.resources == resource then
            table.remove(Config.ItemRadial, i)
        end
    end
end)

exports('addRadialItem', addRadialItem)
exports('removeRadialItem', removeRadialItem)
exports('disableRadial', function ( boolean )
    radialDisable = boolean or not radialDisable
    keybind:disable( radialDisable )
end)