config = {
    maxrentaltime = 120,
    deleteonlogout = true,
    locations = {
        {
            name = 'Alta Rental',
            coords = vector3(-292.9890, -986.5478, 31.1823),
            ped = 'a_m_y_hasjew_01',
            scenario = 'WORLD_HUMAN_CLIPBOARD',
            heading = 67.0778,
            blip = {
                sprite = 739,
                color = 18,
                scale = 0.6,
                name = 'Car Rental'
            },
            spawnLocations = {
                vector4(-297.8791, -990.8251, 31.0806, 342.4319),
                vector4(-301.3070, -989.5336, 31.0806, 338.4444),
                vector4(-304.8968, -988.1276, 31.0806, 339.7277)
            }
        },
        {
            name = 'Ellipse Rental',
            coords = vector3(-815.0679, 367.9860, 88.0256),
            ped = 'a_m_y_hasjew_01',
            scenario = 'WORLD_HUMAN_CLIPBOARD',
            heading = 178.4349,
            blip = {
                sprite = 739,
                color = 18,
                scale = 0.6,
                name = 'Car Rental'
            },
            spawnLocations = {
                vector4(-810.2570, 373.5934, 87.8761, 181.1230),
                vector4(-806.7034, 373.6378, 87.8760, 179.1052),
                vector4(-803.0668, 373.5620, 87.8760, 178.5657)
            }
        }
    },
    vehicles = {
        {
            model = 'bmx',
            name = 'BMX',
            type = 'bike', --=+ car | bike | motorcycle | truck | boat | plane | helicopter +=--
            price = 1, --=+ per min +=--
            maxduration = 120
        },
        {
            model = 'faggio',
            name = 'Faggio',
            type = 'motorcycle', --=+ car | bike | motorcycle | truck | boat | plane | helicopter +=--
            price = 5, --=+ per min +=--
            maxduration = 120
        },
        {
            model = 'blista',
            name = 'Blista',
            type = 'car', --=+ car | bike | motorcycle | truck | boat | plane | helicopter +=--
            price = 15, --=+ per min +=--
            maxduration = 120
        },
    }
}
