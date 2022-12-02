run=/bin/bash -l -c

init:
	$(run) 'curl -sSiL https://github.com/Hammerspoon/Spoons/raw/master/Spoons/SpoonInstall.spoon.zip -o Spoons/SpoonInstall.spoon.zip'
	$(run) 'zip -FF ./Spoons/SpoonInstall.spoon.zip --out ./Spoons/fixed.zip'
	$(run) 'unzip ./Spoons/fixed.zip -d ./Spoons'
	$(run) 'rm -f ./Spoons/*.zip'

format:
	$(run) 'lua-format actions/* init.lua cache.lua libs.lua --config=lua-format.cnf -i'

clear:
	$(run) 'rm -rf ./Spoons/*'
