# Lambda Layer Easy Setup
***
The purpose of this repo is to simplify the process of making lambda layers.

Most tutorials on creating lambda functions or lambda layers from a .zip archive involve a lot of hacking, dealing with binaries compiled on the wrong architecture, 
and messing around with wheel files or virtual environments. 

In this repo, we seek to remove the entire "hacking" process by simply doing the whole archive generation process inside a docker container. 
In that environment, your installation commands become as simple as system installing something on your local machine, not even inside a virtual environment.

The directory structure for this repo looks like:
```
lambda_layer_easy_setup
├── Dockerfile - create a thin docker image on top of the base lambda runtime
├── Makefile - abstract away the shell commands for running docker commands and zip commands; also provides some helper commands to introspect the contents and size of your archive
├── README.md
└── layer - this is the working area for the generated dependencies and zip archive
    ├── example_unzip - this is a directory for unzipping the dependencies to check they unzip in the correct paths
    ├── python - this is the directory whose directry contains the correct structure expected by lambda 
    ├── python_numpy_layer.zip - this is the zip archive that will be uploaded to create a lambda layer
    └── requirements.txt - this is where you'll enter your requirements
```
# Dependencies
***
The dependencies of this repo are:
* the docker CLI installed on your machine
* access to the internet to pull the AWS Lambda image and to pip install requirements from PyPI
* make
# Usage
***
First, you need to build the custom docker image:
```bash
make image
```

This uses the `image` target inside the `Makefile` to run a `docker build` command. 
The default name of the docker image is `create-lambda-layer`, which is configurable by going into the `Makefile` and changing the value for the
`DOCKER_IMAGE_NAME` variable.

To check that the image was successfully created, you can run:
```bash
make check_image
```

Currently, the ECR URI for the Python 3.9 lambda function is hard coded as the `AWS_LAMBDA_IMAGE_NAME` variable in the Makefile.
If you want to specify a new ECR URI, you just change this variable in the `Makefile`.

Then, you need to populate a requirements.txt in the `layer` directory with your requirements. 


Finally, you run:
```bash
make layer
```

This will generate a file by the name specified in the `ZIP_FILE_NAME` variable in the `Makefile`.
This is the zip file you'll upload to the layer. 

There is a maximum size on the **unzipped** size of your layer code - it cannot be more than 250MB.
If you need something bigger, then it's possible to create your own docker image, and have an unzipped size of up to 10 GB.
But in this case, you'll need an image repository, and you'll need to deploy the entire image to the Lambda. 

This repo can probably be worked with to start off the creation of an entire custom Lambda image. 
