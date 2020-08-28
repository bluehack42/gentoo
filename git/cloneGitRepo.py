import requests
import json
import socket
import os
import gnupg
from git import Repo

def getToken(filename):
    gpg =  gnupg.GPG(use_agent=True)
    # gpg.verbose = True

    decryptedData = gpg.decrypt_file(open(filename, "rb"))

    return str(decryptedData).strip('\n')


def getCloneReposFromGithub(repo ='api.github.com'):
    headers = { 'Accept':"application/vnd.github.v3+json", 'authorization':'Bearer ' + getToken(repo + '.asc')}

    getReops = requests.get('https://' + repo + '/user/repos?type=owner', headers=headers)

    for repo in getReops.json():
            if repo['name'] not in ['dotfiles']:
                if os.path.isdir(os.environ['HOME'] + '/' + repo['name']):
                    currentRepo = Repo(os.environ['HOME'] + '/' + repo['name'])
                    if currentRepo.remotes['origin'].url != repo['ssh_url']:
                        currentRepo.delete_remote('origin')
                        currentRepo.create_remote('origin', url=repo['ssh_url'], )
                        currentRepo.git.push('--set-upstream', 'origin', 'master')

            elif repo['name'] == 'dotfiles':
                currentRepo = Repo(os.environ['HOME'] + '/.local/share/chezmoi')
                if currentRepo.remotes['origin'].url != repo['ssh_url']:
                    currentRepo.delete_remote('origin')
                    currentRepo.create_remote('origin', url=repo['ssh_url'], )
                    currentRepo.git.push('--set-upstream', 'origin', 'master')

            else:
                if not os.path.isdir(os.environ['HOME'] + '/' + repo['name']):
                        Repo.clone_from(repo['ssh_url'], os.environ['HOME'] + '/' + repo['name'])

def getCloneReposFromGitLab(repo ='gitlab.com'):
    headers = {"Content-Type":"application/json", 'authorization': 'Bearer ' +  getToken(repo + '.asc')}

    getRepos = requests.get("https://" + repo + "/api/v4/projects?visibility=private", headers=headers)

    for repo in getRepos.json():
        if not os.path.isdir(os.environ['HOME'] + '/' + repo['name']):
            if repo['name'] not in ['keys']:
                Repo.clone_from(repo['ssh_url_to_repo'], os.environ['HOME'] + '/' + repo['name'])
            else:
                Repo.clone_from(repo['ssh_url_to_repo'], os.environ['HOME'] + '/.password-store')

def main():
    getCloneReposFromGithub()
    getCloneReposFromGitLab()

if __name__ == "__main__":
    main()
