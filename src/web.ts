import { WebPlugin } from '@capacitor/core';

import type { SelfPayOnfidoPlugin } from './definitions';

export class SelfPayOnfidoWeb extends WebPlugin implements SelfPayOnfidoPlugin {
  async startworkflow(options: { workflowRunId: string; token: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return { value: 'test' };
  }
}
