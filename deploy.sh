#! /bin/bash

rm -rf layer.zip

cd nodejs
rm -rf node_modules
rm package-lock.json
npm install --force
cd ..

zip -r layer.zip nodejs

# Check if bucket exists, create if it doesn't
if ! aws s3 ls s3://my-duckdb-lambda-layer 2>/dev/null; then
    aws s3 mb s3://my-duckdb-lambda-layer
fi

aws s3 cp layer.zip s3://my-duckdb-lambda-layer/layer.zip

aws lambda publish-layer-version \
    --layer-name my-duckdb-lambda-layer \
    --description "DuckDB Node.js bindings layer" \
    --content S3Bucket=my-duckdb-lambda-layer,S3Key=layer.zip \
    --compatible-runtimes nodejs18.x nodejs20.x nodejs22.x \
    --compatible-architectures x86_64 arm64