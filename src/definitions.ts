export interface SelfPayOnfidoPlugin {
  echo(options: { workflowRunId: string; token: string }): Promise<{ value: string }>;
}
