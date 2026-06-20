#!/bin/bash
set -euxo pipefail

exec > /var/log/statement-bootstrap.log 2>&1

SERVICE_NAME="${service_name}"
SERVICE_PORT=${service_port}
SERVICE_USER="${service_user}"
S3_BINARY_PATH="${s3_binary_path}"
INSTALL_PATH="${install_path}"
SERVICE_DISPLAY_NAME="${service_display_name}"
SERVICE_MESSAGE="${service_message}"

retry_count=0
max_retries=10
sleep_seconds=10

while [ $retry_count -lt $max_retries ]; do
  if aws s3 cp "$S3_BINARY_PATH" "$INSTALL_PATH"; then
    break
  fi
  retry_count=$((retry_count + 1))
  sleep $sleep_seconds
 done

chmod 0755 "$INSTALL_PATH"
chown root:root "$INSTALL_PATH"

cat > /etc/systemd/system/$${SERVICE_DISPLAY_NAME}.service <<SERVICE_EOF
[Unit]
Description=$${SERVICE_MESSAGE}
After=network.target

[Service]
Type=simple
User=$${SERVICE_USER}
Environment="LISTEN_ADDR=0.0.0.0:$${SERVICE_PORT}"
Environment="NAME=$${SERVICE_DISPLAY_NAME}-$${HOSTNAME}"
Environment="MESSAGE=$${SERVICE_MESSAGE} | hostname=$${HOSTNAME}"
ExecStart=$${INSTALL_PATH}
Restart=on-failure

[Install]
WantedBy=multi-user.target
SERVICE_EOF

systemctl daemon-reload
systemctl enable "$${SERVICE_DISPLAY_NAME}.service"
systemctl restart "$${SERVICE_DISPLAY_NAME}.service"
systemctl status "$${SERVICE_DISPLAY_NAME}.service" --no-pager
