import os
import sys
from dotenv import load_dotenv

load_dotenv()

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

dbProcessesLogPath = os.path.join(BASE_DIR,"logs","dbProcesses.log")
authLogPath = os.path.join(BASE_DIR,"logs","auth.log")
kernelLogPath = os.path.join(BASE_DIR,"logs","kernel.log")

dbName = "kerneldb"
userName = os.getenv("DB_USER","")
password = os.getenv("DB_PASSWORD","")
APP_KEY = os.getenv("APP_KEY","")

CERTIFICATE = os.path.join(BASE_DIR,"cert.pem")
KEY = os.path.join(BASE_DIR,"cert.key")

if dbName == "" or userName == "" or password == "" or APP_KEY == "":
    print("a")
    sys.exit(1)

classes = {}