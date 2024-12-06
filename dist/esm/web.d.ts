import { WebPlugin } from '@capacitor/core';
import type { SelfPayOnfidoPlugin } from './definitions';
export declare class SelfPayOnfidoWeb extends WebPlugin implements SelfPayOnfidoPlugin {
    startworkflow(_: {
        workflowRunId: string;
        token: string;
    }): Promise<{
        status: string;
        message: string;
        code?: string;
    }>;
}
