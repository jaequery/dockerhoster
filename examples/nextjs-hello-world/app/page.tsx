export default function Home() {
  return (
    <main style={{
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      justifyContent: 'center',
      minHeight: '100vh',
      padding: '2rem',
      fontFamily: 'system-ui, sans-serif'
    }}>
      <h1 style={{ fontSize: '3rem', marginBottom: '1rem' }}>
        🚀 Hello World!
      </h1>
      <p style={{ fontSize: '1.5rem', color: '#666' }}>
        This Next.js app is running via DockerHoster
      </p>
      <p style={{ marginTop: '2rem', color: '#999' }}>
        Deployed with DockerHoster + nginx-proxy
      </p>
    </main>
  )
}
