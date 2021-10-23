#!/usr/bin/env bash
#
# @tschaffter
#
# Creates and starts a service for Filebeat.
#

filebeat_share_dir="/usr/share/filebeat"
filebeat_share_bin_dir="${filebeat_share_dir}/bin"
filebeat_config_dir="/etc/filebeat"
filebeat_data_dir="/var/lib/filebeat"
filebeat_log_dir="/var/log/filebeat"

test -f /etc/systemd/system/filebeat.service ||
{
cat >> /etc/systemd/system/filebeat.service << EOF
[Unit]
Description=Filebeat sends log files to Logstash or directly to Elasticsearch.
Documentation=https://www.elastic.co/beats/filebeat
Wants=network-online.target
After=network-online.target

[Service]

Environment="GODEBUG='madvdontneed=1'"
Environment="BEAT_LOG_OPTS="
Environment="BEAT_CONFIG_OPTS=-c /etc/filebeat/filebeat.yml"
Environment="BEAT_PATH_OPTS=--path.home /usr/share/filebeat --path.config /etc/filebeat --path.data /var/lib/filebeat --path.logs /var/log/filebeat"
ExecStart=/usr/share/filebeat/bin/filebeat --environment systemd \$BEAT_LOG_OPTS \$BEAT_CONFIG_OPTS \$BEAT_PATH_OPTS
Restart=always

[Install]
WantedBy=multi-user.target
EOF
systemctl enable filebeat

cat >> /usr/bin/filebeat << EOF
#!/usr/bin/env bash

# Script to run Filebeat in foreground with the same path settings that
# the init script / systemd unit file would do.

exec /usr/share/filebeat/bin/filebeat \
  --path.home /usr/share/filebeat \
  --path.config /etc/filebeat \
  --path.data /var/lib/filebeat \
  --path.logs /var/log/filebeat \
  "$@"
EOF
chmod u+x /usr/bin/filebeat

# Create filebeat directories
mkdir -p "${filebeat_share_dir}"
mkdir -p "${filebeat_share_bin_dir}"
mkdir -p "${filebeat_config_dir}"
mkdir -p "${filebeat_data_dir}"
mkdir -p "${filebeat_log_dir}"

# Install shared files
cp README.md "${filebeat_share_dir}/."
cp NOTICE.txt "${filebeat_share_dir}/."
cp LICENSE.txt "${filebeat_share_dir}/."
cp -r kibana "${filebeat_share_dir}/."
cp -r module "${filebeat_share_dir}/."

# Install bin files
cp filebeat "${filebeat_share_bin_dir}/."
cp filebeat "/usr/bin/."

# Install config files
cp filebeat.yml "${filebeat_config_dir}/."
cp filebeat.reference.yml "${filebeat_config_dir}/."
cp fields.yml "${filebeat_config_dir}/."
cp -r modules.d "${filebeat_config_dir}/."
}

systemctl stop filebeat

# Update filebeat (only the bin file)
cp filebeat "${filebeat_share_bin_dir}/."
cp filebeat "/usr/bin/."

systemctl start filebeat