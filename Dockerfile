# Use the existing Konakart image as the base
FROM konakart/konakart_9600_ce

# Set the working directory
WORKDIR /app

# Install curl
RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*

# Download the SolarWinds APM agent using curl
RUN curl -sSO https://agent-binaries.cloud.solarwinds.com/apm/java/latest/solarwinds-apm-agent.jar

# Copy the agent to the desired location
RUN mv solarwinds-apm-agent.jar /opt/solarwinds-apm-agent.jar

# Add the JAVA_OPTS line to the catalina.sh file
RUN sed -i 's|^JAVA_OPTS=.*|JAVA_OPTS="-javaagent:/opt/solarwinds-apm-agent.jar -Dsw.apm.service.key=SERVICE-KEY HERE -Dsw.apm.collector=apm.collector.cloud.solarwinds.com"|' /usr/local/konakart/bin/catalina.sh

# Start Konakart
#CMD ["/usr/local/konakart/bin/startkonakart.sh", "run"]
