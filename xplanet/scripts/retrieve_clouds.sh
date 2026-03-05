#!/bin/sh
cd $HOME/.xplanet/images/earth 
curl http://global-earth.live:8000/files/clouds/clouds_8192.png -o clouds.png && cp clouds.png clouds_8192.png
