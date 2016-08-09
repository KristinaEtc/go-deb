# go-deb
A stuff for creating dep-packages for go-programms.
It was used to my projects, such as [go-nominatim](https://github.com/KristinaEtc/go-nominatim) or [stomp](https://github.com/KristinaEtc/stomp)

##Usage
1. Clone the project to a directory where go-project is situated
2. In `make-dev.sh` set all your needed values
3. Don't forget to change upstart config according to your needs: change filename of a config (the same as the name of a executable file); user, which will run the demon; name of a demon; "about" tag)
4. Run `make-dev.sh`<br/ >
...<br/ >
Profit!
