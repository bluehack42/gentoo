import requests
import json
import socket
import os
import gnupg

urlGitHubKeys = 'https://api.github.com/user/keys'
key = open(os.environ['HOME'] + '/.ssh/id_rsa.pub')

def getToken(repo):
    gpg = gnupg.GPG()

    decryptedData = gpg.decrypt_file(open(repo, "rb"))
    return str(decryptedData).strip('\n')


def updateRemoteKey(repo):
     headers = {"Accept":"application/vnd.github.v3+json", "authorization" : "Bearer "  + getToken(repo + '.asc')}

     getKeys = requests.get(urlGitHubKeys, headers=headers)

     for id in getKeys.json():
         if id['title'] == socket.gethostname():
             deleteKey = requests.delete(urlGitHubKeys + '/' + str(id['id']), headers=headers)

     updateKeyBody = {"title": socket.gethostname(),"key": key.read()}

     uploadKey = requests.post(urlGitHubKeys, headers=headers, json=updateKeyBody)
     print(uploadKey.text)

def main():
   updateRemoteKey("github")


if __name__ == "__main__":
    main()
