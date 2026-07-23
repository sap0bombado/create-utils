import clsx from 'clsx'
import Heading from '@theme/Heading'
import styles from './styles.module.css'

const FeatureList = [
  {
    title: 'Fast & Lightweight',
    description: (
      <>
        Built for performance. Each library is minimal — no bloat, no unnecessary abstractions, just what you need.
      </>
    ),
  },
  {
    title: 'Zero Dependencies',
    description: (
      <>
        Four out of five libraries have zero dependencies. Only <b>create-input</b> depends on <b>create-signal</b> and <b>create-scope</b>.
      </>
    ),
  },
  {
    title: 'Composable API',
    description: (
      <>
        Every library exports a single <code>create*</code> factory function. Consistent, predictable, and easy to compose.
      </>
    ),
  },
]

function Feature({ title, description }) {
  return (
    <div className={clsx('col col--4', 'margin-bottom--lg')}>
      <div className={styles.featureCard}>
        <div className={styles.icon}>
          <span className={styles.iconDot} />
        </div>
        <div className="text--center padding-horiz--md">
          <Heading as="h3" className={styles.featureTitle}>{title}</Heading>
          <p className={styles.featureText}>{description}</p>
        </div>
      </div>
    </div>
  )
}

export default function HomepageFeatures() {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  )
}