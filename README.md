# DockerHoster

A simple, one-command Docker virtual host hosting solution using nginx-proxy. DockerHoster automates the setup and management of an nginx-proxy container that automatically routes traffic to your Docker containers based on virtual host names.

## Overview

DockerHoster simplifies the process of hosting multiple Docker containers as virtual hosts. It sets up and manages an nginx-proxy container that automatically detects running Docker containers and routes HTTP/HTTPS traffic to them based on the `VIRTUAL_HOST` environment variable.

## Features

- **One-command setup**: Start the proxy with a single command
- **Automatic Docker installation**: Installs Docker if not present
- **Host web server management**: Automatically stops conflicting nginx/apache services
- **Docker network management**: Creates and manages the required Docker network
- **Large file upload support**: Configured for 1000MB uploads with extended timeouts
- **Auto-restart**: Container automatically restarts on system reboot
- **Simple management**: Start, stop, restart, and check status with simple commands

## Requirements

- **OS**: Ubuntu 18.04+ (LTS recommended)
- **System**: systemd-based system
- **Permissions**: Root/sudo access required
- **Ports**: Ports 80 and 443 must be available

## Installation

1. Clone or download this repository:
```bash
git clone <repository-url>
cd dockerhoster
```

2. Make the script executable:
```bash
chmod +x dockerhoster.sh
```

## Usage

### Start the Proxy

Start the nginx-proxy container (installs Docker if needed):
```bash
sudo ./dockerhoster.sh start
```

### Stop the Proxy

Stop the nginx-proxy container:
```bash
sudo ./dockerhoster.sh stop
```

### Restart the Proxy

Restart the nginx-proxy container:
```bash
sudo ./dockerhoster.sh restart
```

### Check Status

Check if the proxy is running:
```bash
sudo ./dockerhoster.sh status
```

## How It Works

1. **Pre-flight Checks**: Verifies root access and systemd availability
2. **Docker Installation**: Automatically installs Docker if not present
3. **Host Cleanup**: Stops and disables any conflicting nginx/apache services on the host
4. **Network Setup**: Creates a Docker network named `proxy-network` if it doesn't exist
5. **Configuration**: Creates nginx configuration for large file uploads (1000MB limit)
6. **Container Management**: Starts the nginx-proxy container with proper volumes and networking

## Using with Your Docker Containers

To use DockerHoster with your applications, run your containers with:

1. **Connect to the proxy network**:
```bash
docker run --network proxy-network ...
```

2. **Set the VIRTUAL_HOST environment variable**:
```bash
docker run --network proxy-network \
  -e VIRTUAL_HOST=example.com \
  your-image
```

3. **Point your domain**: Configure your DNS to point to the server's IP address

### Example

```bash
# Start DockerHoster
sudo ./dockerhoster.sh start

# Run your application container
docker run -d \
  --name myapp \
  --network proxy-network \
  -e VIRTUAL_HOST=myapp.example.com \
  your-app-image
```

Now `myapp.example.com` will automatically route to your container!

## Configuration

The script creates a custom nginx configuration at `/opt/dockerhoster/nginx/conf.d/client_max_body_size.conf` with the following settings:

- **Max upload size**: 1000MB
- **Timeouts**: 600 seconds for large uploads
- **Proxy timeouts**: Extended for handling large files

## Container Details

- **Image**: `jwilder/nginx-proxy`
- **Container name**: `nginx-proxy`
- **Network**: `proxy-network`
- **Ports**: 80 (HTTP), 443 (HTTPS)
- **Restart policy**: Always

## Troubleshooting

### Check if the proxy is running
```bash
sudo ./dockerhoster.sh status
```

### View container logs
```bash
docker logs nginx-proxy
```

### Verify network exists
```bash
docker network ls | grep proxy-network
```

### Check if ports are in use
```bash
sudo netstat -tulpn | grep -E ':(80|443)'
```

## Security Notes

- The script requires root access to manage Docker and system services
- The nginx-proxy container has read-only access to the Docker socket
- Ensure your DNS is properly configured before exposing services
- Consider setting up SSL certificates for HTTPS (nginx-proxy supports Let's Encrypt via companion containers)

## License

[Add your license here]

## Contributing

[Add contribution guidelines here]
