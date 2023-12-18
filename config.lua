Config = {}
Config.OpenRadialKey = "F1"

Config.ItemRadial = {
    {
        id = 'citizen',
        label = 'Citizen',
        icon = '#user',
        canEnable = function ()
            local Mati = exports.qbx_medical:getLaststand() or exports.qbx_medical:isDead()
            return not Mati
        end,
        options = {
            {
                id = 'citizen_escort',
                label = 'Escort',
                icon = '#user-secret',
                exports = 'rhd_lib.dragPlayer',
            }, {
                id = "citizen_putinveh",
                label = "Put In Veh",
                icon = "#car-side",
                exports = "rhd_lib.putInVeh"
            }, {
                id = "citizen_putoutveh",
                label = "Put Out Veh",
                icon = "#car-side",
                exports = "rhd_lib.putOutVeh"
            }, {
                id = "citizen_takehostage",
                label = "Take Hostage",
                icon = "#gun",
                event = "takehostage:target"
            }, {
                id = "citizen_carry",
                label = "Carry",
                icon = "#user-group",
                options = {
                    {
                        id = "citizen_carry_1",
                        label = "Carry 1",
                        icon = "#user-group",
                        action = function ()
                            exports.rhd_carry:start("carry1")
                        end
                    },
                    {
                        id = "citizen_carry_2",
                        label = "Carry 2",
                        icon = "#user-group",
                        action = function ()
                            exports.rhd_carry:start("carry2")
                        end
                    },
                    {
                        id = "citizen_carry_3",
                        label = "Carry 3",
                        icon = "#user-group",
                        action = function ()
                            exports.rhd_carry:start("carry3")
                        end
                    },
                    {
                        id = "citizen_carry_stop",
                        label = "Stop Carry",
                        icon = "#circle-xmark",
                        action = function ()
                            exports.rhd_carry:stop()
                        end
                    }
                }
            }
        }
    },
    {
        id = 'general',
        label = 'General',
        icon = '#globe-europe',
        canEnable = function ()
            local Mati = exports.qbx_medical:getLaststand() or exports.qbx_medical:isDead()
            return not Mati
        end,
        options = {
            {
                id = 'phone',
                label = "Phone",
                icon = '#phone',
                action = function ()
                    if exports.ox_inventory:Search("count", "phone") < 1 then return exports.cloudv:Notify("Anda tidak memiliki hp", "error", 5000) end
                    ExecuteCommand("TooglePhone")
                end,
            },
            {
                id = 'citizen_invoice',
                label = "Invoice",
                icon = '#file-invoice-dollar',
                exports = "rhd_invoice.GetInvoice"
            },
            {
                id = 'citizen_vehcontol',
                label = "Veh Control",
                icon = '#car-on',
                event = "vehcontrol:openExternal"
            },
            {
                id = "general_flipvehicle",
                label = "Flip Vehicle",
                icon = "#car-crash",
                action = function ()
                    local myCoords = GetEntityCoords(cache.ped)
                    local veh = lib.getClosestVehicle(myCoords, 5.0)

                    if not veh then 
                        exports.cloudv:Notify("Tidak ada kendaraan di dekat mu !", "error", 8000)
                        return
                    end

                    ExecuteCommand("e mechanic")
                    
                    -- if lib.progressBar({
                    if exports.rhd_lib:Progress({
                        duration = 15000,
                        label = 'Membalik Kendaraan...',
                        useWhileDead = false,
                        canCancel = true,
                        disable = {
                            move = true,
                            car = true
                        },
                    }) then
                        local myCoords = GetEntityCoords(cache.ped)
                        local veh = lib.getClosestVehicle(myCoords, 5.0)
                        if DoesEntityExist(veh) then
                            SetVehicleOnGroundProperly(veh)
                        end
                        ClearPedTasks(cache.ped)
                    else
                        ClearPedTasks(cache.ped)
                    end
                end
            }
        }
    },
    {
        id = "ambulance_radial",
        label = "EMS Action",
        icon = "#user-doctor",
        canEnable = function ()
            return QBX.PlayerData.job.name == "ambulance" and QBX.PlayerData.job.onduty
        end,
        options = {
            {
                id = 'ems_invoice',
                label = "Make Invoice",
                icon = '#file-invoice-dollar',
                exports = "rhd_invoice.CreateInvoice",
                canEnable = function ()
                    local Mati = exports.qbx_medical:getLaststand() or exports.qbx_medical:isDead()
                    return not Mati
                end,
            },
            {
                id = 'ems_statuscheck',
                label = 'Check Health Status',
                icon = '#heart-pulse',
                event = 'hospital:client:CheckStatus',
                canEnable = function ()
                    local Mati = exports.qbx_medical:getLaststand() or exports.qbx_medical:isDead()
                    return not Mati
                end,
            },{
                id = 'ems_revivep',
                label = 'Revive',
                icon = '#user-doctor',
                event = 'hospital:client:RevivePlayer',
                canEnable = function ()
                    local Mati = exports.qbx_medical:getLaststand() or exports.qbx_medical:isDead()
                    return not Mati
                end,
            },{
                id = 'ems_treatwounds',
                label = 'Heal wounds',
                icon = '#bandage',
                event = 'hospital:client:TreatWounds',
                canEnable = function ()
                    local Mati = exports.qbx_medical:getLaststand() or exports.qbx_medical:isDead()
                    return not Mati
                end,
            }, {
                id = 'ems_emergencybutton2',
                label = 'Emergency button',
                icon = '#bell',
                exports = "ps-dispatch.EmsDown",
            }, {
                id = 'ems_escort',
                label = 'Escort',
                icon = '#user-secret',
                exports = 'rhd_lib.dragPlayer',
                canEnable = function ()
                    local Mati = exports.qbx_medical:getLaststand() or exports.qbx_medical:isDead()
                    return not Mati
                end,
            }, {
                id = "ems_putinveh",
                label = "Put In Veh",
                icon = "#car-side",
                exports = "rhd_lib.putInVeh",
                canEnable = function ()
                    local Mati = exports.qbx_medical:getLaststand() or exports.qbx_medical:isDead()
                    return not Mati
                end,
            }, {
                id = "ems_putoutveh",
                label = "Put Out Veh",
                icon = "#car-side",
                exports = "rhd_lib.putOutVeh",
                canEnable = function ()
                    local Mati = exports.qbx_medical:getLaststand() or exports.qbx_medical:isDead()
                    return not Mati
                end,
            }
        }
    },
    {
        id = "police_radial",
        label = "Police Action",
        icon = "#user-shield",
        canEnable = function ()
            return QBX.PlayerData.job.name == "police" and QBX.PlayerData.job.onduty
        end,
        options = {
            {
                id = 'police_invoice',
                label = "Make Invoice",
                icon = '#file-invoice-dollar',
                exports = "rhd_invoice.CreateInvoice",
                canEnable = function ()
                    local Mati = exports.qbx_medical:getLaststand() or exports.qbx_medical:isDead()
                    return not Mati
                end,
            },
            {
                id = 'police_emergencybutton',
                label = 'Emergency button',
                icon = '#bell',
                exports = "ps-dispatch.OfficerDown",
            },{
                id = 'police_takedriverlicense',
                label = 'Revoke Drivers License',
                icon = '#id-card',
                event = 'police:client:SeizeDriverLicense',
                canEnable = function ()
                    local Mati = exports.qbx_medical:getLaststand() or exports.qbx_medical:isDead()
                    return not Mati
                end,
            }, 
            {
                id = 'police_traficstop',
                label = 'Traffic Stop',
                icon = "#traffic-light",
                event = "ps-mdt:client:trafficStop",
                canEnable = function ()
                    local Mati = exports.qbx_medical:getLaststand() or exports.qbx_medical:isDead()
                    return not Mati
                end,
            },
            {
                id = 'police_policeinteraction',
                label = 'Interaction',
                icon = '#list-check',
                canEnable = function ()
                    local Mati = exports.qbx_medical:getLaststand() or exports.qbx_medical:isDead()
                    return not Mati
                end,
                options = {
                    {
                        id = 'police_checkstatus',
                        label = 'Check status',
                        icon = '#question',
                        event = 'police:client:CheckStatus',
                    },
                    {
                        id = "police_pinfocheck",
                        label = "Citizen Info",
                        icon = "#address-card",
                        exports = "rhd_lib.charinfoClosest"
                    },
                    {
                        id = 'police_escort',
                        label = 'Escort',
                        icon = '#user-secret',
                        exports = 'rhd_lib.dragPlayer',
                    }, {
                        id = "police_putinveh",
                        label = "Put In Veh",
                        icon = "#car-side",
                        exports = "rhd_lib.putInVeh"
                    }, {
                        id = "police_putoutveh",
                        label = "Put Out Veh",
                        icon = "#car-side",
                        exports = "rhd_lib.putOutVeh"
                    }, {
                        id = "police_togglecuff",
                        label = "Cuff/Uncuff",
                        icon = "#handcuffs",
                        exports = "rhd_lib.borgolPlayer"
                    }, {
                        id = 'police_searchplayer',
                        label = 'Search',
                        icon = '#magnifying-glass',
                        action = function ()
                            local myCoords = GetEntityCoords(cache.ped)
                            local player = lib.getClosestPlayer(myCoords)

                            if not player then
                                exports.cloudv:Notify("Tidak ada orang di dekat mu", "error", 8000)
                                return
                            end

                            ExecuteCommand("me menggeledah")
                            exports.ox_inventory:openNearbyInventory()
                        end,
                    }, {
                        id = 'police_jailplayer',
                        label = 'Jail',
                        icon = '#user-lock',
                        event = 'police:client:JailPlayer',
                    }
                }
            },
            {
                id = 'police_policeobjects',
                label = 'Objects',
                icon = '#road',
                canEnable = function ()
                    local Mati = exports.qbx_medical:getLaststand() or exports.qbx_medical:isDead()
                    return not Mati
                end,
                options = {
                    {
                        id = 'police_spawnpion',
                        label = 'Cone',
                        icon = '#triangle-exclamation',
                        event = 'police:client:spawnPObj',
                        params = 'cone',
                    }, {
                        id = 'police_spawnhek',
                        label = 'Gate',
                        icon = '#torii-gate',
                        event = 'police:client:spawnPObj',
                        params = 'barrier',
                    }, {
                        id = 'police_spawnschotten',
                        label = 'Speed Limit Sign',
                        icon = '#sign-hanging',
                        event = 'police:client:spawnPObj',
                        params = 'roadsign',
                    }, {
                        id = 'police_spawntent',
                        label = 'Tent',
                        icon = '#campground',
                        event = 'police:client:spawnPObj',
                        params = 'tent',
                    }, {
                        id = 'police_spawnverlichting',
                        label = 'Lighting',
                        icon = '#lightbulb',
                        event = 'police:client:spawnPObj',
                        params = 'light',
                    }, {
                        id = 'police_spikestrip',
                        label = 'Spike Strips',
                        icon = '#caret-up',
                        event = 'police:client:SpawnSpikeStrip',
                    }, {
                        id = 'police_deleteobject',
                        label = 'Remove object',
                        icon = '#trash',
                        event = 'police:client:deleteObject',
                    }
                }
            }
        }
    },
    {
        id = "mechanic_radial",
        label = "Mechanic Action",
        icon = "#user-gear",
        canEnable = function ()
            local Mati = exports.qbx_medical:getLaststand() or exports.qbx_medical:isDead()
            return QBX.PlayerData.job.name == "mechanic" and QBX.PlayerData.job.onduty and not Mati
        end,
        options = {
            {
                id = 'mechanic_invoice',
                label = "Make Invoice",
                icon = '#file-invoice-dollar',
                exports = "rhd_invoice.CreateInvoice"
            },
            {
                id = "mechanic_repairveh",
                label = "Repair Vehicle",
                icon = "#wrench",
                exports = "rhd_whitelistjob.useRepairKit"
            },
            {
                id = "mechanic_cleanveh",
                label = "Clean Vehicle",
                icon = "#soap",
                exports = "rhd_whitelistjob.cleanVehicle",
            },
            {
                id = "mechanic_impound",
                label = "Impound Vehicle",
                icon = "#car",
                exports = "rhd_whitelistjob.impoundVehicle",
            },
            {
                id = "mechanic_tow",
                label = "Tow Vehicle",
                icon = "#truck-pickup",
                exports = "rhd_whitelistjob.towvehicle",
            }
        }
    },
    {
        id = "taxi_radial",
        label = "Taxi Action",
        icon = "#taxi",
        canEnable = function ()
            local Mati = exports.qbx_medical:getLaststand() or exports.qbx_medical:isDead()
            return QBX.PlayerData.job.name == "taxi" and QBX.PlayerData.job.onduty and not Mati
        end,
        options = {
            {
                id = 'taxi_invoice',
                label = "Make Invoice",
                icon = '#file-invoice-dollar',
                exports = "rhd_invoice.CreateInvoice"
            },
            {
                id = 'taxi_togglemeter',
                label = 'Show/Hide Meter',
                icon = '#eye-slash',
                exports = 'taximeter.toggleMeter',
            }, {
                id = 'taxi_togglemouse',
                label = 'Start/Stop Meter',
                icon = '#hourglass-start',
                exports = 'taximeter.enableMeter',
            },
        }
    },
    {
        id = "government_radial",
        label = "Government Action",
        icon = "#user-tie",
        canEnable = function ()
            local Mati = exports.qbx_medical:getLaststand() or exports.qbx_medical:isDead()
            return QBX.PlayerData.job.name == "government" and QBX.PlayerData.job.onduty and not Mati
        end,
        options = {
            {
                id = 'government_invoice',
                label = "Make Invoice",
                icon = '#file-invoice-dollar',
                exports = "rhd_invoice.CreateInvoice"
            },
            {
                id = 'government_escort',
                label = 'Escort',
                icon = '#user-secret',
                exports = 'rhd_lib.dragPlayer',
            }, {
                id = "government_putinveh",
                label = "Put In Veh",
                icon = "#car-side",
                exports = "rhd_lib.putInVeh"
            }, {
                id = "government_putoutveh",
                label = "Put Out Veh",
                icon = "#car-side",
                exports = "rhd_lib.putOutVeh"
            },
            {
                id = "governmen_togglecuff",
                label = "Cuff/Uncuff",
                icon = "#handcuffs",
                exports = "rhd_lib.borgolPlayer"
            },
            {
                id = "government_impound",
                label = "Impound Vehicle",
                icon = "#car",
                exports = "rhd_whitelistjob.impoundVehicle",
            },
        }
    },
    {
        id = "nightclub_radial",
        label = "Vanilla Unicorn Action",
        icon = "#glass-martini",
        canEnable = function ()
            local Mati = exports.qbx_medical:getLaststand() or exports.qbx_medical:isDead()
            return QBX.PlayerData.job.name == "nightclub" and QBX.PlayerData.job.onduty and not Mati
        end,
        options = {
            {
                id = 'nightclub_invoice',
                label = "Make Invoice",
                icon = '#file-invoice-dollar',
                exports = "rhd_invoice.CreateInvoice"
            },
            {
                id = 'nightclub_escort',
                label = 'Escort',
                icon = '#user-secret',
                exports = 'rhd_lib.dragPlayer',
            },
            {
                id = "governmen_togglecuff",
                label = "Cuff/Uncuff",
                icon = "#handcuffs",
                exports = "rhd_lib.borgolPlayer"
            },
        }
    },
}