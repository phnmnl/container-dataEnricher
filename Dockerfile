################################
# DockerFile to build  the PhenoMeNal.enricment app block
# Based on Java:8
###############################

# Set the base image of this container
FROM java:8

# File Author / Maintainer 
MAINTAINER PhenoMeNal-H2020 Project ( phenomenal-h2020-users@googlegroups.com )

# Image Metadata
LABEL Description="PhenoMeNal Enrichment: open source software to cross reference metabolite data with well known database identifiers."
LABEL software.version="0.5.1"
LABEL version="1.1"
LABEL software="MetaboliteIDConverter"

ENV TAG_NUMBER 0.5

# Update the repository sources list
RUN apt-get update && apt-get install -y --no-install-recommends ant && \
	apt-get -y clean && apt-get -y autoremove && rm -rf /var/lib/{cache,log}/ /tmp/* /var/tmp/*  && \
	git clone --depth 1 --single-branch --branch $TAG_NUMBER https://github.com/bmerlet90/MetaboliteIDConverter.git Javafiles && \
	cd Javafiles && \
	git checkout $TAG_NUMBER && \
	ant jar && \
	cp dist/phnmnl-enrichment/phnmnl-enrichment.jar / && \
	cd / && rm -rf Javafiles

################
# Test Scripts
################

ADD runTest1.sh /usr/local/bin/runTest1.sh
RUN chmod +x /usr/local/bin/runTest1.sh


###############
# Define EntryPoint
################
ENTRYPOINT ["java", "-jar", "phnmnl-enrichment.jar"]
