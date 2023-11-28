extends RichTextLabel

const WAIT_TIME = 3.5

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
	await get_tree().create_timer(WAIT_TIME).timeout
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
	"Hello, I'm hoping to ship some records.",
	"Thank goodness you're open, I just remembered my kid's birthday.",
	"Hope you're havin a nice day!",
	"It's cookies for my grandma, I swear!",
	"Can you hurry up? I've been waiting here all day.",
	"I hope I did this right.",
	"You can ship food right?",
	"Just a normal shipment, of course.",
	"Hi there!",
	"Sure hope that box holds.",
	"You look new, are you new?",
	"Hey man, looking for help.",
	"Just ship the damn box.",
]

var magic_dialogue = [
	"Good morning good sir or madam.",
	"Good day, I request your services.",
	"I need these ingredients shipped, post haste!",
	"Is this the famous Multi-universal Mail Service?",
	"I'd love to learn more about how this establishment works!",
	"I need these scrolls sent to my colleagues.",
	"I'd teleport this myself, but I don't know how yet.",
	"I'm shipping some cloaks to kids in need.",
	"I'm surprised I could fit all my tomes in there.",
	"[wave]Ala Ka Zam, Ala Ka Zee[/wave], can you ship this for me?",
	"It's very important this be shipped, or else...",
	"You ever think about how many objects you can fit in a wizard hat?",
	"I would like your services and no further questions.",
	"Postal Servant, I request your finest handling for I am going into battle.",
	"Hehehe, I need something sent.",
	"Do not mess up this shipment.",
	"Yes yes, just a standard shipment.",
	"Please be careful not to scratch the runes!",
	"No need to investigate, I am an upstanding citizen.",
	"Hello, I want you to ship this.",
]

var cyber_dialogue = [
	"Sick place, love what you guys do.",
	"Need this [shake]*beep*[/shake] shipped. Aw [shake]*beep*[/shake] I'm beeping again.",
	"I need something sent to myself, in the future!",
	"Man, I miss the good old days when shipments were slower.",
	"Hope you're having a Coporation-riffic day!",
	"I hope it doesn't cost too much, I worked really hard to save up.",
	"Can't believe places like this still exist.",
	"Looking to ship these today.",
	"Nice face, honestly.",
	"Hiya, could you ship this?",
	"Need this sent to my grandma. No, I'm serious!",
	"[shake]I NEED TO SHIP SOMETHING.[/shake]",
	"I was hoping you would be here today.",
	"Do you have any idea who I am?",
	"Listen scrub, ship this package or else there'll be trouble.",
	"You remind me of someone I used to have in my head.",
	"Hey.",
	"Yeah, I need this shipped to someone very important.",
	"This isn't real! You're in a video game!",
]

var fragile_dialogue = [
	"Careful with this one, it's [color=red]fragile[/color]",
	"Lots of [color=red]delicate[/color] stuff in there.",
	"It's [color=red]fragile[/color], but not that [color=red]fragile[/color].",
	"This baby could [color=red]shatter[/color] in a strong breeze.",
	"Can you lightly stamp it with a [color=red]fragile[/color] sticker?",
	"This costs a lot, please be [color=red]careful[/color].",
	"Easy! It could [color=red]shatter[/color].",
	"You look pretty strong, but in a bad way. Be [color=red]gentle[/color] with it.",
	"[color=red]Go easy[/color] on this package.",
	"Take care little package! Get there [color=red]safe[/color].",
]

var expedited_dialogue = [
	"Can you ship this out [color=yellow]today[/color]?",
	"[color=yellow]Expedited[/color] mail, if I can.",
	"I'd like to ship this [color=yellow]expedited[/color].",
	"Need this to move [color=yellow]quick[/color].",
	"Can it get there [color=yellow]tomorrow[/color]?",
	"Need this [color=yellow]expedited[/color], don't care about the cost.",
	"[color=yellow]Expedited[/color] mail.",
	"I should've sent this yesterday, can you [color=yellow]expedite[/color] it?",
	"[color=yellow]Lightspeed[/color] travel please.",
	"Gotta go [color=yellow]fast[/color]!",
]
