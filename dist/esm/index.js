import { registerPlugin } from '@capacitor/core';
const SelfPayOnfido = registerPlugin('SelfPayOnfido', {
    web: () => import('./web').then((m) => new m.SelfPayOnfidoWeb()),
});
export * from './definitions';
export { SelfPayOnfido };
//# sourceMappingURL=index.js.map