import config
import requests

class Request:

    def __init__(self):

        self.baseUrl = config.baseUrl
        self.appToken = config.appToken

    def signIn(self,userName:str,password:str):

        try:

            request = requests.post(f"{self.baseUrl}/signIn",json={"userName":userName,"password":password,"appToken":self.appToken})

            if request.status_code == 200:

                info = request.json()

                if info["success"]:
                    config.session["token"] = info["data"]["token"]

                    info = request.json()
                    del info["data"]

                return info
            
                
            return {"success":False,"message":str(request.status_code)}

        except Exception as e:

            return {"success":False,"message":f"Bir hata oluştu: {e}"}

    def listLibs(self):

        try:

            request = requests.post(f"{self.baseUrl}/listLibs",json={"appToken":self.appToken,"userToken":config.session["token"]})

            if request.status_code == 200:
                return request.json()
            
            return {"success":False,"message":str(request.status_code)}

        except Exception as e:

            return {"success":False,"message":f"Bir hata oluştu: {e}"}

    def terminateLib(self,lid:int):

        try:

            request = requests.post(f"{self.baseUrl}/terminateLib",json={"lid":lid,"appToken":self.appToken,"userToken":config.session["token"]})

            if request.status_code == 200:
                return request.json()
            
            return {"success":False,"message":str(request.status_code)}

        except Exception as e:

            return {"success":False,"message":f"Bir hata oluştu: {e}"}

    def addLicense(self,count:int):

        try:

            request = requests.post(f"{self.baseUrl}/addLicense",json={"count":count,"appToken":self.appToken,"userToken":config.session["token"]})

            if request.status_code == 200:
                return request.json()

            return {"success":False,"message":str(request.status_code)}

        except Exception as e:

            return {"success":False,"message":f"Bir hata oluştu: {e}"}

    def activateLicense(self,lcid:int):

        try:

            request = requests.post(f"{self.baseUrl}/activateLicense",json={"lcid":lcid,"appToken":self.appToken,"userToken":config.session["token"]})

            if request.status_code == 200:
                return request.json()
            
            return {"success":False,"message":str(request.status_code)}
            _
        except Exception as e:

            return {"success":False,"message":f"Bir hata oluştu: {e}"}

    def disableLicense(self,lcid:int):

        try:

            request = requests.post(f"{self.baseUrl}/disableLicense",json={"lcid":lcid,"appToken":self.appToken,"userToken":config.session["token"]})

            if request.status_code == 200:
                return request.json()
            
            return {"success":False,"message":str(request.status_code)}
            _
        except Exception as e:

            return {"success":False,"message":f"Bir hata oluştu: {e}"}

    def listLicenses(self):

        try:

            request = requests.post(f"{self.baseUrl}/listLicenses",json={"appToken":self.appToken,"userToken":config.session["token"]})

            if request.status_code == 200:
                return request.json()
            
            return {"success":False,"message":str(request.status_code)}

        except Exception as e:

            return {"success":False,"message":f"Bir hata oluştu: {e}"}

    def listProcesses(self):

        try:

            request = requests.post(f"{self.baseUrl}/listProcesses",json={"appToken":self.appToken,"userToken":config.session["token"]})

            if request.status_code == 200:
                return request.json()
            
            return {"success":False,"message":str(request.status_code)}
            _
        except Exception as e:

            return {"success":False,"message":f"Bir hata oluştu: {e}"}

    def killProcess(self,pid):

        try:

            request = requests.post(f"{self.baseUrl}/killProcess",json={"pid":pid,"appToken":self.appToken,"userToken":config.session["token"]})

            if request.status_code == 200:
                return request.json()
            
            return {"success":False,"message":str(request.status_code)}

        except Exception as e:

            return {"success":False,"message":f"Bir hata oluştu: {e}"}

    def signOut(self):

        try:

            request = requests.post(f"{self.baseUrl}/signOut",json={"appToken":self.appToken,"userToken":config.session["token"]})

            if request.status_code == 200:
                return request.json()
            
            return {"success":False,"message":str(request.status_code)}

        except Exception as e:

            return {"success":False,"message":f"Bir hata oluştu: {e}"}
