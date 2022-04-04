oc project test
oc adm policy add-cluster-role-to-user cluster-monitoring-view -z grafana-serviceaccount
oc serviceaccounts get-token grafana-serviceaccount
