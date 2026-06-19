#!/bin/bash
set -euxo pipefail

# Launch Template user data runs as root automatically.
# Manual testing must use: sudo ./script.sh
if [ "$(id -u)" -ne 0 ]; then
    echo "ERROR: Run this script with sudo."
    exit 1
fi

SERVICE_NAME="customer-profile"
SERVICE_PORT="9091"
SERVICE_USER="ec2-user"

S3_BINARY_PATH="s3://lkk-app-packages/fake-service"
INSTALL_PATH="/usr/local/bin/fake-service"

SERVICE_DISPLAY_NAME="customer-profile-svc"
SERVICE_MESSAGE="HelloCloudBank | Retail Banking | customer-profile-svc"

# Customer Profile calls Account internal ALB
UPSTREAM_URIS="http://internal-account-alb-1716877376.us-east-1.elb.amazonaws.com"

EC2_HOSTNAME="$(hostname)"

# Download fake-service directly from private S3
for attempt in {1..10}; do
    if aws s3 cp "${S3_BINARY_PATH}" "${INSTALL_PATH}"; then
        break
    fi

    if [ "${attempt}" -eq 10 ]; then
        echo "ERROR: Failed to download fake-service from S3."
        exit 1
    fi

    echo "S3 download attempt ${attempt} failed. Retrying in 10 seconds..."
    sleep 10
done

chmod 0755 "${INSTALL_PATH}"
chown root:root "${INSTALL_PATH}"

cat > "/etc/systemd/system/${SERVICE_NAME}.service" <<EOF
[Unit]
Description=${SERVICE_DISPLAY_NAME}
After=network-online.target
Wants=network-online.target

[Service]
Type=simple

Environment="LISTEN_ADDR=0.0.0.0:${SERVICE_PORT}"
Environment="UPSTREAM_URIS=${UPSTREAM_URIS}"
Environment="NAME=${SERVICE_DISPLAY_NAME}-${EC2_HOSTNAME}"
Environment="MESSAGE=${SERVICE_MESSAGE} | hostname=${EC2_HOSTNAME}"

ExecStart=${INSTALL_PATH}

User=${SERVICE_USER}
Group=${SERVICE_USER}

Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable "${SERVICE_NAME}.service"
systemctl restart "${SERVICE_NAME}.service"

systemctl status "${SERVICE_NAME}.service" --no-pager