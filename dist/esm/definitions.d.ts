export interface SelfPayOnfidoPlugin {
    startworkflow(options: {
        workflowRunId: string;
        token: string;
    }): Promise<{
        status: string;
        message: string;
        code?: string;
    }>;
}
