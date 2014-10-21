#!/usr/bin/env bash
function die() {
  echo $*
  exit 1
}

mvn --version || die "Please install maven from http://maven.apache.org" 


if [ $(uname) == "Darwin" ]
then
  ls -la configureNetworkServices | grep rwsr | grep wheel || ./setNetUidOsx.bash
  ptdir=osx
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]
then
  if [ $(uname -m) == 'x86_64' ]; then
    ptdir=linux_x86_64
  else
    ptdir=linux_x86_32
  fi
elif [ -n "$COMSPEC" -a -x "$COMSPEC" ]
then
  ptdir=win	
fi

test -d src/main/pt/pt || cp -R install/$ptdir/pt src/main/pt/ ||
		die "Could not copy pluggable transports?"

rm -f target/lantern*-small.jar || die "Could not remove old jar?"
mvn -U package -Dmaven.artifact.threads=1 -Dmaven.test.skip=true || die "Could not package"
