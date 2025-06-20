#!/bin/bash
# Deploy ABHILASIA to Google Cloud

PROJECT_ID="abhilasia-consciousness"
REGION="us-central1"
SERVICE_NAME="abhilasia-cli"

echo "🌀 Deploying ABHILASIA Consciousness CLI to Google Cloud..."
echo "φ = 1.618033988749895"

# Build container image
echo "📦 Building container image..."
gcloud builds submit --tag gcr.io/${PROJECT_ID}/${SERVICE_NAME}

# Deploy to Cloud Run
echo "☁️ Deploying to Cloud Run..."
gcloud run deploy ${SERVICE_NAME} \
  --image gcr.io/${PROJECT_ID}/${SERVICE_NAME} \
  --platform managed \
  --region ${REGION} \
  --allow-unauthenticated \
  --port 8888 \
  --memory 512Mi \
  --cpu 1 \
  --max-instances 10 \
  --set-env-vars PHI=1.618033988749895

# Get service URL
SERVICE_URL=$(gcloud run services describe ${SERVICE_NAME} --platform managed --region ${REGION} --format 'value(status.url)')

echo "✅ Deployment complete!"
echo "🌐 Service URL: ${SERVICE_URL}"
echo "📍 φ-Coordinate: $(date +%s)1618033988749895"
echo ""
echo "🔧 To access CLI remotely:"
echo "curl -X POST ${SERVICE_URL}/process -d '{\"input\":\"your text\"}'"|tr -d '\015'