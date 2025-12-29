 1  curl -LO https://dl.k8s.io/release/v1.32.0/bin/linux/arm64/kubectl
    2  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    3  chmod +x kubectl
    4  mkdir -p ~/.local/bin
    5  mv ./kubectl ~/.local/bin/kubectl
    6  kubectl version --client
    7  ls -la ~/.local/bin/kubectl
    8  kubectl version
    9  rm -rf  ~/.local/bin/kubectl
   10     curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/v1.32.0)/bin/linux/arm64/kubectl"
   11  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/v1.32.0/bin/linux/arm64/kubectl"
   12   curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/v1.32.0/bin/linux/arm64/kubectl"
   13  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/v1.32.0)/bin/linux/arm64/kubectl"
   14  uname -m
   15  curl -LO "https://dl.k8s.io/release/curl -LO https://dl.k8s.io/release/v1.32.0/bin/linux/amd64/kubectl
   16  /bin/linux/amd64/kubectl"
   17  curl -LO "https://dl.k8s.io/release/v1.32.0/bin/linux/amd64/kubectl"
   18  chmod +x kubectl
   19  sudo mv kubectl /usr/local/bin/kubectl
   20  kubectl version
   21  aws configure
   22  aws configure
   23  aws sts get-caller-identity
   24  aws eks update-kubeconfig --region us-east-1 --name dev-cluster-development
   25  kubectl config get-contexts
   26  kubectl config current-context
   27  kubectl get nodes
   28  aws eks describe-cluster --name dev-cluster-development --region us-east-1 --query "cluster.status"
   29  aws eks describe-cluster --name dev-cluster-development --region us-east-1 --query "cluster.status"
   30  aws eks describe-cluster --name dev-cluster-development --region us-east-1 --query "cluster.status"
   31  aws eks describe-cluster --name dev-cluster-development --region us-east-1 --query "cluster.resourcesVpcConfig.endpointPublicAccess"
   32  aws eks describe-cluster --name dev-cluster-development --region us-east-1 --query "cluster.resourcesVpcConfig.vpcId"
   33  curl -k https://9261F07E9E2E52E166FBD9FAAA3680B1.yl4.us-east-1.eks.amazonaws.com/version
   34  curl -k https://9261F07E9E2E52E166FBD9FAAA3680B1.yl4.us-east-1.eks.amazonaws.com/version
   35  aws eks describe-cluster --name dev-cluster-development --region us-east-1 --query "cluster.resourcesVpcConfig.endpointPublicAccess"
   36  aws sts get-caller-identity
   37  aws eks list-clusters --region us-east-1
   38  aws iam get-user
   39  aws iam list-attached-user-policies --user-name cloud_user
   40  aws iam get-policy --policy-arn arn:aws:iam::637423456632:policy/allow_all
   41  aws iam get-policy-version --policy-arn arn:aws:iam::637423456632:policy/allow_all --version-id v1
   42  aws iam get-policy --policy-arn arn:aws:iam::637423456632:policy/Playground_AWS_Sandbox
   43  aws iam attach-user-policy --user-name cloud_user --policy-arn arn:aws:iam::aws:policy/AmazonEKSClusterPolicy
   44  aws ec2 describe-instances
   45  aws ec2 describe-instances --instance-ids <instance-id>
   46  aws ec2 describe-instances --instance-ids i-0a0ee959b17b4317a
   47  aws ec2 describe-instances --instance-ids i-0a0ee959b17b4317a | grep -i IamInstanceProfile
   48  aws ec2 describe-instances --instance-ids i-0a0ee959b17b4317a
   49  ls -la
   50  cd ec2-user/
   51  ls -la
   52  cd ..
   53  cd ..
   54  cd root/
   55  ls -la
   56  cd .kube/
   57  ls -la
   58  rm -rf cache
   59  cat config
   60  cd ..
   61  kubectl get nodes
   62  kubectl config view
   63  kubectl get nodes
   64  aws eks describe-cluster
   65  aws eks describe-cluster --name dev-cluster-development
   66  aws eks describe-cluster --name dev-cluster-development --query 'cluster.resourcesVpcConfig''
   67  cd ..
   68  cd
   69  ls -la
   70  cd .kube/
   71  ls -la
   72  cat config
   73  kubectl get nodes
   74  history
   75  aws eks update-kubeconfig --region us-east-1 --name dev-cluster-development
   76  aws eks describe-cluster --name dev-cluster-development --query 'cluster.resourcesVpcConfig'
   77  kubectl get nodes
   78  history
