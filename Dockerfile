# FROM ubuntu:latest

# RUN apt-get update && apt-get install -y \
#   python3.12 \ 
#   python3-pip \
#   git 

# RUN pip3 install PyYAML

# COPY feed.py /usr/bin/feed.py

# COPY entrypoint.sh /entrypoint.sh

# ENTRYPOINT ["/entrypoint.sh"]

FROM ubuntu:latest

# Update the package list and install Python, pip, git, and virtualenv
RUN apt-get update && apt-get install -y \
  python3.12 \
  python3-pip \
  python3-venv \
  git && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Create a virtual environment
RUN python3 -m venv /opt/venv

# Activate the virtual environment and install PyYAML
RUN /opt/venv/bin/pip install --no-cache-dir PyYAML

# Copy the Python script to the appropriate directory
COPY feed.py /usr/bin/feed.py

# Ensure that the Python script uses the virtual environment
RUN sed -i '1i#!/opt/venv/bin/python' /usr/bin/feed.py
RUN chmod +x /usr/bin/feed.py

# Copy the entrypoint script to the root directory
COPY entrypoint.sh /entrypoint.sh

# Ensure the entrypoint script activates the virtual environment
RUN sed -i '1i#!/bin/bash\nsource /opt/venv/bin/activate' /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint script as the container entry point
ENTRYPOINT ["/entrypoint.sh"]
