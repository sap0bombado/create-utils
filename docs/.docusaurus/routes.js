import React from 'react';
import ComponentCreator from '@docusaurus/ComponentCreator';

export default [
  {
    path: '/create-utils/docs',
    component: ComponentCreator('/create-utils/docs', '2bb'),
    routes: [
      {
        path: '/create-utils/docs',
        component: ComponentCreator('/create-utils/docs', 'e5a'),
        routes: [
          {
            path: '/create-utils/docs',
            component: ComponentCreator('/create-utils/docs', '3c1'),
            routes: [
              {
                path: '/create-utils/docs/create-input',
                component: ComponentCreator('/create-utils/docs/create-input', '809'),
                exact: true,
                sidebar: "docs"
              },
              {
                path: '/create-utils/docs/create-pool',
                component: ComponentCreator('/create-utils/docs/create-pool', 'aac'),
                exact: true,
                sidebar: "docs"
              },
              {
                path: '/create-utils/docs/create-scope',
                component: ComponentCreator('/create-utils/docs/create-scope', 'eff'),
                exact: true,
                sidebar: "docs"
              },
              {
                path: '/create-utils/docs/create-signal',
                component: ComponentCreator('/create-utils/docs/create-signal', '751'),
                exact: true,
                sidebar: "docs"
              },
              {
                path: '/create-utils/docs/create-throttle',
                component: ComponentCreator('/create-utils/docs/create-throttle', '911'),
                exact: true,
                sidebar: "docs"
              },
              {
                path: '/create-utils/docs/intro',
                component: ComponentCreator('/create-utils/docs/intro', '8a9'),
                exact: true,
                sidebar: "docs"
              }
            ]
          }
        ]
      }
    ]
  },
  {
    path: '/create-utils/',
    component: ComponentCreator('/create-utils/', '3ba'),
    exact: true
  },
  {
    path: '*',
    component: ComponentCreator('*'),
  },
];
