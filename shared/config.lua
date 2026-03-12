config = {
    maxrentaltime = 120,
    deleteonlogout = true,
    locations = {
        {
            name = 'Alta Rental',
            coords = vector3(-292.9890, -986.5478, 31.1823),
            ped = 'a_m_m_prolhost_01',
            scenario = 'WORLD_HUMAN_CLIPBOARD',
            heading = 67.0778,
            blip = {
                sprite = 739,
                color = 18,
                scale = 0.4,
                name = 'Car Rental'
            },
            spawnLocations = {
                vector4(-297.8791, -990.8251, 31.0806, 342.4319),
                vector4(-301.3070, -989.5336, 31.0806, 338.4444),
                vector4(-304.8968, -988.1276, 31.0806, 339.7277),
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
        },
        {
            name = 'Ellipse Rental',
            coords = vector3(-815.0679, 367.9860, 88.0256),
            ped = 'a_m_m_prolhost_01',
            scenario = 'WORLD_HUMAN_CLIPBOARD',
            heading = 178.4349,
            blip = {
                sprite = 739,
                color = 18,
                scale = 0.4,
                name = 'Car Rental'
            },
            spawnLocations = {
                vector4(-810.2570, 373.5934, 87.8761, 181.1230),
                vector4(-806.7034, 373.6378, 87.8760, 179.1052),
                vector4(-803.0668, 373.5620, 87.8760, 178.5657),
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
        },
        {
            name = 'Paleto Boat Rental',
            coords = vector3(-479.1082, 6491.4429, 1.3490),
            ped = 'a_m_y_beach_01',
            scenario = 'WORLD_HUMAN_CLIPBOARD',
            heading = 169.7433,
            blip = {
                sprite = 739,
                color = 18,
                scale = 0.4,
                name = 'Boat Rental'
            },
            spawnLocations = {
                vector4(-474.6448, 6493.7183, -0.4748, 40.2823),
                vector4(-494.9223, 6479.6235, -0.5616, 33.9507),
            },
            vehicles = {
                {
                    model = 'dinghy2',
                    name = 'Dinghy',
                    type = 'boat', --=+ car | bike | motorcycle | truck | boat | plane | helicopter +=--
                    price = 1, --=+ per min +=--
                    maxduration = 120
                },
                {
                    model = 'jetmax',
                    name = 'Jetmax',
                    type = 'boat', --=+ car | bike | motorcycle | truck | boat | plane | helicopter +=--
                    price = 5, --=+ per min +=--
                    maxduration = 120
                },
            }
        },
        {
            name = 'Sandy Boat Rental',
            coords = vector3(1302.1527, 4226.6514, 33.9086),
            ped = 'a_m_y_beach_01',
            scenario = 'WORLD_HUMAN_CLIPBOARD',
            heading = 74.1660,
            blip = {
                sprite = 739,
                color = 18,
                scale = 0.4,
                name = 'Boat Rental'
            },
            spawnLocations = {
                vector4(1297.2401, 4255.0942, 29.9183, 168.8769),
                vector4(1290.3575, 4222.9116, 29.5409, 168.5125),
            },
            vehicles = {
                {
                    model = 'dinghy2',
                    name = 'Dinghy',
                    type = 'boat', --=+ car | bike | motorcycle | truck | boat | plane | helicopter +=--
                    price = 1, --=+ per min +=--
                    maxduration = 120
                },
                {
                    model = 'jetmax',
                    name = 'Jetmax',
                    type = 'boat', --=+ car | bike | motorcycle | truck | boat | plane | helicopter +=--
                    price = 5, --=+ per min +=--
                    maxduration = 120
                },
            }
        },
        {
            name = 'Sandy Boat Rental',
            coords = vector3(-757.2515, -1506.7616, 5.1017),
            ped = 'a_m_y_beach_01',
            scenario = 'WORLD_HUMAN_CLIPBOARD',
            heading = 19.9231,
            blip = {
                sprite = 739,
                color = 18,
                scale = 0.4,
                name = 'Boat Rental'
            },
            spawnLocations = {
                vector4(-788.2521, -1513.6902, -0.4749, 109.8442),
                vector4(-788.9818, -1503.8086, -0.4749, 109.4194),
                vector4(-792.2382, -1497.1014, -0.4749, 110.8083),
                vector4(-796.8674, -1487.5762, -0.4749, 110.1769),
            },
            vehicles = {
                {
                    model = 'dinghy2',
                    name = 'Dinghy',
                    type = 'boat', --=+ car | bike | motorcycle | truck | boat | plane | helicopter +=--
                    price = 1, --=+ per min +=--
                    maxduration = 120
                },
                {
                    model = 'jetmax',
                    name = 'Jetmax',
                    type = 'boat', --=+ car | bike | motorcycle | truck | boat | plane | helicopter +=--
                    price = 5, --=+ per min +=--
                    maxduration = 120
                },
            }
        },
    }
}
