default:

import-gpg-key:
	gpg -k
	gpg --import ./pubkey/patrik.marxer_sourcecode.li.key.pub
	gpg --card-status

new-ssh-keys:
	ssh-keygen
	pip install --user -r ./git/sshKeys/requirements.txt
	cd git ./git/sshKeys && python newSSHKeyGit.py

cloneGit:
	pip install --user -r ./git/cloneGit/requirements.txt
	cd git/cloneGit && python cloneGitRepo.py
