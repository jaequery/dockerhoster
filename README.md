# DockerHoster

A simple, one-command Docker virtual host hosting solution using nginx-proxy. DockerHoster automates the setup and management of an nginx-proxy container that automatically routes traffic to your Docker containers based on virtual host names.

## Overview

DockerHoster simplifies the process of hosting multiple Docker containers as virtual hosts. It sets up and manages an nginx-proxy container that automatically detects running Docker containers and routes HTTP/HTTPS traffic to them based on the `VIRTUAL_HOST` environment variable.

**Performance & Use Cases:**

DockerHoster has been tested and proven to run **20+ websites** on a single **2GB RAM DigitalOcean instance** without performance issues. This makes it perfect for:
- **Development & Testing**: Quickly spin up multiple test environments
- **Early MVP Launches**: Host multiple small-to-medium applications cost-effectively
- **Side Projects**: Manage multiple projects on a single server
- **Staging Environments**: Run multiple staging sites efficiently

## Why DockerHoster? Key Benefits

Unlike serverless platforms, DockerHoster runs everything on **your own server**, giving you complete control and flexibility:

### 🌐 **Language & Framework Agnostic**
Host applications built with **any language or framework**:
- **Languages**: Python, Node.js, Java, Scala, Go, Rust, PHP, Ruby, .NET, and more
- **Frameworks**: Next.js, Express, Ruby on Rails, Flask, Django, Spring Boot, Laravel, FastAPI, and any framework that runs in Docker
- **Platform Independent**: Works with any application that can be containerized

No need to choose a specific platform or language—if it runs in Docker, it runs on DockerHoster.

### 🚀 **No Serverless Limitations**
- **Cronjobs**: Run scheduled tasks directly in your containers
- **SQLite**: Use file-based databases without restrictions
- **Long-running processes**: No timeout limits or cold starts
- **File system access**: Full read/write access to persistent storage
- **Background workers**: Run queues, workers, and background jobs seamlessly

### 🐳 **Full Docker Ecosystem Access**
Because everything is Docker Compose-based, you have access to the entire open-source ecosystem:

**Databases:**
- **Relational**: PostgreSQL, MySQL, MariaDB, SQLite
- **NoSQL**: MongoDB, Redis, CouchDB, Cassandra
- **Search**: Typesense, OpenSearch, Elasticsearch, Meilisearch
- **AI Vector Databases**: Milvus, Weaviate, Qdrant, Chroma, Pinecone (self-hosted)

**Other Services:**
- **Message Queues**: RabbitMQ, Redis Queue, BullMQ, Apache Kafka
- **Caching**: Redis, Memcached
- **Monitoring**: Prometheus, Grafana, Portainer
- **And thousands more**: Any Docker image from Docker Hub

Perfect for AI/ML applications that need vector databases for embeddings, RAG (Retrieval-Augmented Generation), and semantic search!

Simply add services to your `docker-compose.yml` and they're instantly available to your applications on the same network.

### 💰 **Cost-Effective**
Run multiple applications, databases, and services on a single affordable VPS instead of paying per-service on cloud platforms.

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

## Getting Started

### Step 1: Set Up Your Ubuntu Server

First, you'll need a fresh Ubuntu LTS server. You can get one from:

- **DigitalOcean** (Recommended) 🌟
- **AWS EC2**
- **Google Cloud Platform (GCP)**
- **Linode**
- **Any VPS provider**

**Why DigitalOcean?**

We recommend **DigitalOcean** for DockerHoster because:

- **💰 Best Price-to-Performance**: Excellent value for money, especially for the 2GB RAM droplet ($12/month)
- **🚀 Easy Setup**: Simple, intuitive interface - get a server running in under 60 seconds
- **📊 Transparent Pricing**: No hidden fees, predictable monthly costs
- **🌍 Global Data Centers**: Choose from multiple regions worldwide
- **📚 Great Documentation**: Comprehensive guides and tutorials
- **💳 Flexible Billing**: Pay-as-you-go or monthly plans
- **🔧 One-Click Apps**: Pre-configured Ubuntu images available

**Quick Setup on DigitalOcean:**

1. Sign up at [digitalocean.com](https://www.digitalocean.com)
2. Click "Create" → "Droplets"
3. Choose **Ubuntu 22.04 LTS** (or latest LTS)
4. Select **Regular Intel** → **Basic** → **$12/month** (2GB RAM / 1 vCPU) - perfect for 20+ sites
5. Choose your datacenter region
6. Add your SSH key (or create a new one)
7. Click "Create Droplet"
8. Once created, SSH into your server: `ssh root@your-server-ip`

**Minimum Recommended Specs:**
- **RAM**: 2GB (supports 20+ websites)
- **CPU**: 1 vCPU
- **Storage**: 25GB SSD
- **Cost**: ~$12/month on DigitalOcean

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

To use DockerHoster with your applications, create a `docker-compose.yml` file with:

1. **Connect to the proxy network**: Add `proxy-network` as an external network
2. **Set the VIRTUAL_HOST environment variable**: Add it to your service's environment
3. **Point your domain**: Configure your DNS to point to the server's IP address

### Example

Create a `docker-compose.yml` file:

```yaml
version: '3.8'

services:
  app:
    image: your-app-image:latest
    container_name: myapp
    networks:
      - proxy-network
    environment:
      - VIRTUAL_HOST=myapp.example.com
      - VIRTUAL_PORT=3000
    restart: unless-stopped

networks:
  proxy-network:
    external: true
```

Then deploy:

```bash
# Start DockerHoster
sudo ./dockerhoster.sh start

# Deploy your application
docker-compose up -d
```

Now `myapp.example.com` will automatically route to your container!

## Deployment Examples

Here are practical examples of how to deploy your projects to a remote Ubuntu server running DockerHoster.

### Complete Example: Next.js Hello World

A complete, working example project is available in [`examples/nextjs-hello-world/`](examples/nextjs-hello-world/). This includes:

- ✅ Full Next.js application
- ✅ Production-ready Dockerfile
- ✅ Docker Compose configuration
- ✅ GitHub Actions workflow for automatic deployment
- ✅ Complete documentation

**Quick Start:**

1. Copy the example to your project:
```bash
cp -r examples/nextjs-hello-world /path/to/your/project
cd /path/to/your/project
```

2. Update `docker-compose.yml` with your domain:
```yaml
environment:
  - VIRTUAL_HOST=your-domain.com
```

3. Configure GitHub Secrets (SSH_HOST, SSH_USER, SSH_PRIVATE_KEY)

4. Push to GitHub - deployment happens automatically!

See [`examples/nextjs-hello-world/README.md`](examples/nextjs-hello-world/README.md) for detailed instructions.

### Example 1: Complete GitHub Actions with Docker Build (Next.js)

For simple Next.js projects that build Docker images in CI:

```yaml
name: Build and Deploy

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Build Docker image
        run: docker build -t nextjs-app:latest .

      - name: Save and transfer image
        run: |
          docker save nextjs-app:latest | gzip > app.tar.gz
          scp -o StrictHostKeyChecking=no app.tar.gz docker-compose.yml ${{ secrets.SSH_USER }}@${{ secrets.SSH_HOST }}:/root/sites/nextjs-app/

      - name: Deploy on server
        uses: appleboy/ssh-action@v1.0.0
        with:
          host: ${{ secrets.SSH_HOST }}
          username: ${{ secrets.SSH_USER }}
          key: ${{ secrets.SSH_PRIVATE_KEY }}
          script: |
            cd /root/sites/nextjs-app
            docker load < app.tar.gz
            docker-compose up -d
```

**Required GitHub Secrets:**
- `SSH_HOST`: Your server IP (e.g., `147.182.228.87`)
- `SSH_USER`: SSH username (e.g., `root`)
- `SSH_PRIVATE_KEY`: Your private SSH key

**Prerequisites for Next.js:**
- A `Dockerfile` in your project root (see the Next.js Hello World example for a production-ready Dockerfile)
- A `docker-compose.yml` file with `proxy-network` configuration (see "Using with Your Docker Containers" section above)
- Your Next.js app configured with `output: 'standalone'` in `next.config.js` for optimal Docker builds

### Key Points for All Examples

1. **Always use `proxy-network`**: Your containers must be on the `proxy-network` Docker network
2. **Set `VIRTUAL_HOST`**: This tells nginx-proxy which domain to route to your container
3. **Set `VIRTUAL_PORT`**: If your app doesn't run on port 80, specify the port (e.g., `VIRTUAL_PORT=3000`)
4. **DNS Configuration**: Point your domain's A record to your server's IP address
5. **Multiple Domains**: Use comma-separated values: `VIRTUAL_HOST=example.com,www.example.com`

### Pre-deployment Checklist

- [ ] DockerHoster is running on the server (`sudo ./dockerhoster.sh status`)
- [ ] DNS A record points to your server IP
- [ ] Container is configured with `VIRTUAL_HOST` environment variable
- [ ] Container is connected to `proxy-network`
- [ ] Firewall allows ports 80 and 443

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

## SSL/HTTPS Setup

For SSL/HTTPS support, use **Cloudflare** for DNS management:

1. **Point your domain to Cloudflare**: Add your domain to Cloudflare and update your nameservers
2. **Create DNS A record**: Point your domain/subdomain to your server's IP address
3. **Set SSL mode**: In Cloudflare dashboard, go to **SSL/TLS** → **Overview** and set SSL/TLS encryption mode to **"Full"** or **"Full (strict)"**
   - **Full**: Encrypts traffic between Cloudflare and your server (works with self-signed certificates)
   - **Full (strict)**: Requires valid SSL certificate on your server (recommended for production)
4. **Enable Proxy**: Make sure the orange cloud (proxy) is enabled on your DNS A record

With Cloudflare's proxy enabled, all traffic will be automatically encrypted via HTTPS without needing to configure SSL certificates on your server.

## Security Notes

- The script requires root access to manage Docker and system services
- The nginx-proxy container has read-only access to the Docker socket
- Ensure your DNS is properly configured before exposing services
- For SSL/HTTPS, use Cloudflare DNS with SSL mode set to "Full" or "Full (strict)"

## License

[Add your license here]

## Contributing

[Add contribution guidelines here]
