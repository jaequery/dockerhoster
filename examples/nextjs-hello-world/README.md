# Next.js Hello World - DockerHoster Example

A simple Next.js application demonstrating how to deploy to a server running DockerHoster.

## Project Structure

```
nextjs-hello-world/
├── app/
│   ├── layout.tsx
│   └── page.tsx
├── .github/
│   └── workflows/
│       └── deploy.yml
├── Dockerfile
├── docker-compose.yml
├── next.config.js
└── package.json
```

## Local Development

1. Install dependencies:
```bash
npm install
```

2. Run the development server:
```bash
npm run dev
```

3. Open [http://localhost:3000](http://localhost:3000) in your browser.

## Deployment

### Prerequisites

1. A remote Ubuntu server with DockerHoster installed and running
2. SSH access to the server
3. GitHub repository with secrets configured:
   - `SSH_HOST`: Your server IP address
   - `SSH_USER`: SSH username (e.g., `root`)
   - `SSH_PRIVATE_KEY`: Your private SSH key

### Setup

1. **On your server**, create the working directory:
```bash
mkdir -p /root/sites/nextjs-hello-world
```

2. **Update `docker-compose.yml`** with your domain:
```yaml
environment:
  - VIRTUAL_HOST=your-domain.com  # Change this!
  - VIRTUAL_PORT=3000
```

3. **Configure DNS**: Point your domain's A record to your server's IP address

4. **Push to GitHub**: The GitHub Actions workflow will automatically deploy on push to `main`

## How It Works

1. **Dockerfile**: Builds a production-ready Next.js app using multi-stage builds
2. **docker-compose.yml**: Defines the service with `VIRTUAL_HOST` for nginx-proxy
3. **GitHub Actions**: Automatically builds and deploys on push to main
4. **nginx-proxy**: Automatically routes traffic from your domain to the container

## Customization

- Change the domain in `docker-compose.yml` (`VIRTUAL_HOST`)
- Modify `app/page.tsx` to customize the homepage
- Add environment variables in `docker-compose.yml` if needed
