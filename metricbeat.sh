#!/usr/bin/env bash
#
# @tschaffter
#
# Creates and starts a service for Metribeat.
#

metricbeat_share_dir="/usr/share/metricbeat"
metricbeat_share_bin_dir="${metricbeat_share_dir}/bin"
metricbeat_config_dir="/etc/metricbeat"
metricbeat_data_dir="/var/lib/metricbeat"
metricbeat_log_dir="/var/log/metricbeat"

test -f /etc/systemd/system/metricbeat.service ||
{
cat >> /etc/systemd/system/metricbeat.service << EOF
[Unit]
Description=Metricbeat is a lightweight shipper for metrics.
Documentation=https://www.elastic.co/beats/metricbeat
Wants=network-online.target
After=network-online.target

[Service]
Environment="GODEBUG='madvdontneed=1'"
Environment="BEAT_LOG_OPTS="
Environment="BEAT_CONFIG_OPTS=-c /etc/metricbeat/metricbeat.yml"
Environment="BEAT_PATH_OPTS=--path.home /usr/share/metricbeat --path.config /etc/metricbeat --path.data /var/lib/metricbeat --path.logs /var/log/metricbeat"
ExecStart=/usr/share/metricbeat/bin/metricbeat --environment systemd \$BEAT_LOG_OPTS \$BEAT_CONFIG_OPTS \$BEAT_PATH_OPTS
Restart=always

[Install]
WantedBy=multi-user.target
EOF
systemctl enable metricbeat

cat >> /usr/bin/metricbeat << EOF
#!/usr/bin/env bash

# Script to run Metricbeat in foreground with the same path settings that
# the init script / systemd unit file would do.

exec /usr/share/metricbeat/bin/metricbeat \
  --path.home /usr/share/metricbeat \
  --path.config /etc/metricbeat \
  --path.data /var/lib/metricbeat \
  --path.logs /var/log/metricbeat \
  "$@"
EOF
chmod u+x /usr/bin/metricbeat

# Create metricbeat directories
mkdir -p "${metricbeat_share_dir}"
mkdir -p "${metricbeat_share_bin_dir}"
mkdir -p "${metricbeat_config_dir}"
mkdir -p "${metricbeat_data_dir}"
mkdir -p "${metricbeat_log_dir}"

# Install shared files
cp README.md "${metricbeat_share_dir}/."
cp NOTICE.txt "${metricbeat_share_dir}/."
cp LICENSE.txt "${metricbeat_share_dir}/."
cp -r kibana "${metricbeat_share_dir}/."
cp -r module "${metricbeat_share_dir}/."

# Install bin files
cp metricbeat "${metricbeat_share_bin_dir}/."
cp metricbeat "/usr/bin/."

# Install config files
cp metricbeat.yml "${metricbeat_config_dir}/."
cp metricbeat.reference.yml "${metricbeat_config_dir}/."
cp fields.yml "${metricbeat_config_dir}/."
cp -r modules.d "${metricbeat_config_dir}/."
}

systemctl stop metricbeat

# Update metricbeat (only the bin file)
cp metricbeat "${metricbeat_share_bin_dir}/."
cp metricbeat "/usr/bin/."

systemctl start metricbeat