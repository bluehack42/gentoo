import requests
import json
import socket
import os
import gnupg

urlGit = {'github':'https://api.github.com/user/keys','gitlab':'https://api.gitlab.com/user/keys'}
key = open(os.environ['HOME'] + '/.ssh/id_rsa.pub')
acceptHeader = {"github":"application/vnd.github.v3+json","gitlab":"application/json"}

def getToken(filename):
    gpg = gnupg.GPG()

    decryptedData = gpg.decrypt_file(open(filename, "rb"))
    return str(decryptedData).strip('\n')


def updateRemoteKey(repo):
    headers = {"Accept":acceptHeader[repo] : "Bearer " + getToken(repo + '.asc')}

    getKeys = requests.get(urlGit[repo], headers=headers)

    for id in getKeys.json():
        if id['title'] == socket.gethostname():
            deleteKey = requests.delete(urlGit[repo] + '/' + str(id['id']), headers=headers)

    updateKeyBody = {"title": socket.gethostname(),"key": key.read()}

    uploadKey = requests.post(urlGitHubKeys, headers=headers, json=updateKeyBody)
    print(uploadKey.text)

def main():
    updateRemoteKey("github")
    updateRemoteKey("gitlab")

if __name__ == "__main__":
    main()
