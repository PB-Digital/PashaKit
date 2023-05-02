import json
from Classes.Config import Config

def get_config_raw() -> Config:
    with open('Config.json', 'r') as file:
        config = json.load(file)
    return Config(config['version'], config['release_notes'])
