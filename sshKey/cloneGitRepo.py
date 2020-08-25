import requests
import json
import socket
import os
import gnupg
import git

def getToken(filename):
    gpg =  gnupg.GPG(use_agent=True)
    gpg.verbose = True

    decryptedData = gpg.decrypt_file(open(filename, "rb"))

    if not str(decryptedData):
        print("encrypt first by gpg --decrypt " + filename + " to start the gpg-agent")
        quit()

    return str(decryptedData).strip('\n')


def getCloneReposFromGithub(repo ='api.github.com'):
    headers = { 'Accept':"application/vnd.github.v3+json", 'authorization':'Bearer ' + getToken(repo + '.asc')}

    getReops = requests.get('https://' + repo + '/user/repos?type=owner', headers=headers)

    # print(getReops.json())

    for repo in getReops.json():
        if repo['name'] not in ['dotfiles','gentoo']:
            print(repo['name'])
            print(repo['ssh_url'])
            git.Repo.clone_from(repo['ssh_url'], os.environ['HOME'] + '/' + repo['name'])

    # key = open(os.environ['HOME'] + '/.ssh/id_rsa.pub')
    # updateKeyBody = {"title": socket.gethostname(),"key": key.read()}

    # key.close()
    # uploadKey = requests.post('https://' +repo + '/user/keys', headers=headers, json=updateKeyBody)
    # print(uploadKey.text)

def getCloneReposFromGitLab(repo ='gitlab.com'):
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
    getCloneReposFromGithub()
    # getCloneReposFromGitLab()

if __name__ == "__main__":
    main()
