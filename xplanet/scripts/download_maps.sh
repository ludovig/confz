whence convert >> /dev/null || "Please install imagemagick" 
mkdir -p $HOME/.xplanet/images/earth
cd $HOME/.xplanet/images/earth
wget http://eoimages.gsfc.nasa.gov/images/imagerecords/57000/57730/land_ocean_ice_2048.png -O earth.png
wget http://eoimages.gsfc.nasa.gov/images/imagerecords/79000/79765/dnb_land_ocean_ice.2012.3600x1800.jpg 
wget http://eoimages.gsfc.nasa.gov/images/imagerecords/73000/73934/gebco_08_rev_elev_21600x10800.png 
convert dnb_land_ocean_ice.2012.3600x1800.jpg -resize 2048x1024 night.jpg
convert gebco_08_rev_elev_21600x10800.png -resize 2048x1024 topo.png
wget http://solarviews.com/raw/moon/moonmap.jpg -O moon.jpg
cd $HOME/.xplanet/images/
wget http://www.mmedia.is/~bjj/data/io/io.jpg
wget http://www.mmedia.is/~bjj/data/ganymede/ganymede.jpg
wget http://www.mmedia.is/~bjj/data/callisto/callisto.jpg
wget http://www.mmedia.is/~bjj/data/europa/europa.jpg
wget http://www.mmedia.is/~bjj/data/neptune/neptune.jpg
wget http://www.mmedia.is/~bjj/data/saturn/saturn.jpg
wget http://www.mmedia.is/~bjj/data/jupiter_css/jupiter_css.jpg -O jupiter.jpg
wget http://solarviews.com/raw/mars/marscyl1.jpg -O mars.jpg
