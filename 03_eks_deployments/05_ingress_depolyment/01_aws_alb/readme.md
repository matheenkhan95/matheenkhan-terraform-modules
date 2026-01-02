 308  cd 03_cni_deployments/
  309  terraform init
  310  terraform apply -auto-approve
  311  cd ../05_ingress_deplyment/
  312  cd 01_aws_alb/
  313  history
  314  history | grep -i eks update
  315  history | grep -i eks
  316  aws eks --region us-east-1 update-kubeconfig --name my-eks-cluster-development
  317  terraform init
  318  terraform apply -auto-approve
  319  history
  320  eksctl utils associate-iam-oidc-provider   --region us-east-1   --cluster my-eks-cluster-development   --approve
  321  terraform apply -auto-approve
  322  history

# 1. Install Helm (choose only ONE method depending on your setup)
choco install kubernetes-helm              # For Chocolatey users (Windows)
scoop install helm                         # For Scoop users (Windows)
winget install Helm.Helm                   # For Winget users (Windows)
# OR manually download and setup:
HELM_VERSION="v3.14.4"
curl -LO https://get.helm.sh/helm-${HELM_VERSION}-windows-amd64.zip
unzip helm-${HELM_VERSION}-windows-amd64.zip
mkdir -p /d/Terrafrom/00_Software/helm
mv windows-amd64/helm.exe /d/Terrafrom/00_Software/helm/
echo 'export PATH=$PATH:/d/Terrafrom/00_Software/helm' >> ~/.bashrc
source ~/.bashrc

# 2. Verify Helm is working
helm version

# 3. Add Helm repo for AWS Load Balancer Controller
helm repo remove eks || true                          # Clean up if exists
helm repo add eks https://aws.github.io/eks-charts    # Add the repo
helm repo update                                      # Update Helm repos

# 4. (Optional) Verify chart is available
helm search repo eks/aws-load-balancer-controller

# 5. Run Terraform to deploy AWS Load Balancer Controller
cd /e/10_cka_tasks/12_vpc_deployment_locals_for/02_deployments/05_ingress_deplyment/01_aws_alb
terraform init
terraform apply -auto-approve
