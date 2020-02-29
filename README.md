# scVI-container
This repository contains files for creating and testing containers to run code in the https://github.com/gvrocha/scVI-reproducibility repository. That repository was forked from https://github.com/romain-lopez/scVI-reproducibility and contains modifications to make it run smoothly with the container created herein.

The resulting containers are currently hosted at https://hub.docker.com/repository/docker/gvrocha/scvi

## Description of the containers in this repo

Different versions of containers are made available in this repository for different purposes.

* A container based on TF1.15.2 for use with the scVI-reproducibility repo (https://github.com/romain-lopez/scVI-reproducibility);
* A container based on Pytorch for use with the scVI repo (https://github.com/YosefLab/scVI);
* A container based on TF2.0.1 that can be used to run current TensorFlow tutorials (e.g. )

### Using the containers with Singularity

* To build a local Singularity image named scvi.py3-tf1.15.2.simg with the TF1.15.2 version:

```
singularity build scvi.py3-tf1.15.2.simg docker://gvrocha/scvi:py3-tf1.15.2
```

* To build a local Singularity image named scvi.py3-tf2.0.1.simg with the TF2.0.1 version:

```
singularity build scvi.py3-tf2.0.1.simg docker://gvrocha/scvi:py3-tf2.0.1
```

* To build a local Singularity image named scvi.py3-pytorch.simg with the Pytorch version:

```
singularity build scvi.py3-pytorch.simg docker://gvrocha/scvi:py3-pytorch
```

To execute within the Singularity container, two recommendations are made:

* use the --containall so the container is kept separate from the local environment, 
* create a local directory containing this, the scVI-reproducibility and the scVI repos and link it to the /scVI directory in the container using the -B option.

Assuming these are followed and that the repos are stored in the /home/myusername/my.scvi.directory, the call to run the Singularity container is 

```
singularity run --containall -B /home/myusername/my.scvi.directory:/scVI scvi_py3-tf1.15.2.simg
```

### Using the containers with Docker

* To run a Docker container with the TensorFlow 1.15.2 version and linking the home/myusername/my.scvi.directory folder in the host to the /scVI folder in the container, call:

```
docker container run -it -v /home/myusername/my.scvi.directory:/scVI  gvrocha/scvi:py3-tf1.15.2 /bin/bash
```

* To run a Docker container with the TensorFlow 2.0.1 version and linking the home/myusername/my.scvi.directory folder in the host to the /scVI folder in the container, call:

```
docker container run -it -v /home/myusername/my.scvi.directory:/scVI  gvrocha/scvi:py3-tf2.0.1 /bin/bash
```

* To run a Docker container with the Pytorch version and linking the home/myusername/my.scvi.directory folder in the host to the /scVI folder in the container, call:

```
docker container run -it -v /home/myusername/my.scvi.directory:/scVI  gvrocha/scvi:py3-pytorch /bin/bash
```

## Testing the image

After entering an instance of the image, the following tests can be performed.

### Load tensor flow within python

For the tensor flow containers, run python within the container and call
```python
import tensorflow as tf
print(tf.__version__)
```

### Load libraries within R 

For all containers, open an instance of R in the container and run
```R
library(rmarkdown)
library(zinbwave)
```

### Create an example report using Rmarkdown

In the examples/tests in this section, you may be prompted to install Miniconda.
If that happens, just say no; the examples should still work without it.

Assuming that the folder containing the scVI-container repo is mounted at /scVI as recommended above, go to R and run

```R
rmarkdown::render("/scVI/scVI-container/code/tensorflow_test.Rmd")
```

#### More detailed test for TF2.0.1
Under the same assumptions, you can also use the scvi:py3-tf2.0.1 to generate a report that reproduces the TensorFlow tutorial within an Rmarkdown document by calling, from within R: 
```R
rmarkdown::render("/scVI/scVI-container/py3-tf2.0.1/code/tensorflow_example.Rmd")
```
