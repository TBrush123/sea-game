extends Node

const KEY_FILE_MAP: Dictionary = {
    "Space": "space_md",
    "Enter": "enter",
    "Escape": "escape",
    "Shift": "shift",
    "Ctrl": "ctrl",
    "Alt": "alt",
    "Tab": "tab",
    "Backspace": "backspace",
    "Delete": "delete",
    "Arrow Up": "arrow-up",
    "Arrow Down": "arrow-down",
    "Arrow Left": "arrow-left",
    "Arrow Right": "arrow-right",
    "A": "a", "B": "b", "C": "c", "D": "d", "E": "e",
    "F": "f", "G": "g", "H": "h", "I": "i", "J": "j",
    "K": "k", "L": "l", "M": "m", "N": "n", "O": "o",
    "P": "p", "Q": "q", "R": "r", "S": "s", "T": "t",
    "U": "u", "V": "v", "W": "w", "X": "x", "Y": "y",
    "Z": "z",
    "0": "0", "1": "1", "2": "2", "3": "3", "4": "4",
    "5": "5", "6": "6", "7": "7", "8": "8", "9": "9",
    "F1": "f1", "F2": "f2", "F3": "f3", "F4": "f4",
    "F5": "f5", "F6": "f6", "F7": "f7", "F8": "f8",
    "F9": "f9", "F10": "f10", "F11": "f11", "F12": "f12", 
}

const MOUSE_FILE_MAP: Dictionary = {
    MOUSE_BUTTON_LEFT: "LeftClick-Blue",
    MOUSE_BUTTON_MIDDLE: "MiddleClick-Blue",
    MOUSE_BUTTON_RIGHT: "RightClick-Blue",
    MOUSE_BUTTON_WHEEL_DOWN: "ScrollDown-Blue",
    MOUSE_BUTTON_WHEEL_UP: "ScrollUp-Blue"
}

const KEY_BASE_PATH = "res://assets/menu/key/PNG/%s.png"
const MOUSE_BASE_PATH = "res://assets/menu/mouse/PNG/%s.png/"

func get_action_texture(action: String) -> Texture2D:
    var events = InputMap.action_get_events(action)
    for event in events:
        if event is InputEventKey:
            var key_text = OS.get_keycode_string(event.physical_keycode)
            if KEY_FILE_MAP.has(key_text):
                var path = KEY_BASE_PATH % KEY_FILE_MAP[key_text]
                print(path)
                if ResourceLoader.exists(path):
                    return load(path)
        elif event is InputEventMouseButton:
            if MOUSE_FILE_MAP.has(event.button_index):
                var path = MOUSE_BASE_PATH % MOUSE_FILE_MAP[event.button_index]
                if ResourceLoader.exists(path): 
                    return load(path)
    return null

func get_key_label_text(action: String) -> String:
    var events = InputMap.action_get_events(action)
    for event in events:
        if event is InputEventKey:
            return event.as_text_key_label()
    return action
