ZIP_FILE_NAME=python_numpy_layer.zip
DOCKER_IMAGE_NAME=create-lambda-layer
PYTHON_VERSION=3.9
AWS_LAMBDA_IMAGE_NAME=public.ecr.aws/lambda/python:${PYTHON_VERSION}
# if you want a variable that is the output of a shell command, you need $(shell <command>)
CURRENT_DIRECTORY=$(shell pwd)
LAYER_LOCATION=layer
PATH_TO_SOURCES=${CURRENT_DIRECTORY}/${LAYER_LOCATION}
PATH_TO_PACKAGES=./python/lib/python${PYTHON_VERSION}/site-packages
PATH_TO_ZIP_FILE=${CURRENT_DIRECTORY}/${LAYER_LOCATION}/${ZIP_FILE_NAME}
UNZIP_LOCATION=example_unzip

.PHONY: layer zip_size

zip_size:
	echo `ls -alh ${PATH_TO_ZIP_FILE}`

zip_contents:
	unzip -l ${PATH_TO_ZIP_FILE}

archive:
	cd ${LAYER_LOCATION} && zip -r9 ${ZIP_FILE_NAME} ./python -x "*/__pycache__/*" -x "*/tests/*"

unzip:
	cd ${LAYER_LOCATION} && rm -rf ${UNZIP_LOCATION}  && mkdir ${UNZIP_LOCATION} && unzip ${ZIP_FILE_NAME} -d ${UNZIP_LOCATION}

clean:
	cd ${LAYER_LOCATION} && rm -r ${PATH_TO_PACKAGES}/* && rm ${PATH_TO_SOURCES}/${ZIP_FILE_NAME} && rm -r example_unzip/*

image:
	docker build -t ${DOCKER_IMAGE_NAME} \
		--build-arg lambda_image_name=${AWS_LAMBDA_IMAGE_NAME} \
		--build-arg path_to_site_packages=${PATH_TO_PACKAGES} \
		--build-arg layer_location=${LAYER_LOCATION} \
		.
check_image:
	docker images | grep ${DOCKER_IMAGE_NAME}

run:
	rm -rf ${LAYER_LOCATION}/python && \
		mkdir -p ${LAYER_LOCATION}/${PATH_TO_PACKAGES} && \
		docker run -v ${PATH_TO_SOURCES}:/${LAYER_LOCATION} --rm ${DOCKER_IMAGE_NAME}

layer:
	make run && make archive
