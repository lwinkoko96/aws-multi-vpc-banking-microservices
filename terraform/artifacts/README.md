# Fake Service Binary

This folder is for the `fake-service` binary used in this project.

The binary is not included in this GitHub repository.

Before running Terraform, copy the binary into this folder.

Expected file path:

```text
terraform/artifacts/fake-service
```

Example:

```bash
cp /path/to/fake-service terraform/artifacts/fake-service
chmod +x terraform/artifacts/fake-service
```

## How It Works

1. Terraform uploads the binary to the S3 bucket.
2. EC2 instances start in private subnets.
3. EC2 user data downloads the binary from S3.
4. The binary is installed at:

```text
/usr/local/bin/fake-service
```

5. systemd starts the fake banking service.

```text
Terraform → S3 → EC2 user data → systemd service
```

The same binary is used for these services:

| Service          | Port |
| ---------------- | ---: |
| Customer Profile | 9091 |
| Account          | 9092 |
| Statement        | 9093 |

Do not upload the binary to GitHub.