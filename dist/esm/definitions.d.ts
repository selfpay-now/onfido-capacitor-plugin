/**
 * Language codes supported by the Onfido/Entrust Smart Capture SDK.
 * See https://documentation.identity.entrust.com/sdk/sdk-customization
 */
export declare type OnfidoLanguage = 'ar' | 'hy' | 'bg' | 'zh_CN' | 'zh_TW' | 'hr' | 'cs' | 'da' | 'nl' | 'en_GB' | 'en_US' | 'et' | 'fi' | 'fr' | 'fr_CA' | 'de' | 'el' | 'he' | 'hi' | 'hu' | 'id' | 'it' | 'ja' | 'ko' | 'lv' | 'lt' | 'ms' | 'nb' | 'fa' | 'pl' | 'pt' | 'pt_BR' | 'ro' | 'ru' | 'sr_Latn' | 'sk' | 'sl' | 'es' | 'es_419' | 'sv' | 'th' | 'tr' | 'uk' | 'vi';
export interface StartWorkflowOptions {
    /**
     * The Onfido workflow run ID.
     */
    workflowRunId: string;
    /**
     * The Onfido SDK token issued for that workflow run.
     */
    token: string;
    /**
     * Language the KYC flow is rendered in, e.g. `ro` or `en_GB`.
     *
     * Android: applied via `WorkflowConfig.Builder.withLocale()`.
     * iOS: not applied yet — the Onfido Studio `WorkflowConfiguration` exposes no
     * locale setter, so the flow follows the device language.
     *
     * When omitted, the SDK falls back to the device language and then to `en_US`.
     */
    language?: OnfidoLanguage;
}
export interface StartWorkflowResult {
    status: string;
    message: string;
    code?: string;
}
export interface SelfPayOnfidoPlugin {
    startworkflow(options: StartWorkflowOptions): Promise<StartWorkflowResult>;
}
