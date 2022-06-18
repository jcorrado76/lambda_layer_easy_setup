ARG lambda_image_name
ARG path_to_site_packages
FROM $lambda_image_name
ENV local_path_to_site_packages=$path_to_site_packages

WORKDIR /sources

ENTRYPOINT pip install \
        --target=./python/lib/python3.9/site-packages \
        -r requirements.txt
