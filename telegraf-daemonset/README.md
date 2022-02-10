1. Install telegraf-operator

oc apply -f https://raw.githubusercontent.com/influxdata/telegraf-operator/master/deploy/dev.yml 


2. Create sample set of classes

oc apply -f https://raw.githubusercontent.com/influxdata/telegraf-operator/master/examples/classes.yml


3. Set up InfluxDB 

oc delete -f https://raw.githubusercontent.com/influxdata/telegraf-operator/master/deploy/influxdb.yml 
oc apply -f https://raw.githubusercontent.com/influxdata/telegraf-operator/master/deploy/influxdb.yml 

oc adm policy add-scc-to-user anyuid -z default -n influxdb

oc get pod -n influxdb
oc delete pod <influxdb-58f49c98c6-tcjkk>  -n influxdb
oc logs <nginx-deamon-5wnbk> -c telegraf -n test


4. Create Deployment, DaemonSet & StatefulSet annotated to deploy sidecar container

create namespace test

oc adm policy add-scc-to-user anyuid -z default -n test
oc adm policy remove-scc-from-user anyuid -z default -n test
oc adm policy add-scc-to-user privileged -z default -n test

oc apply -f clusterrolebinding.yml -n test
oc apply -f deployment.yml -n test
oc apply -f daemonset.yml -n test 
oc apply -f statefulset.yml -n test


5. Access Chronograf from your browser

kubectl port-forward --namespace=influxdb svc/influxdb 8888:8888


---

https://docs.influxdata.com/telegraf/v1.21/plugins/#system 
https://docs.influxdata.com/telegraf/v1.21/plugins/#cpu 
https://docs.influxdata.com/telegraf/v1.21/plugins/#mem 
https://docs.influxdata.com/telegraf/v1.21/plugins/#swap 
https://docs.influxdata.com/telegraf/v1.21/plugins/#disk 
https://docs.influxdata.com/telegraf/v1.21/plugins/#diskio 
https://docs.influxdata.com/telegraf/v1.21/plugins/#linux_sysctl_fs  
https://docs.influxdata.com/telegraf/v1.21/plugins/#net 
https://docs.influxdata.com/telegraf/v1.21/plugins/#bond 
https://docs.influxdata.com/telegraf/v1.21/plugins/#netstat 
https://docs.influxdata.com/telegraf/v1.21/plugins/#iptables 
https://docs.influxdata.com/telegraf/v1.21/plugins/#chrony   *******
https://docs.influxdata.com/telegraf/v1.21/plugins/#dns_query 
https://docs.influxdata.com/telegraf/v1.21/plugins/#processes 
https://docs.influxdata.com/telegraf/v1.21/plugins/#procstat 
https://github.com/influxdata/telegraf/tree/release-1.5/plugins/inputs/jolokia2   *******
https://docs.influxdata.com/telegraf/v1.21/plugins/#nvidia_smi 
https://docs.influxdata.com/telegraf/v1.21/plugins/#filestat 
https://docs.influxdata.com/telegraf/v1.21/plugins/#filecount
https://docs.influxdata.com/telegraf/v1.21/plugins/#file 
https://docs.influxdata.com/telegraf/v1.21/plugins/#snmp 
https://docs.influxdata.com/telegraf/v1.21/plugins/#x509_cert
https://docs.influxdata.com/telegraf/v1.21/plugins/#kube_inventory 
https://docs.influxdata.com/telegraf/v1.21/plugins/#kubernetes 


217 / 524

---------------------------------------------------------------

--- SCC 

oc adm policy add-scc-to-user privileged -z default -n monitoring

--- SC

    spec:
      containers:
      - name: telegraf
        image: docker.io/telegraf:1.5.2
        securityContext:
          privileged: true

---

kubectl create secret generic grafana-creds --from-literal=GF_SECURITY_ADMIN_USER=admin --from-literal=GF_SECURITY_ADMIN_PASSWORD=admin123