#!/bin/bash

# Assuming you have copied the JAR file to the server already.
# Replace "your-app.jar" with the actual name of your JAR file.
JAR_NAME="your-app.jar"

# Stop the running application (if any)
echo "Stopping the currently running application (if any)..."
sudo systemctl stop your-app.service

# Replace "your-app" with the name of your systemd service.
# Create a Systemd service for your Java app to manage it easily.
echo "Creating or updating the Systemd service..."
cat <<EOF | sudo tee /etc/systemd/system/your-app.service > /dev/null
[Unit]
Description=Your Java App
After=network.target

[Service]
User=app
WorkingDirectory=/path/to/your/app
ExecStart=/usr/bin/java -jar ${JAR_NAME}
SuccessExitStatus=143

[Install]
WantedBy=multi-user.target
EOF

# Reload the Systemd manager configuration
sudo systemctl daemon-reload

# Start the application
echo "Starting the application..."
sudo systemctl start your-app.service

# Enable the service to start on boot
echo "Enabling the service to start on boot..."
sudo systemctl enable your-app.service

echo "Deployment completed successfully!"