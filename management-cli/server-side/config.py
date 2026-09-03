import os
import sys
from dotenv import load_dotenv
from dbProcesses import Process

load_dotenv()

dbProcessesLogPath = os.path.join("logs","dbProcesses.log")
authLogPath = os.path.join("logs","auth.log")
kernelLogPath = os.path.join("logs","kernel.log")

dbName = os.getenv("DB_NAME","")
userName = os.getenv("DB_USER","")
password = os.getenv("PASSWORD","")
APP_KEY = os.getenv("APP_KEY","")

if dbName == "" or userName == "" or password == "" or APP_KEY == "":
    sys.exit(1)

classes = {}