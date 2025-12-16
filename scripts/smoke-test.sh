#!/bin/bash

# Configuration
SERVICE_URL=${1:-"http://localhost:8080"}
MAX_RETRIES=30
SLEEP_INTERVAL=2

echo "Starting smoke tests against $SERVICE_URL..."

# Wait for gateway to be ready
echo "Waiting for gateway to be up..."
for ((i=1; i<=MAX_RETRIES; i++)); do
    response=$(curl -s -o /dev/null -w "%{http_code}" "$SERVICE_URL/healthz")
    if [ "$response" == "200" ]; then
        echo "✅ API Gateway is UP and healthy!"
        exit 0
    fi
    echo "Attempt $i/$MAX_RETRIES: Gateway not ready yet... waiting ${SLEEP_INTERVAL}s"
    sleep $SLEEP_INTERVAL
done

echo "❌ Gateway failed to start within timeout."
exit 1
