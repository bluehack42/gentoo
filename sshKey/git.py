import requests
import json
import socket
import os
import gnupg


def getToken(filename):
    gpg =  gnupg.GPG(use_agent=True)
    gpg.verbose = True

    decryptedData = gpg.decrypt_file(open(filename, "rb"))

    if not str(decryptedData):
        print("encrypt first by gpg --decrypt " + filename + " to start the gpg-agent")
        quit()

    return str(decryptedData).strip('\n')


def updateRemoteKeyGithub(repo ='api.github.com'):
    headers = { 'Accept':"application/vnd.github.v3+json", 'authorization':'Bearer ' + getToken(repo + '.asc')}

    getKeys = requests.get('https://' + repo + '/user/keys', headers=headers)

    print(getKeys)

    for id in getKeys.json():
        if id['title'] == str(socket.gethostname()):
            deleteKey = requests.delete('https://' + repo + '/user/keys/' + str(id['id']), headers=headers)

    key = open(os.environ['HOME'] + '/.ssh/id_rsa.pub')
    updateKeyBody = {"title": socket.gethostname(),"key": key.read()}

    key.close()
    uploadKey = requests.post('https://' +repo + '/user/keys', headers=headers, json=updateKeyBody)
    print(uploadKey.text)

def updateRemoteKeyGitLab(repo ='gitlab.com'):
    headers = {"Content-Type":"application/json", 'authorization': 'Bearer ' +  getToken(repo + '.asc')}

    getKeys = requests.get("https://" + repo + "/api/v4/user/keys", headers=headers)

    for id in getKeys.json():
        if id['title'] == str(socket.gethostname()):
            deleteKey = requests.delete('https://' + repo + '//api/v4/user/keys/' + str(id['id']), headers=headers)

    key = open(os.environ['HOME'] + '/.ssh/id_rsa.pub')
    updateKeyBody = {"title": socket.gethostname(),"key": key.read()}
    key.close()

    uploadKey = requests.post('https://' + repo + '/api/v4/user/keys', headers=headers, json=updateKeyBody)
    print(uploadKey.text)

def main():
    updateRemoteKeyGithub()
    updateRemoteKeyGitLab()

if __name__ == "__main__":
    main()
