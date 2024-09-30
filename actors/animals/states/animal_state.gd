extends State
class_name AnimalState


const IDLE = "Idle"
const WANDER = "Wander"
const DEAD = "Dead"
const CHASE = "Chase"
const ATTACK = "Attack"
const HURT = "Hurt"
const FLEE = "Flee"


var animal: Animal


func _ready() -> void:
  await owner.ready
  animal = owner as Animal
  assert(animal != null, "The AnimalState must have an animal.")