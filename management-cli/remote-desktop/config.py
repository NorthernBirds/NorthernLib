import os
import sys
from dotenv import load_dotenv

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

load_dotenv()

requester = ""

session = {"token":""}

appToken = os.getenv("APP_TOKEN","")
baseUrl = os.getenv("BASE_URL","")

if appToken == "" or baseUrl == "":
    sys.exit(1)
