## build stage ##
FROM python:3.13-alpine3.19 as build

# Set the working directory
WORKDIR /app

LABEL org.opencontainers.image.source=https://github.com/svtechnmaa/Tender_Document_Generator

# Set environment variables
ARG git_token
ARG CACHEBUST=1  # This argument will help to bust the cache for the git clone step
ARG BRANCH="main"
ARG OWNER="kiennkt"

# Update and install necessary packages
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends libc6-dev make dpkg-dev git openssh-client \
    && apt-get clean all \
    && rm -rf /var/cache/apt/archives /var/lib/apt/lists/*

# Clone the repository
RUN /usr/bin/git clone --branch $BRANCH https://$git_token@github.com/$OWNER/Tender_Document_Generator.git /app

## run stage ##
FROM python:3.13-alpine3.19

ENV OUTPUT_DIR="/opt/Tender_Document_Generator/output" \
    DB_DIR="/opt/Tender_Document_Generator/data" \
    TEMPLATE_DIR="/opt/Tender_Document_Generator/templates"

WORKDIR /opt/Tender_Document_Generator

COPY --from=build /app .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Create user without /home directory
RUN useradd -m tender

# Set permission for /opt/Tender_Document_Generator
RUN chown -R tender:tender .

# Set user tender
USER tender

# Expose the port Streamlit will run on
EXPOSE 8503

# Command to run Streamlit
ENTRYPOINT ["streamlit", "run", "streamlit_mainpage.py", "--server.port=8503", "--server.baseUrlPath=/docxtemplate/", "--server.address=0.0.0.0"]

# docker build --build-arg git_token=something --build-arg CACHEBUST=$(date +%s) --build-arg BRANCH=main --build-arg OWNER=kiennkt -t tender:v1 .

# or

# docker build --build-arg git_token=your_git_token --build-arg BRANCH=main --no-cache -t your_image_name .
