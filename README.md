# cubieboard
Here you can find some files that are used on my cubieboard to make Dallas 1-wire DS18B20 temperature sensors work.

The boot folder contains script.fex files both for CubieTruck and CubieBoard 2 which are based on the files in the images at http://dl.cubieboard.org/model/cubietruck/Image/Cubieez/cubieez-hdmi/. Also there is uEnv.txt and the uImage kernel that work on my systems. 

The kernel folder contains the .config file that I used when compiling my 3.4.79-sun7i kernel based on the description at the linux-sunxi community page at http://linux-sunxi.org/Linux_Kernel and http://docs.cubieboard.org/tutorials/cb1/customization/ds18b20_via_1-wire.

In the system folder I stored some setting that I prefer to use in my systems.

And finally the temperature folder contains the scripts that makes the whole thing work. They are based on David Mills work you can find at https://github.com/g7uvw/rPI-multiDS18x20
