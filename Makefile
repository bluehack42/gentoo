default:

# You have to give the long keyID here which can be obtained by using
# the --list-key command along with the option --with-colons; you will
# get a line similiar to this one:
#    pub:u:1024:17:5DE249965B0358A2:1999-03-15:2006-02-04:59:f:
# the 5th field is what you want.
import-gpg-key:
	gpg -k
	gpg --import ./pubkey/patrik.marxer_sourcecode.li.key.pub
	gpg --card-status

new-ssh-keys:
	ssh-keygen
	pip install --user -r ./git/sshKeys/requirements.txt
	cd ./git/sshKeys && python newSSHKeyGit.py

cloneGit:
	pip install --user -r ./git/cloneGit/requirements.txt
	cd git/cloneGit && python cloneGitRepo.py
