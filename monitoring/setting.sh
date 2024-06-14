# helm에 prometheus-community repository 추가
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# helm을 이용해서 prometheus stack 설치하기
helm install prometheus prometheus-community/kube-prometheus-stack -n <namespace>