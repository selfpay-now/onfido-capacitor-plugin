export interface SelfPayOnfidoPlugin {
  startWorkFlow(options: { workflowRunId: string; token: string }): Promise<{ status: string; message: string }>;
}
