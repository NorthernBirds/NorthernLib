import config

def first():
    print(f"NorthernLib Management Console | Build [20260828.1950]\nCopyright © 2026 Yusuf Enes Kuş. All rigths reserved.\n")

def second():
    while True:

        userName = ""
        password = ""

        command = input("northernlib-management-console> ")
        parsedCommand = command.strip().replace("  "," ").split(" ")

        try:

            if len(parsedCommand) == 5:

                if parsedCommand[0].strip() == "signin":

                    for i,j in zip([1,3],[2,4]):

                        if parsedCommand[i].strip() == "/un":
                            userName = parsedCommand[j].strip()
                        elif parsedCommand[i].strip() == "/pswd":
                            password = parsedCommand[j].strip()
                        else:
                            print("Hatalı parametre!")
                            break

                else:
                    print("Komut bulunamadı!")
                    continue

            else:
                print("Eksik ya da fazla parametre!")
                continue

            if userName != "" and password != "":
                pass

        except IndexError:
            print("Parametre sayısı hatalı!")

def third(userName:str):

    while True:

        command = input(f"{userName}@northernlib-management-console> ")
        parsedCommand = command.strip().replace("  "," ").split(" ")

        if len(parsedCommand) == 4:

            if parsedCommand[0].strip() == "library":

                if parsedCommand[1].strip() == "-list":
                    config.requester.listLibs()

                elif parsedCommand[1].strip() == "-terminate":

                    if parsedCommand[2].strip() == "/lid":
                        try:
                            config.requester.terminateLib(lid=int(parsedCommand[3].strip()))
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
                            config.requester.activateLicense(lcid=int(parsedCommand[3].strip()))
                        except ValueError:
                            print("Lisans ID sayı olmalıdır!")
                            continue

                    else:
                        print("Hatalı parametre!")
                        continue

                elif parsedCommand[1].strip() == "-disable":
                    if parsedCommand[2].strip() == "/lcid":
                        try:
                            config.requester.disableLicense(lcid=int(parsedCommand[3].strip()))
                        except ValueError:
                            print("Lisans ID sayı olmalıdır!")
                            continue

                    else:
                        print("Hatalı parametre!")
                        continue

                elif parsedCommand[1].strip() == "-list":
                    config.requester.listLicenses()
                    
                else:
                    print("Hatalı komut!")
                    continue
first()
second()