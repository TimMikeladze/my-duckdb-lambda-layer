#! /bin/bash

# Default configuration parameters
LAYER_NAME=${1:-"my-duckdb-lambda-layer"}
BUCKET_NAME=${2:-"my-duckdb-lambda-layer"}
LAYER_DESCRIPTION="DuckDB Node.js bindings layer"

echo "Using layer name: ${LAYER_NAME}"
echo "Using bucket: ${BUCKET_NAME}"

rm -rf layer.zip

cd nodejs
rm -rf node_modules
rm package-lock.json
npm install --force
cd ..

zip -r layer.zip nodejs

# Check if bucket exists, create if it doesn't
if ! aws s3 ls s3://${BUCKET_NAME} 2>/dev/null; then
    aws s3 mb s3://${BUCKET_NAME}
fi

aws s3 cp layer.zip s3://${BUCKET_NAME}/layer.zip

aws lambda publish-layer-version \
    --layer-name ${LAYER_NAME} \
    --description "${LAYER_DESCRIPTION}" \
    --content S3Bucket=${BUCKET_NAME},S3Key=layer.zip \
    --compatible-runtimes nodejs18.x nodejs20.x nodejs22.x \
    --compatible-architectures x86_64 arm64