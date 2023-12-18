# RHD Radial Menu
Radial menu for ESX &amp; QBCore Framework

# Feature
- Easy Configuration
- Low Resmon
- add or remove radial items via export

# Example
- Add Radial
```
   exports.rhd_radialmenu:addRadialItem({
        id = "test_radial", --- radial id
        label = "Test Radial", --- label radial
        icon = "#parking", --- radial icon
        action = function ()
            TriggerEvent("namaevent", "args")
        end
    })
```

- Remove Radial
```
   exports.rhd_radialmenu:removeRadialItem("test_radial")
```

# Dependencies 
- [ox_lib](https://github.com/overextended/ox_lib/releases)

# Need Support?
- [Discord](https://discord.gg/TJsyCsS4z7)
