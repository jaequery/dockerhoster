export const metadata = {
  title: 'Next.js Hello World - DockerHoster',
  description: 'A simple Next.js app deployed with DockerHoster',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  )
}
