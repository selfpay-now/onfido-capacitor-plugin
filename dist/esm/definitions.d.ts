export interface SelfPayOnfidoPlugin {
    startworkflow(options: {
        workflowRunId: string;
        token: string;
    }): Promise<{
        value: string;
    }>;
}
