# Howto

## Filebeat

$ ./filebeat modules list
Enabled:

Disabled:
activemq
apache
auditd
aws
awsfargate
azure
barracuda
bluecoat
cef
checkpoint
cisco
coredns
crowdstrike
cyberark
cyberarkpas
cylance
elasticsearch
envoyproxy
f5
fortinet
gcp
google_workspace
googlecloud
gsuite
haproxy
ibmmq
icinga
iis
imperva
infoblox
iptables
juniper
kafka
kibana
logstash
microsoft
misp
mongodb
mssql
mysql
mysqlenterprise
nats
netflow
netscout
nginx
o365
okta
oracle
osquery
panw
pensando
postgresql
proofpoint
rabbitmq
radware
redis
santa
snort
snyk
sonicwall
sophos
squid
suricata
system
threatintel
tomcat
traefik
zeek
zookeeper
zoom
zscaler

$ ./filebeat modules enable system

## Metricbeat

./metricbeat test config
./metricbeat test output

./metricbeat steup

./metricbeat test config -e
./metricbeat modules list
./metricbeat -c metricbeat.yml -e

Not tested yet:

sudo service metricbeat start

List of indices generated in Elasticsearch:

$ curl -u elastic:changeme -XGET 'localhost:9200/_cat/indices?v&pretty'
health status index                                     uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .kibana-event-log-7.15.0-000001           NwPLU6_gSge2EJY7tHPQeA   1   0          1            0        6kb            6kb
green  open   .monitoring-kibana-7-2021.09.27           fszq2P_8RNaNb5aVJ3kRLQ   1   0       6576            0      1.2mb          1.2mb
green  open   .monitoring-kibana-7-2021.09.26           7HVe-UBSRLC1HnB3i57j2A   1   0      17162            0      2.6mb          2.6mb
green  open   .kibana_7.13.4_001                        f9kIct9cRTqRO8E0KkTMQA   1   0       1492           30      4.5mb          4.5mb
green  open   .monitoring-kibana-7-2021.09.22           NGaSke44RAuYPD6xN7eTJw   1   0       3032            0    587.1kb        587.1kb
green  open   .monitoring-kibana-7-2021.09.25           nxRuW_WnSEugQIg_qahDqw   1   0       5906            0    980.4kb        980.4kb
green  open   .geoip_databases                          vUT-OB0YTY-WjqjDr95oPA   1   0         43            0     40.7mb         40.7mb
green  open   .monitoring-kibana-7-2021.09.21           pMKo8ZPFSBaes0QfEXHifQ   1   0      17278            0      2.6mb          2.6mb
...

List only metricbeat-* indices:

$ curl -u elastic:changeme -XGET 'localhost:9200/_cat/indices/metricbeat-*?v&pretty'
health status index                               uuid                   pri rep docs.count docs.deleted store.size pri.store.size
yellow open   metricbeat-7.15.1-2021.09.26-000001 PNBbCURlQ2CoAkOxlBkF0g   1   1      37627            0     38.1mb         38.1mb

> By default, the system module is enabled. The information it collects, however, is not shown on the Monitoring page in Kibana. Unless you want to use that information for other purposes, run the following command:

Source: https://www.elastic.co/guide/en/kibana/current/monitoring-metricbeat.html

These dashboards show data:

- `[Metricbeat System] Overview ECS`
- `[Metricbeat System] Host overview ECS`
  - `host.name:"tschaffter-htpc"`

