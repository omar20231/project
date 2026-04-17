<img width="500" height="400" alt="Image" src="https://github.com/user-attachments/assets/b4e2f946-f0bf-4a84-8187-162ee0d6b3ea" />
<h1>Architecture</h1>
<p>File structure</p>

```text
ecs/
├── .github/workflows
│ ├── apply.yml
│ ├── check.yml
│ ├── push.yml
│ └── reuse.yml
│
│
├── ecs-assignment/
│ ├──Dockerfile
│ ├──.dockerignore
│ ├──yarn.lock
│
│
├── infra/
│ ├── modules/
│ │ ├── ACM/
│ │ │ ├── ACM.tf
│ │ │ ├── outputs.tf
│ │ │ └── variables.tf
│ │ ├── ALB/
│ │ │ ├── ALB.tf
│ │ │ ├──outputs.tf
│ │ │ ├── terraform.tfvars
│ │ │ └── variable.tf
│ │ ├── ecs/
│ │ │ ├── ecs.tf
│ │ │ ├── terraform.tfvars
│ │ │ ├── variables.tf
│ │ ├── IAM/
│ │ │ ├── IAM.tf
│ │ │ └── variables.tf
│ │
│ ├── main.tf
│ ├── outputs.tf
│ ├── prov.tf
│ ├── terraform.tfvars
│ └── variables.tf
│
├── .gitignore
└── README.md
```



<p>In this project I’ve built and deployed an end-to-end containerised application on AWS with CI/CD automation.

I used Docker to containerise my app and used multi-stage image to make it lightweight. The reason why you would use containers is to facilitates your application to run in any environment. It does this by bundling all the dependencies such as ports, code and anything you need for the application in the same container.</p>

<p>After this we used AWS cloud to build an infrastructure:</p>

- VPC (Virtual Private Cloud)
- ECR (Elastic Container Registry)
- ECS (Elastic Container Service)
- Subnets
- Internet Gateway (IGW)
- Route 53
- AWS Certificate Manager
- IAM (Identity and Access Management)
- Security Groups

<p>I built AWS infrastructure using Terraform (Infrastructure as Code). This deploys services as code and never re-deploys anything that’s already running. This is because of Terraform state file.
Terraform state file is a record of your current infrastructure and shows how many resources there is. Terraform will never re-deploy the same state file, this ensures idempotency.</p>

<p>With the help of CI/CD, I automated this whole process. There are different tools such as Github Actions, Jenkins, Gitlab CI and etc.
This tool is used automates software releases, ensuring new features, updates are released with minimal risk. This helps the developer to be efficient, reliable and speeds up the processes.</p>
