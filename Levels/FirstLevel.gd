extends Node3D


@export var camera_speed: float = 1.0

@onready var dialogs: DialogController = $Dialogs
@onready var fader: Fader = $Fader

@onready var character: CharacterController = $CharacterController
@onready var camera_spring: Node3D = character.camera_spring
@onready var camera: CharacterCamera = character.camera

@onready var tampio: Node3D = $Tampio
@onready var tampio_interaction_area: InteractionArea = $Tampio/InteractionArea
@onready var tampio_animation_tree: AnimationTree = $Tampio/Tampio/AnimationTree
@onready var tampio_animation_playback: AnimationNodeStateMachinePlayback = tampio_animation_tree.get("parameters/playback")

const BLOCKER_ID := "FIRST_LEVEL_CINEMATIC"

var normal_camera_target: Node3D
var normal_camera_speed: float

func _ready() -> void:
	await fader.fade_in(0)
	ControlBlocker.add_blocker(BLOCKER_ID)
	camera_spring.rotation = Vector3(-PI/8, PI, 0)
	await dialogs.show_dialog(Dialog.following("Kuka minä olen?", Dialog.action("Ja missä minä olen?", _pan_to_tampio))).closed
	await fader.fade_out()

func _pan_to_tampio(_controller: DialogController) -> void:
	dialogs.close()
	await get_tree().create_timer(2).timeout
	normal_camera_target = camera.look_at_target
	normal_camera_speed = camera.camera_speed
	camera.look_at_target = tampio
	camera.camera_speed = camera_speed
	await camera.target_reached
	dialogs.show_dialog(Dialog.following("Siellä on joku!", Dialog.action("Ehkä hänellä on vastauksia", _reset_panned_to_tampio)))
	
func _reset_panned_to_tampio(_controller: DialogController) -> void:
	camera.look_at_target = normal_camera_target
	await camera.target_reached
	camera.camera_speed = normal_camera_speed
	dialogs.close()
	ControlBlocker.remove_blocker(BLOCKER_ID)


func _on_interaction_area_interacted(_area: InteractionArea):
	tampio_interaction_area.queue_free()
	ControlBlocker.add_blocker(BLOCKER_ID)
	tampio_animation_playback.travel("Look Down")
	var tween := create_tween()
	var tampio_target := tampio.global_transform.looking_at(character.global_transform.origin).basis.rotated(Vector3.UP, PI)
	tween.tween_property(tampio, "rotation", tampio_target.get_euler(), 1)
	var character_target := character.pawn.global_transform.looking_at(tampio.global_transform.origin).basis
	tween.parallel().tween_property(character.pawn, "rotation", character_target.get_euler(), 1)
	await tween.finished
	await dialogs.show_dialog(Dialog.following("Tampio: Moi Vanilja.",
		Dialog.following("Vanilja: Tunnetko minut?",
		Dialog.following("Tampio: Kyllä. Olet Vanilja. Maailman erikoisin pehmolelu. On ilo tavata sinut. Olen Tampio. Minut tunnetaan monella nimellä siellä alhaalla. Yksi niistä on \"Jumala\". Vähän makee he?",
		Dialog.following("Vanilja: Miten niin?",
		Dialog.following("Tampio: Sinulla on erittäin tärkeä tehtävä.",
		Dialog.following("Vanilja: Voisitko mitenkään olla tarkempi?",
		Dialog.following("Tampio: No tosiaan, sinulla on kaksi tehtävää.",
		Dialog.following("Tampio: Tärkein tehtäväsi on pitää Miska iloisena ja onnellisena.",
		Dialog.following("Vanilja: En malta odottaa, että tutustun häneen!",
		Dialog.following("Tampio: Toinen tehtäväsi on järjestää kettubileitä.",
		Dialog.following("Vanilja: Kettubileitä? No sehän kuulostaa hyvältä!",
		Dialog.following("Tampio: Niinpä. Mutta siihen muut ketut siellä alhaalla tarvitsevat apuasi.",
		Dialog.following("Tampio: Heiltä puuttuu sipsejä...",
		Dialog.following("Vanilja: Oi... sipsittömät kettubileet... Se kuulostaa melko pahalta!",
		Dialog.following("Tampio: Melko paha on hyvä litootti, koska se on hirveää!",
		Dialog.following("Tampio: Luuletko, että pystyt siihen?",
		Dialog.following("Vanilja: Kyllä. Minä löydän kaikki sipsit, jotka tarvitaan kettubileisiin!",
		Dialog.end("Tampio: Olet sitten valmis seikkailuusi. Onnea!",
		))))))))))))))))))).closed


func _on_pit_player_respawned():
	dialogs.show_dialog(Dialog.end("MITÄÄÄÄÄÄÄ?"))
