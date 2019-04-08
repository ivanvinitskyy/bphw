# bphw Repo

## What it does
* Sets up Vagrant machine with Docker container serving content (vagrant/app-code.conf.j2) through Nginx
* Able to detect source code changes and redeploy container
* Tests for dependencies
* Tests for success or failures of a deployment

## Setting up
You will need to install these yourself:
Ansible
Vagrant
VirtualBox
Wget (optional for testing after releases)


## How to run
There is a Bash script located in the root of this repository that helps with provisioning the app and checking that all dependencies are met.
To check for dependencies (OSX only) run:
```BASH
./deploy.sh deps 
```

To deploy run:
```BASH
./deploy.sh deploy
```

To test run:
```BASH
./deploy.sh test 
```

To cleanup run:
```BASH
./deploy.sh cleanup 
```

## Other Considerations
* It was decided to run Ansible outside of Vagrant as it gives greater flexibility for the future to provision code outside of the VM.
* Helper script designed and tested in OSX with Bash 5.x, may not work correctly elsewhere.
* Testing for HTTP 200 OK seems sufficient for this use case, build and provisioning failures are expected to be picked up by a human or CI
