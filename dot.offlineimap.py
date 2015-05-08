#!/usr/bin/env python
import sys, keyring

def keyring_get_password(service, username):
	return keyring.get_password(service, username)

if __name__ == "__main__":
	print keyring_get_password(*sys.argv[1:])
