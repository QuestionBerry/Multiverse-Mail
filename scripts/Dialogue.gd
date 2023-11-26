extends RichTextLabel


var queue = []
var print_speed = 15.0
var next_char_count = 0.0
var done_printing = true

func _ready():
	set_process(false)

func _process(delta):
	next_char_count += print_speed * delta
	
	if next_char_count >= 1.0:
		next_char_count = 0
		visible_characters += 1
		if visible_ratio >= 1.0:
			line_complete()

func line_complete():
	set_process(false)
	await get_tree().create_timer(2.5).timeout
	queue.pop_front()
	if len(queue) >= 1: #Process next line
		self.visible_characters = 0 
		self.text = str("[center]", queue[0], "[/center]")
		set_process(true)
	else:
		self.visible_characters = 0
		self.text = ""
		done_printing = true

func add_dialogue(type : String):
	match type:
		"earth":
			queue.append(earth_dialogue.pick_random())
		"magic":
			queue.append(magic_dialogue.pick_random())
		"cyber":
			queue.append(cyber_dialogue.pick_random())
		"fragile":
			queue.append(fragile_dialogue.pick_random())
		"expedited":
			queue.append(expedited_dialogue.pick_random())
		_:
			print("Invalid dialogue selection")
	
	if done_printing:
		done_printing = false
		self.text = str("[center]", queue[0], "[/center]")
		set_process(true)


var earth_dialogue = [
	"Need this shipped, please.",
	"I'm shipping some stuff to my new apartment.",
	"I did it! My comic books finally sold!",
	"I hope this gets there in time.",
	"It's my first time in a post office!",
	"Hoping to get this shipped, if you can handle it.",
	"Hi there! Looking to ship a package.",
	"Hello, hoping to ship some records.",
	"Thank goodness you're open, I just remembered my kid's birthday.",
	"Hope you're havin a nice day!",
]

var magic_dialogue = [
	"Good morning good sir or madam.",
	"Good day, I request your services.",
	"I need these ingredients shipped, post haste!",
	"Is this the famous Multi-universal Mail Service?",
	"I'd love to learn more about how this establishment works!",
	"I need these scolls sent to my colleagues.",
	"I'd teleport this myself, but I don't know how yet.",
	"I'm shipping some cloaks to kids in need.",
	"I'm surprised I could fit all my tomes in there.",
	"Ala Ka Zam, Ala Ka Zee, can you ship this for me?",
]

var cyber_dialogue = [
	"Sick place, love what you guys do.",
	"Need this *beep* shipped. Aw *beep* I'm beeping again.",
	"I need something sent to myself, in the future!",
	"Man, I miss the good old days when shipments were slower.",
	"Hope you're having a Coporation-riffic day!",
	"I hope it doesn't cost too much, I worked really hard to save up.",
	"Can't believe places like this still exist.",
	"Looking to ship these today.",
	"Nice face, honestly.",
	"Hiya, could you ship this?",
]

var fragile_dialogue = [
	"Careful with this one, its fragile",
	"Lots of delicate stuff in there.",
	"It's fragile, but not that fragile.",
	"This baby could shatter in a strong breeze.",
	"Can you lightly stamp it with a fragile stamp?",
	"This costs a lot, please be careful.",
	"Easy! It could shatter.",
	"You look pretty strong, but in a bad way.",
	"Be nice to this package.",
	"Take care little package! Get there safe.",
]

var expedited_dialogue = [
	"Can you ship this out today?",
	"[color=yellow]Expedited[/color] mail, if I can.",
	"I'd like to ship this [color=yellow]expedited[/color].",
	"Need this to move [color=yellow]quick[/color].",
	"Can it get there tomorrow?",
	"Need this expedited, don't care about the cost.",
	"[color=yellow]Expedited[/color] mail.",
	"I should've sent this yesterday, can you expedite it?",
	"Lightspeed travel please.",
	"Gotta go fast!",
]
