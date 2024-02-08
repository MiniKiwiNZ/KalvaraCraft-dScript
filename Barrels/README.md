# dBarrels: *Simple Barrels Powered by Denizen*

## Configuration
Inside any of the `*Barrel.dsc` file, you will find two settings that can be changed:
- **stacks**: The number of stacks of items that can be contained within the particular tier of barrel
- **icon**: The ID of the block or item to use as the icon for the barrel tier. This is displayed in the top-left corner of the barrel

## Usage
A basic Wooden Barrel can be crafted using a normal barrel, plus any four planks, and any four wood or hyphae in the following pattern:

![Wooden Barrel Crafting Recipe](https://i.imgur.com/oxs29hp.png)

Further tiers of barrels can be crafted - each one requiring the preceding barrel to be used to craft it, along with four ingots and four blocks of their respective material:

![Copper Barrel Crafting Recipe](https://i.imgur.com/uem54f1.png)

The tiers are as follows:
- Wood (32 stacks)
- Copper (64 stacks)
- Iron (128 stacks)
- Gold (256 stacks)
- Diamond (512 stacks)
- Netherite (1024 stacks)

Barrels are compatible with droppers, hoppers, and hopper minecarts.
Barrels retain their inventory when broken and can be upgraded without losing their contents.

## Installation
Simply install the folder containing the barrel scripts into your Denizen scripts directory and reload your active scripts using `/ex reload`
