PRC_PATH = C:\processing-4.2\processing-java.exe
DIR_PATH = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

all: main

main:
	$(PRC_PATH) --force --sketch=$(DIR_PATH) --run