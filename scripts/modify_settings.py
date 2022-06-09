# Add this PSQL Configuration to the django project

import os

if __name__ == "__main__":
    settings_file = os.environ.get("SETTINGS_FILE")
    
    if not settings_file:
        raise Exception("ERROR: Settings file missing")
