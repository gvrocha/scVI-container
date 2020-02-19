# scVI-container
Creating a container to run scVI-reproducibility

The container is currently hosted at https://hub.docker.com/repository/docker/gvrocha/scvi

## Downloading the image 

### For use with Singularity

To build a local Singularity image call from the latest image

  singularity build scvi.simg docker://gvrocha/scvi

To execute within the Singularity container, it is recommended to use the --containall so the instance is kept separate from the local environment and to link a local directory to the /scVI directory in the image instance.
When using this in conjunction with https://github.com/gvrocha/scVI-reproducibility, it is recommended that both the scVI-container and scVI-reproducibility be within /home/myusername/my.scvi.directory

  singularity run --containall -B /home/myusername/my.scvi.directory:/scVI scvi.simg

