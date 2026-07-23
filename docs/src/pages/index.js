import Link from '@docusaurus/Link'

export default function Home() {
  return (
    <main style={{ padding: '4rem 2rem', maxWidth: 800, margin: '0 auto' }}>
      <h1>create-utils</h1>
      <p>Collection of lightweight Luau utility libraries for Roblox.</p>
      <p>Each library exports a single <code>create*</code> factory function — no classes, no inheritance, just closures and tables.</p>
      <ul>
        <li><Link to="/create-utils/docs/create-signal">create-signal</Link> — event emitter</li>
        <li><Link to="/create-utils/docs/create-scope">create-scope</Link> — resource cleanup</li>
        <li><Link to="/create-utils/docs/create-pool">create-pool</Link> — object pool</li>
        <li><Link to="/create-utils/docs/create-input">create-input</Link> — input wrapper</li>
        <li><Link to="/create-utils/docs/create-throttle">create-throttle</Link> — rate limiter</li>
      </ul>
    </main>
  )
}