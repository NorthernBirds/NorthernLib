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
                return request.json()
            
            return {"success":False,"message":str(request.status_code)}

        except Exception as e:

            return {"success":False,"message":"Bir hata oluştu!"}

    def listLibs(self):

        try:

            request = requests.post(f"{self.baseUrl}/listLibs",json={"appToken":self.appToken,"userToken":config.session["token"]})

            if request.status_code == 200:
                return request.json()
            
            return {"success":False,"message":str(request.status_code)}

        except Exception as e:

            return {"success":False,"message":"Bir hata oluştu!"}

    def deleteLib(self,lid:int):

        try:

            request = requests.post(f"{self.baseUrl}/terminateLib",json={"lid":lid,"appToken":self.appToken,"userToken":config.session["token"]})

            if request.status_code == 200:
                return request.json()
            
            return {"success":False,"message":str(request.status_code)}

        except Exception as e:

            return {"success":False,"message":"Bir hata oluştu!"}

    def addLicense(self,count:int):

        try:

            request = requests.post(f"{self.baseUrl}/addLicense",json={"userName":count,"appToken":self.appToken,"userToken":config.session["token"]})

            if request.status_code == 200:
                return request.json()

            return {"success":False,"message":str(request.status_code)}

        except Exception as e:

            return {"success":False,"message":"Bir hata oluştu!"}

    def activateLicense(self,lcid:int):

        try:

            request = requests.post(f"{self.baseUrl}/activateLicense",json={"lcid":lcid,"appToken":self.appToken,"userToken":config.session["token"]})

            if request.status_code == 200:
                return request.json()
            
            return {"success":False,"message":str(request.status_code)}
            _
        except Exception as e:

            return {"success":False,"message":"Bir hata oluştu!"}

    def disableLicense(self,lcid:int):

        try:

            request = requests.post(f"{self.baseUrl}/disableLicense",json={"lcid":lcid,"appToken":self.appToken,"userToken":config.session["token"]})

            if request.status_code == 200:
                return request.json()
            
            return {"success":False,"message":str(request.status_code)}
            _
        except Exception as e:

            return {"success":False,"message":"Bir hata oluştu!"}

    def listLicenses(self):

        try:

            request = requests.post(f"{self.baseUrl}/listLicenses",json={"appToken":self.appToken,"userToken":config.session["token"]})

            if request.status_code == 200:
                return request.json()
            
            return {"success":False,"message":str(request.status_code)}

        except Exception as e:

            return {"success":False,"message":"Bir hata oluştu!"}

    def signOut(self):

        try:

            request = requests.post(f"{self.baseUrl}/signOut",json={"appToken":self.appToken,"userToken":config.session["token"]})

            if request.status_code == 200:
                return request.json()
            
            return {"success":False,"message":str(request.status_code)}

        except Exception as e:

            return {"success":False,"message":"Bir hata oluştu!"}
