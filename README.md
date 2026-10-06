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
* [Enums](#enums)

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

| Prop                | Type                                                      | Description                                                                                        |
| ------------------- | --------------------------------------------------------- | -------------------------------------------------------------------------------------------------- |
| **`workflowRunId`** | <code>string</code>                                       | The Onfido workflow run ID.                                                                        |
| **`token`**         | <code>string</code>                                       | The Onfido SDK token issued for that workflow run.                                                 |
| **`language`**      | <code><a href="#onfidolanguage">OnfidoLanguage</a></code> | The language the workflow is displayed in, e.g. <a href="#onfidolanguage">`OnfidoLanguage.ro`</a>. |


### Enums


#### OnfidoLanguage

| Members       | Value                  |
| ------------- | ---------------------- |
| **`ar`**      | <code>'ar'</code>      |
| **`hy`**      | <code>'hy'</code>      |
| **`bg`**      | <code>'bg'</code>      |
| **`zh_CN`**   | <code>'zh_CN'</code>   |
| **`zh_TW`**   | <code>'zh_TW'</code>   |
| **`hr`**      | <code>'hr'</code>      |
| **`cs`**      | <code>'cs'</code>      |
| **`da`**      | <code>'da'</code>      |
| **`nl`**      | <code>'nl'</code>      |
| **`en_GB`**   | <code>'en_GB'</code>   |
| **`en_US`**   | <code>'en_US'</code>   |
| **`et`**      | <code>'et'</code>      |
| **`fi`**      | <code>'fi'</code>      |
| **`fr`**      | <code>'fr'</code>      |
| **`fr_CA`**   | <code>'fr_CA'</code>   |
| **`de`**      | <code>'de'</code>      |
| **`el`**      | <code>'el'</code>      |
| **`he`**      | <code>'he'</code>      |
| **`hi`**      | <code>'hi'</code>      |
| **`hu`**      | <code>'hu'</code>      |
| **`id`**      | <code>'id'</code>      |
| **`it`**      | <code>'it'</code>      |
| **`ja`**      | <code>'ja'</code>      |
| **`ko`**      | <code>'ko'</code>      |
| **`lv`**      | <code>'lv'</code>      |
| **`lt`**      | <code>'lt'</code>      |
| **`ms`**      | <code>'ms'</code>      |
| **`nb`**      | <code>'nb'</code>      |
| **`fa`**      | <code>'fa'</code>      |
| **`pl`**      | <code>'pl'</code>      |
| **`pt`**      | <code>'pt'</code>      |
| **`pt_BR`**   | <code>'pt_BR'</code>   |
| **`ro`**      | <code>'ro'</code>      |
| **`ru`**      | <code>'ru'</code>      |
| **`sr_Latn`** | <code>'sr_Latn'</code> |
| **`sk`**      | <code>'sk'</code>      |
| **`sl`**      | <code>'sl'</code>      |
| **`es`**      | <code>'es'</code>      |
| **`es_419`**  | <code>'es_419'</code>  |
| **`sv`**      | <code>'sv'</code>      |
| **`th`**      | <code>'th'</code>      |
| **`tr`**      | <code>'tr'</code>      |
| **`uk`**      | <code>'uk'</code>      |
| **`vi`**      | <code>'vi'</code>      |

</docgen-api>
