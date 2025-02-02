#!/bin/bash
ORIGIN_PWD="$PWD"
while true
do
	sudo docker rm -f palworld-server
	mkdir -p palworld
	sudo chown -R $USER:$USER palworld
	if ( ls "${ORIGIN_PWD}/palworld/Pal/Saved/SaveGames" );then
		cd "${ORIGIN_PWD}/palworld/Pal/Saved/SaveGames/"
		MAP_PATHS="$(find . -mindepth 2 -maxdepth 2)"
		while IFS= read -r MAP_PATH
		do
			echo ${MAP_PATH}
			cd "${ORIGIN_PWD}/palworld/Pal/Saved/SaveGames/${MAP_PATH}"
			git add -A
			git commit -m "$(date +%s) ${MAP_PATH}"
			git push
		done < <(printf '%s\n' "${MAP_PATHS}")
		cd "${ORIGIN_PWD}"
		rm -rf "${ORIGIN_PWD}/palworld/Pal/Binaries"
	fi
	cd "${ORIGIN_PWD}/palworld/Pal/Saved/Config/LinuxServer/"
	git add -A
	git commit -m "$(date +%s)"
	git push
	sudo chown 1000:1000 -R "${ORIGIN_PWD}/palworld"
	sudo docker-compose up -d
	sleep 3600
done
