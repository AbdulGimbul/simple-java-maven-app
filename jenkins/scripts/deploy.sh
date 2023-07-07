# Pull the Docker image from the registry
docker pull abdl00/simple-java-app:latest

# Run the Docker container
docker run -dp 8000:8000 --name simple-java-app abdl00/simple-java-app:latest