# Must use a Cuda version 11+
# FROM pytorch/pytorch:1.11.0-cuda11.3-cudnn8-runtime
# FROM tensorflow/tensorflow:2.10.0-gpu
FROM huggingface/accelerate-cpu
ARG AUTHOR_NAME="tornikeo"
ARG AUTHOR_EMAIL="tornikeonoprishvili@gmail.com"
LABEL AUTHOR=${AUTHOR_NAME} EMAIL=${AUTHOR_EMAIL}
ARG DEBIAN_FRONTEND=noninteractive

# Install required libs
USER root
RUN apt update 
RUN apt install -y git wget

# Install python packages
WORKDIR /workspace
RUN git config --global --add safe.directory '*'
RUN git config --global user.name ${AUTHOR_NAME}
RUN git config --global user.email ${AUTHOR_EMAIL}

RUN pip3 install --upgrade pip
COPY requirements.txt .
RUN pip3 install --no-cache-dir --upgrade -r requirements.txt

ENV PORT=8000
EXPOSE ${PORT}

ARG DEV_OPTIONS
ENV DEV_OPTIONS=${DEV_OPTIONS}

ARG AWS_ACCESS_KEY_ID
ENV AWS_ACCESS_KEY_ID $AWS_ACCESS_KEY_ID

ARG AWS_SECRET_ACCESS_KEY
ENV AWS_SECRET_ACCESS_KEY $AWS_SECRET_ACCESS_KEY

ARG HF_AUTH_TOKEN
ENV HF_AUTH_TOKEN HF_AUTH_TOKEN

# CMD sanic server:server --host=0.0.0.0 --port=${PORT}
# CMD python3 -u server.py