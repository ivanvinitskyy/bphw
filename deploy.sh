#!/usr/bin/env bash

log() {
  echo "================================================================================"
  echo $@ | sed  -e :a -e 's/^.\{1,77\}$/ & /;ta'
  echo "================================================================================"
}

usage(){
  echo "Usage: $0 <>"
  echo
  echo "Script should be run with 1 parameter, action."
  echo
  echo "./deploy.sh action"
  echo
  echo "Examples:"
  echo "./deploy.sh test"
  echo "./deploy.sh deps"
  echo
  echo "Available Actions:"
  echo "deploy   Deploys Vagrant machine, builds docker BP image and runs it"
  echo "deps     Checks for dependencies necessary to run deploy / test"
  echo "test     Tests that deployment was sucessfull"
  echo "cleanup  Removes vagrant box"
  1>&2
  exit 1
}

test(){
  echo "Testing Deployment"
  wget http://192.168.10.10:8080 -q --server-response 2>&1 -O- | awk 'NR==1{print $2}' | grep -q 200 && echo "Deployment Passed" || echo "Deployment failed"
}

check(){
  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Running Checks"
    x=$(ansible --version 2>&1) || { echo "ansible check failed ('pip install ansible' perhaps?)"; exit 1; }
    x=$(vagrant version -h 2>&1) || { echo "vagrant check failed ('brew cask install vagrant' perhaps?)"; exit 1; }
    x=$(vboxmanage --version 2>&1) || { echo "virtualbox check failed ('brew cask install virtualbox' perhaps?)"; exit 1; }
    x=$(type -a wget 2>&1) || { echo "wet check failed ('brew install wget' perhaps?)"; exit 1; }
    echo "App Appears OK"
  else echo "Deps are OSX only, you may have to check dpendencies manual if running on Linux"
  fi
}

deploy(){
 echo "Deploying App"
 cd vagrant && vagrant up --provision
}

cleanup(){
  echo "Destroying App"
  cd vagrant && vagrant destroy -f
}

if [ "$#" -lt 1 ]; then
  log "ERROR: You need to provide an action!"
  usage
fi

ACTION=$1

parse_args(){
  arr=("$@")
  for option in $arr
  do
    case $option in
      deploy)
        deploy
        ;;
      test)
	test
        ;;
      deps)
        check
        ;;
      cleanup)
        cleanup
        ;;
      *)
	usage
    esac
  done
}

parse_args $ACTION
