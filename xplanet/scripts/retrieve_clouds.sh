#!/bin/sh
cd $HOME/.xplanet/images/earth 
curl https://global-earth.live/files/clouds/clouds_8192.png -o clouds.png && cp clouds.png clouds_8192.png
