extends Resource
class_name Dialogue

@export_category("Information")
@export var texture : Texture2D
@export var name: String
@export var dialogue : String

@export_category("Linking Nodes")
@export var path_option : String
@export var options : Array[Dialogue]
