# Simple Vehicle Rental

A streamlined vehicle rental system for FiveM utilizing the Ox resource suite. This script allows players to rent various vehicle types (cars, bikes, planes, etc.) for a set duration, featuring real-time expiry tracking and automated vehicle cleanup.


## Features

* **Dynamic Rental Menu**: Clean UI using `ox_lib` context menus with support for custom vehicle images.
* **Diverse Vehicle Support**: Pre-configured categories for bikes, cars, motorcycles, trucks, boats, planes, and helicopters.
* **Smart Spawn System**: Checks if spawn locations are clear of vehicles, objects, or NPCs before spawning a rental.
* **Time Management**: Integrated countdown system that notifies players as their rental nears expiration.
* **Persistence & Cleanup**: Automatically deletes rental vehicles upon player logout or death to maintain server performance.
* **Ox Suite Integration**: Built-in support for `ox_inventory`, `ox_lib`, `ox_target`, and `oxmysql`.


## Installation

1. Ensure you have the following dependencies installed:
* `ox_lib`
* `ox_target`
* `ox_inventory`
* `qbx_core` (for money management)

2. Place the `perc-rental` folder into your resources directory.
3. Configure your rental locations and vehicle pricing in `config.lua`.
4. Add `ensure perc-rental` to your `server.cfg`.


## Commands

#### /checkrental

Allows players to check the remaining time on their current vehicle rental.


## Preview

The rental menu displays vehicle details, prices, and images for a better user experience.
![External image](https://r2.fivemanage.com/vTtICY7I82AzRhxsoOZXb/perc-rental.png)