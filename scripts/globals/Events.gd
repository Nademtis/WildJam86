extends Node
#global Event bus

signal swap_level(new_level_path : String)
signal restart_level

signal new_level_done_loading
signal fade_to_black
signal screen_is_black
signal fade_to_black_and_restart_current_level


#stealth
signal is_hidden(is_hidden : bool)
