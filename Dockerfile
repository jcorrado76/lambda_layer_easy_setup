# this allows the user to pass in the full URI to the base image
ARG lambda_image_name

FROM $lambda_image_name

ARG path_to_site_packages
# need to do this because you can only use an ENV in an ENTRYPOINT, not an ARG
ENV local_path_to_site_packages=$path_to_site_packages
ARG layer_location

WORKDIR /$layer_location

# requirements is in CWD because we've mounted the layer directory into the container
# local_path_to_site_packages is relative to the layer directory
ENTRYPOINT pip install \
        --target=$local_path_to_site_packages \
        -r requirements.txt