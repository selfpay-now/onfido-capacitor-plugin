import { WebPlugin } from '@capacitor/core';
import type { SelfPayOnfidoPlugin } from './definitions';
export declare class SelfPayOnfidoWeb extends WebPlugin implements SelfPayOnfidoPlugin {
    startworkflow(options: {
        workflowRunId: string;
        token: string;
    }): Promise<{
        value: string;
    }>;
}
