import config
import sys

def first():
    print(f"NorthernLib Management Console | Build [20260828.1950]\nCopyright © 2026 Yusuf Enes Kuş\n")

def second():
    while True:

        userName = ""
        password = ""

        command = input("northernlib-management-console> ")
        parsedCommand = command.strip().replace("  "," ").split(" ")

        try:

                if parsedCommand[0].strip() == "signin":

                    for i,j in zip([1,3],[2,4]):

                        if parsedCommand[i].strip() == "/un":
                            userName = parsedCommand[j].strip()
                        elif parsedCommand[i].strip() == "/pswd":
                            password = parsedCommand[j].strip()
                        else:
                            print("Hatalı parametre!")
                            break
                
                elif parsedCommand[0].strip() == "exit":
                    sys.exit(1)

                else:
                    print("Komut bulunamadı!")
                    continue


                if userName != "" and password != "":

                    result = config.requester.signIn(userName=userName,password=password)
                    print(result)

                    if result["success"]:
                        break

    

        except Exception as e:
            print(f"Bir hata oluştu: {e}")

    third(userName=userName)

def third(userName:str):

    while True:

        command = input(f"{userName}@northernlib-management-console> ")
        parsedCommand = command.strip().replace("  "," ").split(" ")

        try:

            if parsedCommand != []:


                if parsedCommand[0].strip() == "library":

                    if parsedCommand[1].strip() == "-list":
                        print(f"{config.requester.listLibs()}\n")

                    elif parsedCommand[1].strip() == "-terminate":

                        if parsedCommand[2].strip() == "/lid":
                            try:
                                print(f"{config.requester.terminateLib(lid=int(parsedCommand[3].strip()))}\n")
                            except ValueError:
                                print("Kütüphane ID sayı olmalıdır!")
                                continue

                        else:
                            print("Hatalı parametre!")
                            continue

                    else:
                        print("Hatalı komut!")
                        continue

                elif parsedCommand[0].strip() == "license":

                    if parsedCommand[1].strip() == "-activate":
                        if parsedCommand[2].strip() == "/lcid":
                            try:
                                print(f"{config.requester.activateLicense(lcid=int(parsedCommand[3].strip()))}\n")
                            except ValueError:
                                print("Lisans ID sayı olmalıdır!")
                                continue

                        else:
                            print("Hatalı parametre!")
                            continue

                    elif parsedCommand[1].strip() == "-disable":
                        if parsedCommand[2].strip() == "/lcid":
                            try:
                                print(f"{config.requester.disableLicense(lcid=int(parsedCommand[3].strip()))}\n")
                            except ValueError:
                                print("Lisans ID sayı olmalıdır!")
                                continue

                        else:
                            print("Hatalı parametre!")
                            continue

                    elif parsedCommand[1].strip() == "-list":
                        print(config.requester.listLicenses())

                    elif parsedCommand[1].strip() == "-add":
                        if parsedCommand[2].strip() == "/count":
                            try:
                                print(f"{config.requester.addLicense(count=int(parsedCommand[3].strip()))}\n")
                            except ValueError:
                                print("Sayı değeri sayı olmalıdır!")
                                continue

                        else:
                            print("Hatalı parametre!")
                            continue

                    else:
                        print("Hatalı komut!")
                        continue

                elif parsedCommand[0].strip() == "signout":
                    result = config.requester.signOut()
                    print(f"{result}\n")
                    if result["success"]:
                        break

                elif parsedCommand[0].strip() == "process":
                    if parsedCommand[1].strip() == "-list":
                        print(f"{config.requester.listProcesses()}\n")

                    elif parsedCommand[1].strip() == "-kill":
                        if parsedCommand[2].strip() == "/pid":
                            try:
                                print(f"{config.requester.killProcess(pid=parsedCommand[3])}")
                            except ValueError:
                                print("Sayı değeri sayı olmalıdır!")
                                continue

                        else:
                            print("Hatalı parametre!")
                            continue

                    else:
                        print("Hatalı komut!")
                        continue

                else:
                    print("Hatalı kök komut!")
                    continue
            else:
                print("Lütfen boş bırakmayın!")

        except Exception as e:
            print(f"Bir hata oluştu: {e}")

    second()