# scVI-container
This repository contains files for creating and testing a container to run code in the https://github.com/gvrocha/scVI-reproducibility repository. That repository was forked from https://github.com/romain-lopez/scVI-reproducibility and contains modifications to make it run smoothly with the container created herein.

The resulting container is currently hosted at https://hub.docker.com/repository/docker/gvrocha/scvi

## Downloading the image 

### For use with Singularity

To build a local Singularity image call from the latest image

```
singularity build scvi.simg docker://gvrocha/scvi
```

To execute within the Singularity container, it is recommended to use the --containall so the instance is kept separate from the local environment and to link a local directory to the /scVI directory in the image instance.
When using this in conjunction with https://github.com/gvrocha/scVI-reproducibility, it is recommended that both the scVI-container and scVI-reproducibility be within /home/myusername/my.scvi.directory

```
singularity run --containall -B /home/myusername/my.scvi.directory:/scVI scvi.simg
```

## Testing the image

After entering an instance of the image, the following tests can be performed.

### Load tensor flow within python

From a python prompt within an instance of the container, run

```python
import tensorflow as tf
print(tf.__version__)
```

### Load libraries within R 

From an R prompt within an instance of the container, run
```R
library(rmarkdown)
library(zinbwave)
```

### Create an example report using Rmarkdown

In the examples/tests in this section, you may be prompted to install Miniconda.
If that happens, just say no; the examples should still work without it.

Assuming that the folder containing scVI-container is mounted at /scVI as recommended above, go to R and run

```R
rmarkdown::render("/scVI/scVI-container/code/tensorflow_test.Rmd")
```


You can also generate a report that reproduces the TensorFlow tutorial within an Rmarkdown document using 
```R
rmarkdown::render("/scVI/scVI-container/code/tensorflow_example.Rmd")
```
