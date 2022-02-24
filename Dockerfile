FROM continuumio/miniconda3:4.10.3p1
MAINTAINER mathias.burger@tngtech.com

ARG USER=user
ARG APP_DIR=/app
ARG DATA_DIR=/data
# Set this build argument to configure conda channels. The list is whitespace separated.
# Do NOT use the default channel if you don't have the license for it.
ARG CHANNELS=https://conda.anaconda.org/conda-forge/
ARG PIP_INDEX_URL=https://pypi.org/simple
ARG ENVIRONMENT_NAME=miniconda-docker-app

# Install additional software.
#RUN apt-get update && apt-get install -y ... && apt-get clean && rm -rf /var/lib/apt/lists/*

# Add a non-system user for the application to run.
RUN groupadd "${USER}" -g 1000 && \
    useradd -u 1000 -g "${USER}" -m -s /sbin/nologin "${USER}"

RUN mkdir -p "${APP_DIR}" "${DATA_DIR}"

# Create the environment first as it changes less often than the code.
COPY cert_pip.pem cert_conda.pem /root/
COPY environment.yml requirements.txt "${APP_DIR}"/
RUN pip config set global.no-cache-dir false \
    && pip config set global.cert /root/cert_pip.pem \
    && pip config set global.index-url "${PIP_INDEX_URL}" \
    && conda config --remove channels defaults \
    && conda config --set ssl_verify /root/cert_conda.pem \
    && for channel in ${CHANNELS}; do conda config --add channels $channel; done \
    && conda env create -f "${APP_DIR}"/environment.yml && conda clean -iptfy \
    && rm -rf /root/.condarc /root/.config/pip /root/cert_pip.pem /root/cert_conda.pem

# Copy the code.
COPY *.py "${APP_DIR}"/

ENV PATH /opt/conda/envs/${ENVIRONMENT_NAME}/bin:$PATH
ENV PYTHONPATH "${APP_DIR}":$PYTHONPATH

EXPOSE 8080
VOLUME "${DATA_DIR}"

# Run the application as user. As the environment and the code were created using the system user,
# they are only readable but NOT writable for the app. This should prevent that the app modifies
# its own code.
USER "${USER}"
WORKDIR "${APP_DIR}"
CMD ["python", "-m", "main"]
