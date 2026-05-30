#!/usr/bin/env bash
set -euo pipefail

VAULT_NAMESPACE=${VAULT_NAMESPACE:-vault}
VAULT_POD=${VAULT_POD:-vault-0}
VAULT_SECRET_PATH=${VAULT_SECRET_PATH:-kv/spotlessbinco-api/registry}
K8S_NAMESPACE=${K8S_NAMESPACE:-evolveretechne}
K8S_SECRET_NAME=${K8S_SECRET_NAME:-registry-quantum-forge-net-credentials}

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required" >&2
  exit 1
fi

vault_json="$(kubectl exec -n "$VAULT_NAMESPACE" "$VAULT_POD" -- vault kv get -format=json "$VAULT_SECRET_PATH")"
registry_server="$(echo "$vault_json" | jq -r '.data.data.REGISTRY_SERVER // "registry.quantum-forge.net"')"
registry_username="$(echo "$vault_json" | jq -r '.data.data.REGISTRY_USERNAME // empty')"
registry_password="$(echo "$vault_json" | jq -r '.data.data.REGISTRY_PASSWORD // empty')"

if [ -z "$registry_username" ] || [ -z "$registry_password" ]; then
  echo "Missing REGISTRY_USERNAME/REGISTRY_PASSWORD in Vault at $VAULT_SECRET_PATH" >&2
  exit 1
fi

kubectl -n "$K8S_NAMESPACE" create secret docker-registry "$K8S_SECRET_NAME" \
  --docker-server="$registry_server" \
  --docker-username="$registry_username" \
  --docker-password="$registry_password" \
  --dry-run=client -o yaml | kubectl apply -f -

echo "Synced $K8S_SECRET_NAME into namespace $K8S_NAMESPACE (server: $registry_server)"
