
# Production-Style Linux Server Health Monitoring

## Project Overview
A Bash-based monitoring solution for checking Linux server health, identifying resource threshold violations, and verifying critical services.

## Technologies
- Amazon Linux
- Bash scripting
- Linux system metrics
- systemd
- Cron
- Git and GitHub

## Features
- CPU utilization monitoring
- Memory utilization monitoring
- Root filesystem disk usage monitoring
- Critical service status checks
- Configurable thresholds
- Timestamped log reports
- Automatic execution every five minutes
- Alert condition testing

## Project Structure
```text
Project01-Linux-Health-Monitor/
├── config.sh
├── health_check.sh
├── README.md
└── logs/
    └── health.log
```

## Configuration
The `config.sh` file defines CPU, memory, and disk thresholds, the services to monitor, and the log destination.

## Run Manually
```bash
chmod +x health_check.sh
./health_check.sh
```

## View Logs
```bash
source ./config.sh
tail -n 25 "$LOG_FILE"
```

## Automation
Cron runs the health check every five minutes.

## Validation
- Verified CPU, memory, and disk readings.
- Verified SSH and cron service status.
- Tested CPU alert generation using a temporary threshold.
- Verified timestamped monitoring reports.

## Security Notes
- Run the script with the least privileges necessary.
- Do not store passwords, tokens, or private keys in the repository.
- Review log permissions before sharing logs publicly.

## Learning Outcomes
Linux monitoring, Bash automation, threshold-based alerts, service troubleshooting, logging, and cron scheduling.

