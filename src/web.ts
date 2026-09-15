import { WebPlugin } from '@capacitor/core';

import type { SelfPayOnfidoPlugin, StartWorkflowOptions, StartWorkflowResult } from './definitions';

export class SelfPayOnfidoWeb extends WebPlugin implements SelfPayOnfidoPlugin {
  startworkflow(_: StartWorkflowOptions): Promise<StartWorkflowResult> {
    throw new Error('Method not implemented.');
  }
}
