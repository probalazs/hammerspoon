run=/bin/bash -l -c

init:
	$(run) 'curl -sSiL https://github.com/Hammerspoon/Spoons/raw/master/Spoons/SpoonInstall.spoon.zip -o Spoons/SpoonInstall.spoon.zip'
	$(run) 'zip -FF ./Spoons/SpoonInstall.spoon.zip --out ./Spoons/fixed.zip'
	$(run) 'unzip ./Spoons/fixed.zip -d ./Spoons'
	$(run) 'rm -f ./Spoons/*.zip'

clear:
	$(run) 'rm -rf ./Spoons/*'
