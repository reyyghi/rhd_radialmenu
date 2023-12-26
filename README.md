
# RHD Radial Menu
Radial menu for ESX &amp; QBCore Framework

# Feature
- Easy Configuration
- Low Resmon
- add or remove radial items via export


# Radial Items
| Items      | Type | Description    |
|-----------|------|---------|
|    event   | client event| To trigger client events|
|    export | exports      | To use exports from other scripts|     
|    action | function      | To use the function|      
|    command | command      | For trigger commands available on the server|                                  |
|    KeepOpen  |   boolean   | Change it to true if you want the radial to remain open when selecting items|
|    canEnable |   function      | Checking conditions for opening radials                                     |
|    serverEvent | server event      | To trigger server events                                     |


# Example
* Add Radial

```lua
    local RadialItems = {
        id = "rhd_test:radial",
        label = "JNCK TEAM",
        icon = "#user",
        KeepOpen = true,
        canEnable = function()
            return not IsEntityDead(cache.ped) --- can only be opened when the player is alive
        end,
    }

    --- using command
    RadialItems.command = "e damn"

    --- using client event
    RadialItems.event = "rhd_lib:testEvent"

    --- using server event
    RadialItems.serverEvent = "rhd_lib:testEvent"

    --- using exports
    RadialItems.export = "ox_inventory.openNearbyInventory"

    --- using action
    RadialItems.action = function()
        print("JNCK TEAM")
    end


    exports.rhd_radialmenu:addRadialItem(RadialItems)
```

* Remove Radial
```lua
   exports.rhd_radialmenu:removeRadialItem("rhd_test:radial")
```

* Disable Radial
```lua
   exports.rhd_radialmenu:disableRadial(true --[[@as boolean]])
```

# Dependencies 
- [ox_lib](https://github.com/overextended/ox_lib/releases)

# Need Support?
- [Discord](https://discord.gg/K4BhPY3ySB)
