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
          routeBasePath: '/',
          sidebarPath: './sidebars.js',
        },
        blog: false,
        theme: { customCss: './src/css/custom.css' },
      },
    ],
  ],
  themeConfig: {
    colorMode: {
      defaultMode: 'dark',
      respectPrefersColorScheme: true,
    },
    navbar: {
      title: 'create-utils',
      items: [
        { href: 'https://github.com/sap0bombado/create-utils', label: 'GitHub', position: 'right' },
      ],
    },
    footer: {
      style: 'dark',
      copyright: `MIT © ${new Date().getFullYear()} Diego Bandeira`,
    },
  },
}

module.exports = config