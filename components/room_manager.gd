class_name RoomManager
extends Node2D


func _ready() -> void:
	var shed_key = Item.new("shed key", Item.ItemType.KEY)
	$Shed.connect_exit_locked("outside", $BackOfTheTavern, shed_key, "The door is locked.")
	$Shed.add_item(shed_key)
	var kitchen_key = Item.new("kitchen key", Item.ItemType.KEY)
	$BackOfTheTavern.connect_exit_locked("north", $Kitchen, kitchen_key, "The tavern's back door is locked.")
	$BackOfTheTavern.connect_exit_unlocked("path", $Mudborough)
	$Kitchen.connect_exit_unlocked("north", $SoggyBoot)
	$Kitchen.add_item(kitchen_key)
	$Mudborough.connect_exit_unlocked("west", $Field)
	$Mudborough.connect_exit_unlocked("north", $TownGate)
	$Mudborough.connect_exit_unlocked("inside", $SoggyBoot)
	$TownGate.connect_exit_locked("forest", $Forest, null, "As you attempt to leave the village the guard stands before the gate, his pick pointed at you.", "gate")
