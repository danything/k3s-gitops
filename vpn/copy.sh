#!/bin/sh
set -eu

REMOTE_PATH="${REMOTE_PATH:-remote:Server/}"
FILE="vpnclient.p12"

POD="$(kubectl get pod -n vpn -l app=vpn -o jsonpath='{.items[0].metadata.name}')"
kubectl exec -n vpn "$POD" -- cat /etc/ipsec.d/vpnclient.p12 > "$FILE"

rclone move -P "$FILE" "$REMOTE_PATH"
