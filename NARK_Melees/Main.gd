extends Node

const ITEMS = [
	["NARK_M9_Bayonet", "res://NARK_M9_Bayonet/M9_Bayonet"],
	["NARK_Ice_Pick", "res://NARK_Ice_Pick/Ice_Pick"],
	["NARK_Hatchet", "res://NARK_Hatchet/Hatchet"],
	["NARK_Combat_Knife", "res://NARK_Combat_Knife/Combat_Knife"],
	["NARK_Karambit", "res://NARK_Karambit/Karambit"]
]

func _ready():
	var lib = Engine.get_meta("RTVModLib", null)
	if lib == null or not lib.has_method("register"):
		push_error("NARK's Melees requires Metro Mod Loader with registry support.")
		return
	for entry in ITEMS:
		register_item(lib, entry[0], entry[1])

func register_item(lib: Object, id: String, path: String):
	var item = load(path + ".tres")
	var world = load(path + ".tscn")
	var rig = load(path + "_Rig.tscn")
	if item == null or world == null or rig == null:
		push_error("NARK's Melees could not load " + id + ".")
		return
	var ok = lib.register("items", id, item)
	ok = lib.register("scenes", id, world) and ok
	ok = lib.register("scenes", id + "_Rig", rig) and ok
	ok = lib.register("loot", id + "_Master", {"item": item, "table": "LT_Master"}) and ok
	if not ok:
		push_error("NARK's Melees registration failed for " + id + ".")
