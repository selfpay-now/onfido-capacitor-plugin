import { registerPlugin } from '@capacitor/core';

import type { SelfPayOnfidoPlugin } from './definitions';

const SelfPayOnfido = registerPlugin<SelfPayOnfidoPlugin>('SelfPayOnfido', {
  web: () => import('./web').then((m) => new m.SelfPayOnfidoWeb()),
});

export * from './definitions';
export { SelfPayOnfido };
