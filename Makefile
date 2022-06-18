ZIP_FILE_NAME=python_snowflake_connector_layer.zip
DOCKER_IMAGE_NAME=create-lambda-layer
PYTHON_VERSION=3.9
AWS_LAMBDA_IMAGE_NAME=public.ecr.aws/lambda/python:${PYTHON_VERSION}
PATH_TO_SOURCES=${HOME}/lambda_layers/sources
PATH_TO_PACKAGES=./python/lib/python${PYTHON_VERSION}/site-packages

zip_size:
	echo `ls -alh ${ZIP_FILE_NAME}`

zip_contents:
	unzip -l ${ZIP_FILE_NAME}

archive:
	zip -r9 ${ZIP_FILE_NAME} ${PATH_TO_PACKAGES} -x "*/__pycache__/*" -x "*/tests/*" && make zip_size

unzip:
	unzip ${ZIP_FILE_NAME} -d example_unzip

clean:
	rm -r ${PATH_TO_PACKAGES}/* && rm ${ZIP_FILE_NAME} && rm -r example_unzip/*

image:
	docker build -t ${DOCKER_IMAGE_NAME} \
		--build-arg lambda_image_name=${AWS_LAMBDA_IMAGE_NAME} \
		--build-arg path_to_site_packages=${PATH_TO_PACKAGES} \
		.
check_image:
	docker images | grep ${DOCKER_IMAGE_NAME}

run:
	docker run -v ${PATH_TO_SOURCES}:/sources --rm ${DOCKER_IMAGE_NAME}

layer:
	make run && make archive
