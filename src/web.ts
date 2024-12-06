import { WebPlugin } from '@capacitor/core';

import type { SelfPayOnfidoPlugin } from './definitions';

export class SelfPayOnfidoWeb extends WebPlugin implements SelfPayOnfidoPlugin {
  startworkflow(_: {
    workflowRunId: string;
    token: string;
  }): Promise<{ status: string; message: string; code?: string }> {
    throw new Error('Method not implemented.');
  }
}
