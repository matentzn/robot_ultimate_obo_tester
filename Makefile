

OBO_CONFIG=https://obofoundry.org/registry/ontologies.yml

ROBOTLATEST=bin/robot_latest/robot
ROBOTDEV=bin/robot_dev/robot

.PHONY: prepare
prepare:
	echo "Comparing 1.9.4 with Snapshot release"
	mkdir -p bin/robot_latest bin/robot_dev robot_dev/ robot_latest/ ontologies/
	wget $(OBO_CONFIG) -O obo-config.yml
	python scripts/active-ontologies.py > active-ontologies.txt
	wget "https://github.com/ontodev/robot/raw/master/bin/robot" -O $(ROBOTLATEST)
	wget "https://github.com/ontodev/robot/raw/master/bin/robot" -O $(ROBOTDEV)
	chmod +x $(ROBOTLATEST) $(ROBOTDEV)
	wget "https://github.com/ontodev/robot/releases/download/v1.9.4/robot.jar" -O $(ROBOTLATEST).jar
	wget "https://www.dropbox.com/scl/fi/5gtky9vdcmeni8lapz5lz/robot_110-3_snapshot.jar?rlkey=i3jnn2qqt58qnr8gjcwp79eux&dl=0" -O $(ROBOTDEV).jar

ontologies/%.owl:
	wget "http://purl.obolibrary.org/obo/$*.owl" -O $@
.PRECIOUS: ontologies/%.owl

robot_latest/%-metrics.json: ontologies/%.owl
	$(ROBOTLATEST) measure --input $< --format json --metrics essential-reasoner --output $@
.PRECIOUS: robot_latest/%-metrics.json

robot_dev/%-metrics.json: ontologies/%.owl
	$(ROBOTDEV) measure --input $< --format json --metrics essential-reasoner --output $@
.PRECIOUS: robot_dev/%-metrics.json

comparisons/%.tsv: robot_latest/%-metrics.json robot_dev/%-metrics.json
	python scripts/compare-metrics.py $^ $@
.PRECIOUS: comparisons/%.tsv

#ONTS=ro ddpheno cob aism

ONTS := $(shell awk '{printf "%s ", $$0}' active-ontologies.txt)

all: $(foreach ont, $(ONTS), comparisons/$(ont).tsv)
