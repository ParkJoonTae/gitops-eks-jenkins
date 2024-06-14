# 하단 명령어 실행 전 alb controller policy 생성 할 것
# cluster-name: cluster name of eks
# policy-arn: alb-controller-policy arn you made by terraform code
eksctl create iamserviceaccount \
  --name alb-iamserviceaccount \
  --namespace kube-system \
  --cluster pjt-eks \
  --attach-policy-arn arn:aws:iam::934964956331:policy/pjt-alb-controller-policy \
  --approve \
  --override-existing-serviceaccounts

# Helm Chart를 이용하여 alb-ingress-controller를 배포
# cluster-name은 자신이 사용중인 cluster-name을 입력
# 적용 전에 alb-controller의 버전과 eks 버전의 호환성을 확인 (eks 1.29 <-> alb v2.7.2)
helm repo add eks https://aws.github.io/eks-charts
helm repo update eks
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
     --set clusterName=pjt-eks \
     --set serviceAccount.create=false \
     --set serviceAccount.name=alb-iamserviceaccount \
     --set image.repository=amazon/aws-alb-ingress-controller \
     --set image.tag=v2.7.2 \
     --set extraArgs={--cloud-provider=aws} \
     -n kube-system