FROM ubuntu:21.04
COPY ./src /app/src/

WORKDIR /app

ENV DEBIAN_FRONTEND noninteractive

RUN apt update
RUN apt install -y wget python3-pip inotify-tools texlive-latex-base texlive-fonts-recommended texlive-fonts-extra texlive-latex-extra

RUN wget https://github.com/jgm/pandoc/releases/download/2.11.0.4/pandoc-2.11.0.4-1-amd64.deb
RUN dpkg -i pandoc-2.11.0.4-1-amd64.deb

RUN wget https://github.com/Wandmalfarbe/pandoc-latex-template/releases/download/v2.0.0/Eisvogel-2.0.0.tar.gz
RUN mkdir -p /root/.local/share/pandoc/templates
RUN tar -xzf Eisvogel-2.0.0.tar.gz --directory /root/.local/share/pandoc/templates/
RUN rm -rf Eisvogel-2.0.0.tar.gz pandoc-2.11.0.4-1-amd64.deb

# Install pandoc plugins
RUN python3 -m pip install pandoc-include pandoc-mustache

# Watch file changes and reload the file if necessary
CMD echo "[INFO][$(date)] Starting..."; \
    echo "[INFO][$(date)] Pandoc Version: $(pandoc -v)" \
    mkdir /app/out; \
    echo "[INFO][$(date)] Start watching..."; \
    while true; do \
        inotifywait -r --format "%w%f" --event modify /app/src/notes/; \
        echo "[INFO][$(date)] Changes detected. Reloading..."; \
        pandoc \
            --template eisvogel \
            --listings \
            --filter pandoc-include \
            --filter pandoc-mustache \
            -s \
            -o /app/out/notes.pdf \
            /app/src/notes/index.md; \
    done

