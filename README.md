# DockerHoster

**Push your code to GitHub and it automatically deploys** — no complicated setup needed! DockerHoster lets you run 20+ websites on one $12/month server. You can use any programming language or framework you want, and you get full access to databases, scheduled tasks, files, and everything else.

Great for learning, testing your projects, launching your first app, or running side projects. Works with Next.js, Python, Ruby on Rails, Go, Java, and basically anything that runs in Docker. **Cheaper than Vercel** and you control everything yourself.

**We tested it:** It runs 20+ websites on a single server with 2GB of memory ($12/month). It automatically sends visitors to the right website using the domain name you set up.

## Why Use DockerHoster?

Everything runs on **your own server**, so you're in control:

### 🔄 **Automatic Deployments**
Push your code to GitHub and it automatically deploys. Everything is already set up for you. No need to manually connect to your server or run complicated commands.

### 🌐 **Works with Any Language**
Use Python, Node.js, Java, Go, Rust, PHP, Ruby, or any other language. Works with Next.js, Express, Rails, Flask, Django, Laravel, FastAPI, or any framework. If it can run in Docker, it works here.

### 🚀 **No Limits Like Other Platforms**
You can run scheduled tasks, use any open source database (PostgreSQL, MySQL, MongoDB, Redis, SQLite, and more), run programs that take a long time, save files, and run background jobs. No restrictions!

### 🐳 **Use Any Database or Service**
You can use PostgreSQL, MySQL, MongoDB, Redis, search engines, AI databases, message queues, and thousands of other tools. Just add them to your `docker-compose.yml` file.

## What You Need

- **Operating System**: Ubuntu 22.04 or newer (get the latest version)
- **Access**: You need to be able to run commands as administrator (root or sudo)
- **Ports**: Ports 80 and 443 need to be free (these are used for websites)

## Getting Started

### Step 1: Get a Server

You need a server running Ubuntu 22.04 or newer. You can get one from **DigitalOcean** (we recommend this), AWS, Google Cloud, or any company that rents servers.

**How to Set Up DigitalOcean (Easiest Way):**
1. Go to DigitalOcean and create a new server (they call it a "droplet")
2. Pick Ubuntu 22.04
3. Choose the $12/month plan (2GB memory, 1 CPU)
4. Add your SSH key (so you can connect to it)
5. Create the server
6. Connect to it: `ssh root@your-server-ip`

**What to Get:** 2GB memory, 1 CPU, 25GB storage for about $12/month. This can run 20+ websites!

## Install and Use

Run these commands on your server:

```bash
git clone <repository-url>
cd dockerhoster
chmod +x dockerhoster.sh
sudo ./dockerhoster.sh start    # This installs Docker if you don't have it, then starts everything
sudo ./dockerhoster.sh stop     # Stops everything
sudo ./dockerhoster.sh restart  # Restarts everything
sudo ./dockerhoster.sh status   # Check if it's running
```

## How to Deploy Your App

Create a file called `docker-compose.yml` in your project. Here's what it should look like:

```yaml
version: '3.8'

services:
  app:
    image: your-app-image:latest
    networks:
      - proxy-network
    environment:
      - VIRTUAL_HOST=myapp.example.com    # Your website domain
      - VIRTUAL_PORT=3000                  # Port your app runs on
    restart: unless-stopped

networks:
  proxy-network:
    external: true
```

Then run `docker-compose up -d` to start your app. Make sure your domain name points to your server's IP address.

## That's It! Super Simple Setup

**For any project, you only need 2 things:**

1. **Copy the GitHub Actions workflow** (`.github/workflows/deploy.yml`) - This makes your app deploy automatically when you push to GitHub
2. **Copy the docker-compose.yml file** - This tells DockerHoster how to run your app

That's literally all you need! Just copy these two files to any project, update the domain name in docker-compose.yml, add your GitHub secrets, and push to GitHub. Your app will deploy automatically.

**I don't think hosting a website yourself can get any simpler than this** (besides using platforms like Vercel, but then you don't control your own server). This is as easy as it gets while still running everything on your own infrastructure. **For complex projects with databases and multiple services, this is actually even simpler** than platforms like Vercel because you can add everything in one docker-compose.yml file instead of managing separate services.

## Example: Deploy a Next.js App

We have a complete working example you can copy! Check out [`examples/nextjs-hello-world/`](examples/nextjs-hello-world/). It includes:

- ✅ A Next.js app that works
- ✅ A Dockerfile (tells Docker how to build your app)
- ✅ A docker-compose.yml file (already set up)
- ✅ GitHub Actions workflow (makes it deploy automatically)
- ✅ Instructions

**How to Use It:**

1. Copy the example to your project folder:
```bash
cp -r examples/nextjs-hello-world /path/to/your/project
cd /path/to/your/project
```

2. Change the domain name in `docker-compose.yml`:
```yaml
environment:
  - VIRTUAL_HOST=your-domain.com    # Put your domain here
```

3. Add these secrets to GitHub (Settings → Secrets):
   - `SSH_HOST` - Your server's IP address
   - `SSH_USER` - Usually "root"
   - `SSH_PRIVATE_KEY` - Your SSH key

4. Push your code to GitHub - it will deploy automatically!

**Important Things to Remember:**
- Always use `proxy-network` in your docker-compose.yml
- Set `VIRTUAL_HOST` to your domain name
- Set `VIRTUAL_PORT` if your app doesn't run on port 80
- Make sure your domain points to your server's IP address
- For multiple domains: `VIRTUAL_HOST=example.com,www.example.com`

## If Something Goes Wrong

Run these commands to check what's happening:

```bash
sudo ./dockerhoster.sh status  # See if DockerHoster is running
docker logs nginx-proxy        # See error messages
docker network ls | grep proxy-network  # Check if the network exists
```

## Setting Up HTTPS (Secure Websites)

I personally prefer **Cloudflare** for SSL because it's super simple and you need to set up DNS anyway! Why reinvent the wheel? You could set up Let's Encrypt certificates yourself, but Cloudflare handles everything automatically.

**Bonus benefits:** Cloudflare also gives you free DDoS protection (stops attacks on your website) and a Web Application Firewall (WAF) that blocks bad traffic automatically. Plus it makes your site faster with their CDN (content delivery network).

**How to set it up:**
1. Add your domain to Cloudflare
2. Create an A record pointing to your server's IP (you'd do this anyway for DNS)
3. Set SSL mode to "Full" or "Full (strict)"
4. Turn on the proxy (the orange cloud icon)

That's it! Your website will automatically use HTTPS without you needing to set up certificates on your server. Since you need to configure DNS anyway, using Cloudflare saves you a step and gives you extra protection.

## License

[Add your license here]

## Contributing

[Add contribution guidelines here]
