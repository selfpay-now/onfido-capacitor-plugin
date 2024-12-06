import { WebPlugin } from '@capacitor/core';
export class SelfPayOnfidoWeb extends WebPlugin {
    async startworkflow(options) {
        console.log('ECHO', options);
        return { value: 'test' };
    }
}
//# sourceMappingURL=web.js.map