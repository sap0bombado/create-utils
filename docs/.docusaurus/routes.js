import React from 'react';
import ComponentCreator from '@docusaurus/ComponentCreator';

export default [
  {
    path: '/create-utils/',
    component: ComponentCreator('/create-utils/', 'aed'),
    routes: [
      {
        path: '/create-utils/',
        component: ComponentCreator('/create-utils/', 'f8c'),
        routes: [
          {
            path: '/create-utils/',
            component: ComponentCreator('/create-utils/', '765'),
            routes: [
              {
                path: '/create-utils/create-input',
                component: ComponentCreator('/create-utils/create-input', '215'),
                exact: true,
                sidebar: "docs"
              },
              {
                path: '/create-utils/create-pool',
                component: ComponentCreator('/create-utils/create-pool', '8b4'),
                exact: true,
                sidebar: "docs"
              },
              {
                path: '/create-utils/create-scope',
                component: ComponentCreator('/create-utils/create-scope', 'd90'),
                exact: true,
                sidebar: "docs"
              },
              {
                path: '/create-utils/create-signal',
                component: ComponentCreator('/create-utils/create-signal', 'd5d'),
                exact: true,
                sidebar: "docs"
              },
              {
                path: '/create-utils/create-throttle',
                component: ComponentCreator('/create-utils/create-throttle', 'eae'),
                exact: true,
                sidebar: "docs"
              },
              {
                path: '/create-utils/intro',
                component: ComponentCreator('/create-utils/intro', 'e74'),
                exact: true
              },
              {
                path: '/create-utils/',
                component: ComponentCreator('/create-utils/', '93f'),
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
    path: '*',
    component: ComponentCreator('*'),
  },
];
