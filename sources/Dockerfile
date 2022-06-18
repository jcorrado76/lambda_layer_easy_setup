ARG python_version
ARG path_to_site_packages
FROM public.ecr.aws/lambda/python:$python_version
ENV local_path_to_site_packages=$path_to_site_packages

WORKDIR /sources

ENTRYPOINT pip install \
        --target=./python/lib/python3.9/site-packages \
        -r requirements.txt
