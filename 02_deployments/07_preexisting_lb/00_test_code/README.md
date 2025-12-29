 260  kubectl get pods -o wide
  261  aws elbv2 register-targets   --target-group-arn arn:aws:elasticloadbalancing:us-east-1:891377015964:targetgroup/nginx-precreated-tg/ce53a05945c89abf   --targets Id=10.1.10.93 Id=10.1.12.28
  262  aws elbv2 register-targets   --target-group-arn arn:aws:elasticloadbalancing:us-east-1:891377015964:targetgroup/nginx-precreated-tg/ce53a05945c89abf   --targets Id=10.1.10.93 Id=10.1.12.28
  263  aws elbv2 describe-target-groups   --target-group-arns arn:aws:elasticloadbalancing:us-east-1:891377015964:targetgroup/nginx-precreated-tg/ce53a05945c89abf   --query 'TargetGroups[*].TargetType'
  264  aws ec2 describe-instances   --filters "Name=private-ip-address,Values=10.1.10.93,10.1.12.28"   --query 'Reservations[*].Instances[*].InstanceId'   --output text
  265  aws elbv2 register-targets   --target-group-arn arn:aws:elasticloadbalancing:us-east-1:891377015964:targetgroup/nginx-precreated-tg/ce53a05945c89abf   --targets Id=i-0b77621722c902919 Id=i-03bf32b42713591f9
  266  kubectl get pods -o wide
  267  kubectl get pods -n ingress-nginx -o wide
  268  terraform apply -auto-approve
  269  kubectl get pods -n ingress-nginx -o wide
  270  kubectl delete deployment http-echo
  271  kubectl delete svc http-echo
  272  cd ../00_test_code/
  273  kubectl apply -f 01_app_deployment.yaml
  274  kubectl apply -f 03_ingress_res.yaml
  275  history