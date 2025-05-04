# My DuckDB Lambda Layer

This is a Lambda layer for serverless applications that use DuckDB with Node.js. It supports Node.js 18, 20, and 22, x86_64 and arm64 architectures.

## Deploying

You can deploy the Lambda layer like this:

```bash
sh deploy.sh <layer-name> <bucket-name>
```

Example:
```bash
sh deploy.sh my-duckdb-lambda-layer my-duckdb-lambda-layer
```

## Usage with AWS

```typescript

const duckdbLayer = lambda.LayerVersion.fromLayerVersionArn(
    this,
    "MyDuckDBLambdaLayer",
    process.env.CDK_DUCKDB_LAMBDA_LAYER_ARN as string, // This is the ARN of the Lambda layer you will receive after deployment
);
```



