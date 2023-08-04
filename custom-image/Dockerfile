# Use the official Maven 3.9.0 image as the base image
FROM maven:3.9.0

# Install SSH client (not the server)
RUN apt-get update && apt-get install -y openssh-client

# Copy the SSH private key to the container
# Note: Replace /path/to/your/abdl_aws_key.pem with the actual path to your SSH private key
COPY abdl_aws_key.pem /root/.ssh/id_rsa

# Set appropriate permissions for the SSH private key
RUN chmod 600 /root/.ssh/id_rsa

# Allow outgoing SSH traffic on port 22
RUN iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT

# Disable strict host key checking to avoid known_hosts verification
RUN echo "Host *" >> /root/.ssh/config && \
    echo "    StrictHostKeyChecking no" >> /root/.ssh/config
