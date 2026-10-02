extends CollisionPolygon2D

func _ready() -> void:
	var polygon_2d: Polygon2D = get_node_or_null("res://Scenes/basic_polygon.tscn")
	if polygon_2d:
		polygon = polygon_2d.polygon
