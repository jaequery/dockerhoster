# DockerHoster

**Automated, hassle-free deployment with GitHub CI/CD** — push to GitHub and your app deploys automatically. DockerHoster lets you host 20+ websites on a single $12/month server without serverless limitations. Deploy any language, framework, or Docker container with full access to databases, cronjobs, file systems, and the entire Docker ecosystem.

Perfect for development, testing, early MVPs, and side projects. Works with Next.js, Python, Ruby on Rails, Go, Java, and any application that runs in Docker. **A cost-effective alternative to Vercel** with complete control over your infrastructure.

**Tested:** Runs 20+ websites on a single 2GB RAM server ($12/month). Uses nginx-proxy to automatically route traffic to Docker containers via `VIRTUAL_HOST` environment variable.

## Why DockerHoster? Key Benefits

DockerHoster runs everything on **your own server**, giving you complete control and flexibility:

### 🔄 **Automated GitHub CI/CD Deployment**
Push to GitHub → automatic deployment. Pre-configured GitHub Actions workflows. No manual SSH or deployment scripts needed.

### 🌐 **Language & Framework Agnostic**
Works with any language (Python, Node.js, Java, Go, Rust, PHP, Ruby, .NET) and framework (Next.js, Express, Rails, Flask, Django, Laravel, FastAPI). If it runs in Docker, it works.

### 🚀 **No Serverless Limitations**
Cronjobs, SQLite, long-running processes, file system access, background workers — all supported without restrictions.

### 🐳 **Full Docker Ecosystem**
Access PostgreSQL, MySQL, MongoDB, Redis, Typesense, AI vector DBs (Milvus, Weaviate, Qdrant, Chroma), message queues, and thousands of Docker images. Just add to `docker-compose.yml`.

## Requirements

- **OS**: Ubuntu 22.04 LTS or later (latest LTS recommended)
- **Permissions**: Root/sudo access
- **Ports**: 80 and 443 available

## Getting Started

### Step 1: Set Up Your Ubuntu Server

Get a fresh Ubuntu 22.04 LTS server from **DigitalOcean** (recommended), AWS, GCP, or any VPS provider.

**DigitalOcean Quick Setup:**
1. Create droplet → Ubuntu 22.04 LTS → $12/month (2GB RAM / 1 vCPU)
2. Add SSH key → Create droplet
3. SSH: `ssh root@your-server-ip`

**Recommended:** 2GB RAM, 1 vCPU, 25GB SSD (~$12/month) supports 20+ websites.

## Installation & Usage

```bash
git clone <repository-url>
cd dockerhoster
chmod +x dockerhoster.sh
sudo ./dockerhoster.sh start    # Installs Docker if needed, starts proxy
sudo ./dockerhoster.sh stop     # Stops proxy
sudo ./dockerhoster.sh restart  # Restarts proxy
sudo ./dockerhoster.sh status   # Check status
```

## Using with Your Docker Containers

Create a `docker-compose.yml` with `proxy-network` and `VIRTUAL_HOST`:

```yaml
version: '3.8'

services:
  app:
    image: your-app-image:latest
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

Deploy: `docker-compose up -d`. Point DNS A record to your server IP.

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

**Required GitHub Secrets:** `SSH_HOST`, `SSH_USER`, `SSH_PRIVATE_KEY`

**Key Points:**
- Use `proxy-network` network
- Set `VIRTUAL_HOST` (domain) and `VIRTUAL_PORT` (if not 80)
- Point DNS A record to server IP
- Multiple domains: `VIRTUAL_HOST=example.com,www.example.com`

## Troubleshooting

```bash
sudo ./dockerhoster.sh status  # Check proxy status
docker logs nginx-proxy        # View logs
docker network ls | grep proxy-network  # Verify network
```

## SSL/HTTPS Setup

Use **Cloudflare** for DNS: Add domain → Create A record → Set SSL mode to "Full" or "Full (strict" → Enable proxy (orange cloud). HTTPS works automatically without server certificates.

## License

[Add your license here]

## Contributing

[Add contribution guidelines here]
