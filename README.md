# selfpaynow-onfido

Onfido capacitor plugin

## Install

```bash
npm install selfpaynow-onfido
npx cap sync
```

## API

<docgen-index>

* [`startworkflow(...)`](#startworkflow)
* [Interfaces](#interfaces)
* [Type Aliases](#type-aliases)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### startworkflow(...)

```typescript
startworkflow(options: StartWorkflowOptions) => Promise<StartWorkflowResult>
```

| Param         | Type                                                                  |
| ------------- | --------------------------------------------------------------------- |
| **`options`** | <code><a href="#startworkflowoptions">StartWorkflowOptions</a></code> |

**Returns:** <code>Promise&lt;<a href="#startworkflowresult">StartWorkflowResult</a>&gt;</code>

--------------------


### Interfaces


#### StartWorkflowResult

| Prop          | Type                |
| ------------- | ------------------- |
| **`status`**  | <code>string</code> |
| **`message`** | <code>string</code> |
| **`code`**    | <code>string</code> |


#### StartWorkflowOptions

| Prop                | Type                                                      | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| ------------------- | --------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **`workflowRunId`** | <code>string</code>                                       | The Onfido workflow run ID.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| **`token`**         | <code>string</code>                                       | The Onfido SDK token issued for that workflow run.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| **`language`**      | <code><a href="#onfidolanguage">OnfidoLanguage</a></code> | Language the KYC flow is rendered in, e.g. `ro` or `en_GB`. Android: applied via `WorkflowConfig.Builder.withLocale()`. iOS: Onfido Studio exposes no `withLocale`, and `withCustomLocalization`'s `languageCode` does not select a language either — the SDK resolves that from the device. So the plugin passes the SDK's own `&lt;lang&gt;.lproj` as the localization bundle, which makes every string lookup land on that language directly. When omitted, or when the code has no `.lproj` in the SDK, the flow uses the device language. |


### Type Aliases


#### OnfidoLanguage

Language codes supported by the Onfido/Entrust Smart Capture SDK.
See https://documentation.identity.entrust.com/sdk/sdk-customization

<code>'ar' | 'hy' | 'bg' | 'zh_CN' | 'zh_TW' | 'hr' | 'cs' | 'da' | 'nl' | 'en_GB' | 'en_US' | 'et' | 'fi' | 'fr' | 'fr_CA' | 'de' | 'el' | 'he' | 'hi' | 'hu' | 'id' | 'it' | 'ja' | 'ko' | 'lv' | 'lt' | 'ms' | 'nb' | 'fa' | 'pl' | 'pt' | 'pt_BR' | 'ro' | 'ru' | 'sr_Latn' | 'sk' | 'sl' | 'es' | 'es_419' | 'sv' | 'th' | 'tr' | 'uk' | 'vi'</code>

</docgen-api>
