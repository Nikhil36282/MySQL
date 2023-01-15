


Pulling PMM server image
=========================
docker pull percona/pmm-server:2

Create volume for PMM
===========================
docker volume create pmm-data


Make container of PMM Server
===========================
docker run --detach --restart always \
--publish 443:443 \
-v pmm-data:/srv \
--name pmm-server \
--net my_network \
percona/pmm-server:2


Create Network for docker container connectivity
===============================================
docker  network create my_network

Change Password for PMM Server UI
=================================
docker exec -t pmm-server bash -c 'grafana-cli --homepath /usr/share/grafana --configOverrides cfg:default.paths.data=/srv/grafana admin reset-admin-password newpass'

PMM UI
================================
https://localhost:443

Check version of PMM
===================
curl -ku admin:admin https://localhost/v1/version


Make PMM client container
===============================
PMM_SERVER=172.18.0.2:443
docker run \
--rm \
--name pmm-client \
-e PMM_AGENT_SERVER_ADDRESS=${PMM_SERVER} \
-e PMM_AGENT_SERVER_USERNAME=admin \
-e PMM_AGENT_SERVER_PASSWORD=admin \
-e PMM_AGENT_SERVER_INSECURE_TLS=1 \
-e PMM_AGENT_SETUP=1 \
-e PMM_AGENT_CONFIG_FILE=config/pmm-agent.yaml \
--volumes-from pmm-client-data \
--net my_network \
percona/pmm-client:2


Add Mysql to PMM Server
===========================


