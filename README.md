Deploy a Strapi application on AWS using ECS Fargate, managed entirely via Terraform and Automate via Github Actions [ci/cd] and   Add CloudWatch for Monitoring (Logging & Metrics):


🎥 **Demo Video (Loom)**:  
https://www.loom.com/share/ba9f03881a864684b330ef9103901860?sid=63622522-200b-47c1-a0e4-354e1242f5b7

Step 1: Set Up Your Strapi Application with Terraform on AWS ECS Fargate
Explanation:
ECS Fargate is a serverless compute engine for containers that lets you run containers without managing the underlying servers.

Terraform will be used to define the infrastructure, including ECS, networking, and security groups, to deploy the Strapi application on AWS Fargate.

Step 1: Configure Terraform for ECS Fargate
Create ECS Task Definition in ecs.tf: Define an ECS task that references the Docker image to be used for Strapi.

Step 2:Define ECS Cluster in ecs.tf.

step 3: Create Security Group for ECS Service in iam.tf.

Step 4.Create ECS Service in ecs.tf.

Step 5. Configure CloudWatch Monitoring
             CloudWatch Log Group in ecs.tf.
             CloudWatch Metric Alarm for High CPU in ecs.tf.

Step 6: Create CI/CD Pipeline Using GitHub Actions			 
.

Step 6: Ensure AWS credentials are set up in GitHub Secrets:

AWS_ACCESS_KEY_ID

AWS_SECRET_ACCESS_KEY

AWS_REGION

ECR_REPOSITORY (ECR repo URI)

Step 7: Initialize Terraform and Deploy the Infrastructure

+------------------+        +-----------------------+        +---------------------+
|  GitHub Actions | -----> | Build Docker Image and | -----> | Push Docker Image   |
|  (CI/CD Trigger) |        |  Push to ECR           |        | to AWS ECR          |
+------------------+        +-----------------------+        +---------------------+
            |                           |
            v                           v
    +-------------------+     +--------------------------+      +-------------------+
    | Terraform Apply   | --> | Deploy to ECS Fargate    | --> | ECS Service Running |
    | (Provision AWS Resources) | (Create ECS Task, Service) |    | with Strapi App    |
    +-------------------+     +--------------------------+      +-------------------+
            |
            v
   +-------------------------+
   | Monitor via CloudWatch  |
   | (Logs, Metrics, Alarms) |
   +-------------------------+

In Task 7, we have successfully:

Set up AWS ECS Fargate to run a Strapi application.

Used Terraform to define the infrastructure as code.

Configured CloudWatch monitoring (logs, metrics, and alarms).

Automated the deployment using GitHub Actions for CI/CD.

🙌 Author
Made with ❤️ by Shashikumar
Intern @ PearlThoughts 🚀
