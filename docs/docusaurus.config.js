const config = {
  title: 'create-utils',
  tagline: 'Lightweight Luau utilities for Roblox',
  favicon: '/img/favicon.ico',
  url: 'https://sap0bombado.github.io',
  baseUrl: '/create-utils/',
  organizationName: 'sap0bombado',
  projectName: 'create-utils',
  trailingSlash: false,
  onBrokenLinks: 'throw',
  markdown: {
    hooks: {
      onBrokenMarkdownLinks: 'warn',
    },
  },
  i18n: { defaultLocale: 'en', locales: ['en'] },
  presets: [
    [
      '@docusaurus/preset-classic',
      {
        docs: {
          sidebarPath: './sidebars.js',
        },
        blog: false,
        theme: { customCss: './src/css/custom.css' },
      },
    ],
  ],
  themeConfig: {
    image: 'img/logo.png',
    colorMode: {
      defaultMode: 'dark',
      respectPrefersColorScheme: false,
    },
    navbar: {
      title: 'create-utils',
      items: [
        {
          type: 'docSidebar',
          sidebarId: 'docs',
          position: 'left',
          label: 'Docs',
        },
        {
          href: 'https://github.com/sap0bombado/create-utils',
          position: 'right',
          className: 'header-github-link',
          'aria-label': 'GitHub repository',
        },
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Docs',
          items: [
            { label: 'create-signal', to: '/docs/create-signal' },
            { label: 'create-scope', to: '/docs/create-scope' },
            { label: 'create-pool', to: '/docs/create-pool' },
            { label: 'create-input', to: '/docs/create-input' },
            { label: 'create-throttle', to: '/docs/create-throttle' },
          ],
        },
        {
          title: 'More',
          items: [
            { label: 'GitHub', href: 'https://github.com/sap0bombado/create-utils' },
          ],
        },
      ],
      copyright: `MIT © ${new Date().getFullYear()} Diego Bandeira`,
    },
    prism: {
      additionalLanguages: ['lua', 'toml', 'bash'],
    },
  },
}

module.exports = config