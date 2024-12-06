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

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### startworkflow(...)

```typescript
startworkflow(options: { workflowRunId: string; token: string; }) => Promise<{ status: string; message: string; code?: string; }>
```

| Param         | Type                                                   |
| ------------- | ------------------------------------------------------ |
| **`options`** | <code>{ workflowRunId: string; token: string; }</code> |

**Returns:** <code>Promise&lt;{ status: string; message: string; code?: string; }&gt;</code>

--------------------

</docgen-api>
