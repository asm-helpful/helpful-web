if [ ! -f /usr/local/share/phantomjs/bin/phantomjs ]
then
  echo "********************************************************************************"
  echo BEGIN PHANTOMJS
  PHANTOMJS_VERSION="1.9.7"

  apt-get -y install libicu48 libfreetype6 fontconfig
  wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2
  cp -f phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 /usr/local/share
  cd /usr/local/share
  tar xvf phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2
  rm -f /usr/local/share/phantomjs
  ln -Fs /usr/local/share/phantomjs-$PHANTOMJS_VERSION-linux-x86_64 /usr/local/share/phantomjs
  rm -f /usr/local/bin/phantomjs
  ln -Fs /usr/local/share/phantomjs/bin/phantomjs /usr/local/bin/phantomjs
  phantomjs --version
  cd
  echo END PHANTOMJS
  echo "********************************************************************************"
else
  echo 'PhantomJS is already present'
fi

phantomjs -v
