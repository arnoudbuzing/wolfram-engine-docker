FROM ubuntu

LABEL "com.wolfram.vendor" = "Wolfram Research"
LABEL version = "1.0"
LABEL maintainer = "arnoudb@wolfram.com"
LABEL description = "Docker image for the Wolfram Engine"
 
RUN apt update && apt install -y curl avahi-daemon wget sshpass sudo locales locales-all ssh vim expect libfontconfig1 libgl1-mesa-glx libasound2

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen

RUN wget https://account.wolfram.com/download/public/wolfram-engine/desktop/LINUX && sudo bash LINUX -- -auto -verbose && rm LINUX

CMD ["/usr/bin/wolframscript"]
