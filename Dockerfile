FROM ubuntu:22.04

MAINTAINER yftzeng "yftzeng@gmail.com"

ENV TZ ${TZ}
ENV TERM linux
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE DontWarn
ENV DEBIAN_FRONTEND noninteractive

ARG BUILD_ARGS
ARG RUN_ARGS
ARG VOLUME
ENV BUILD_ARGS ${BUILD_ARGS}
ENV RUN_ARGS ${RUN_ARGS}
ENV VOLUME ${VOLUME}

ARG USERNAME=wow
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN \
    apt-get update \
    && apt-get dist-upgrade -yq --no-install-recommends \
    && apt-get install -yq --no-install-recommends \
        curl \
        git-core \
	git-lfs \
	python3 \
	python3-pip \
	python3-venv \
	python3-opencv \
    && groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get install -yq --no-install-recommends sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && curl -sL https://raw.githubusercontent.com/AUTOMATIC1111/stable-diffusion-webui/master/webui.sh | sudo -u $USERNAME env COMMANDLINE_ARGS="${BUILD_ARGS}" bash \
    && sudo -u $USERNAME mkdir -p /home/$USERNAME/stable-diffusion-webui/models/openpose \
       && sudo -u $USERNAME curl -Lo /home/$USERNAME/stable-diffusion-webui/models/openpose/body_pose_model.pth https://huggingface.co/lllyasviel/ControlNet/resolve/main/annotator/ckpts/body_pose_model.pth \
       && sudo -u $USERNAME curl -Lo /home/$USERNAME/stable-diffusion-webui/models/openpose/hand_pose_model.pth https://huggingface.co/lllyasviel/ControlNet/resolve/main/annotator/ckpts/hand_pose_model.pth \
    && sudo -u $USERNAME git clone https://github.com/Mikubill/sd-webui-controlnet.git /home/$USERNAME/stable-diffusion-webui/extensions/sd-webui-controlnet \
    && sudo -u $USERNAME git clone https://huggingface.co/webui/ControlNet-modules-safetensors /home/$USERNAME/stable-diffusion-webui/extensions/ControlNet-modules-safetensors

COPY --chown=$USERNAME:$USERNAME ${VOLUME}/config.json /home/$USERNAME/stable-diffusion-webui/config.json

RUN \
    sed -i -e 's/"outputs\//"\/'${VOLUME}'\/outputs\//g' -e 's/\(.*outdir_save.*:\ \).*/\1"\/'${VOLUME}'\/outputs\/save"/' /home/$USERNAME/stable-diffusion-webui/config.json

WORKDIR /home/$USERNAME/stable-diffusion-webui
USER $USERNAME

CMD bash -c ". $HOME/stable-diffusion-webui/venv/bin/activate ; bash /${VOLUME}/linking.sh ; python3 -u webui.py ${RUN_ARGS}"
