# Use a base image with Ubuntu and bioinformatics tools installed
FROM ubuntu:20.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    bwa \
    samtools \
    default-jre \
    curl \
    unzip

# Download and install GATK
RUN curl -sL https://github.com/broadinstitute/gatk/releases/download/4.1.11.0/gatk-4.1.11.0.zip -o gatk.zip \
    && unzip gatk.zip \
    && rm gatk.zip

# Set the PATH environment variable to include the GATK directory
ENV PATH "$PATH:/gatk-4.1.11.0"

# Set the default command to run when the container starts
CMD ["/bin/bash"]





#################################################
docker build -t my_bwa_samtools_gatk .

docker run -it my_bwa_samtools_gatk
#################################################
