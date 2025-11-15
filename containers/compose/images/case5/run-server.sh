docker rm -f webserver_multi
docker run -dit \
	--name webserver_multi \
	-p 8888:80 \
	mywebserver:multi


