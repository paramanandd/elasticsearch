#!/bin/bash
apt update -y
apt-get install openjdk-8-jdk -y
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
apt-get install apt-transport-https -y
echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-5.x.list
apt-get update && apt-get install elasticsearch -y
echo 'network.host: 0.0.0.0' >> /etc/elasticsearch/elasticsearch.yml
/bin/systemctl daemon-reload
/bin/systemctl enable elasticsearch.service
systemctl start elasticsearch.service
apt install kibana -y
echo 'server.host: 0.0.0.0' >> /etc/kibana/kibana.yml
echo 'elasticsearch.url: "http://localhost:9200"' >> /etc/kibana/kibana.yml
systemctl enable kibana
systemctl start kibana