# Use a base image with Java 11
FROM openjdk:11

# Set the working directory inside the container
WORKDIR /app

# Copy the application JAR file to the container
COPY target/my-app.jar /app/my-app.jar

# Set the entry point command to run the application
CMD ["java", "-jar", "my-app.jar"]