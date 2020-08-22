extends Control

var hearts = 1 setget set_hearts
var max_hearts = 1 setget set_max_hearts

onready var fullTexture = $TextureFull
onready var emptyTexture = $TextureEmpty

func set_hearts(val):
	hearts = clamp(val, 0, max_hearts)
	fullTexture.rect_size.x = 16 * hearts

func set_max_hearts(val):
	max_hearts = max(val, 1)
	emptyTexture.rect_size.x = 16 * max_hearts

func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	var _err = PlayerStats.connect("health_changed", self, "set_hearts")
