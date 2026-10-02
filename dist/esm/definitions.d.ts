/**
 * Language codes supported by the Onfido/Entrust Smart Capture SDK.
 * See https://documentation.identity.entrust.com/sdk/sdk-customization
 */
export declare enum OnfidoLanguage {
    ar = "ar",
    hy = "hy",
    bg = "bg",
    zh_CN = "zh_CN",
    zh_TW = "zh_TW",
    hr = "hr",
    cs = "cs",
    da = "da",
    nl = "nl",
    en_GB = "en_GB",
    en_US = "en_US",
    et = "et",
    fi = "fi",
    fr = "fr",
    fr_CA = "fr_CA",
    de = "de",
    el = "el",
    he = "he",
    hi = "hi",
    hu = "hu",
    id = "id",
    it = "it",
    ja = "ja",
    ko = "ko",
    lv = "lv",
    lt = "lt",
    ms = "ms",
    nb = "nb",
    fa = "fa",
    pl = "pl",
    pt = "pt",
    pt_BR = "pt_BR",
    ro = "ro",
    ru = "ru",
    sr_Latn = "sr_Latn",
    sk = "sk",
    sl = "sl",
    es = "es",
    es_419 = "es_419",
    sv = "sv",
    th = "th",
    tr = "tr",
    uk = "uk",
    vi = "vi"
}
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
     * The language the workflow is displayed in, e.g. `OnfidoLanguage.ro`.
     */
    language: OnfidoLanguage;
}
export interface StartWorkflowResult {
    status: string;
    message: string;
    code?: string;
}
export interface SelfPayOnfidoPlugin {
    startworkflow(options: StartWorkflowOptions): Promise<StartWorkflowResult>;
}
