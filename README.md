### Blue-Green Deployment with AWS CodeDeploy, ECR, and ECS: Documentation

This documentation outlines the steps involved in setting up a Blue-Green deployment for an application running on AWS ECS using Docker images stored in Amazon ECR. The objective is to create a seamless deployment pipeline using AWS services like CodeDeploy and ECS, allowing for minimal downtime and easy rollback in case of failure.

#### **1. Objective**
To deploy an application (Strapi) on AWS ECS using a Blue-Green deployment strategy, where:
- **Blue environment**: The currently running version of the application in production.
- **Green environment**: The new version of the application, deployed and tested before making it live.

The deployment is carried out using **AWS CodeDeploy** and **Amazon ECS** with Docker images pulled from **Amazon ECR**.

#### **2. Prerequisites**
- An **AWS Account** with permissions to create and manage ECS, CodeDeploy, IAM, and S3 resources.
- **Docker** installed on your local machine for building and testing the Docker images.
- An **AWS IAM Role** that CodeDeploy can assume.
- **Amazon ECR** repository containing the Docker image (`strapi-app`).

#### **3. Deployment Process**
1. **Set Up ECS Cluster and Services**
   - Create an **ECS Cluster** (e.g., `strapi-cluster`).
   - Create a **Service** (e.g., `strapi-service`) in the ECS cluster, with the Docker image pulled from Amazon ECR.

2. **Create a CodeDeploy Application and Deployment Group**
   - Create a CodeDeploy application and define the deployment group with ECS services.
   - Assign an IAM role to allow CodeDeploy to interact with ECS resources.

3. **Define CodeDeploy AppSpec File**
   - An **AppSpec file** is a YAML file used by CodeDeploy to specify the deployment steps.
   - **AppSpec content for ECS**:
     ```yaml
     version: 0.0
     Resources:
       - TargetService:
           Type: AWS::ECS::Service
           Properties:
             TaskDefinition: !Ref TaskDefinition
             LoadBalancerInfo:
               ContainerName: strapi-container
               ContainerPort: 80
     ```

4. **Upload Artifacts to S3**
   - Upload the **AppSpec file** and other required files (e.g., Docker image or Task Definition) to **S3**.

5. **Create Deployment**
   - Use **AWS CLI** to trigger a deployment to the ECS cluster, updating the service to use the latest task definition.
   - Ensure CodeDeploy updates ECS services using the **Blue-Green deployment** method.

   Command for triggering deployment:
   ```bash
   aws deploy create-deployment \
     --application-name strapi-app \
     --deployment-group-name strapi-deploy-group \
     --revision revisionType=S3,s3Location={bucket="strapi-deployments-bucket",key="appspec.yaml",bundleType=YAML} \
     --description "Blue-Green Deployment"
   ```

#### **4. Official Documentation Links**
- **AWS CodeDeploy User Guide**: [AWS CodeDeploy Documentation](https://docs.aws.amazon.com/codedeploy/latest/userguide/welcome.html)
- **AWS ECS User Guide**: [Amazon ECS Documentation](https://docs.aws.amazon.com/ecs/latest/userguide/what-is-fargate.html)
- **Amazon ECR User Guide**: [Amazon ECR Documentation](https://docs.aws.amazon.com/AmazonECR/latest/userguide/what-is-ecr.html)
- **IAM Role for ECS and CodeDeploy**: [AWS IAM Documentation](https://docs.aws.amazon.com/IAM/latest/UserGuide/)
- **Blue/Green Deployment**: [Blue-Green Deployment on AWS](https://aws.amazon.com/blogs/devops/blue-green-deployment-using-aws-codedeploy/)

#### **5. Common Errors and Troubleshooting**

1. **ApplicationDoesNotExistException**
   - **Error**: `An error occurred (ApplicationDoesNotExistException) when calling the CreateDeployment operation: No application found for name: strapi-app`
   - **Cause**: This error occurs if the CodeDeploy application has not been created yet.
   - **Solution**: Create the application using the command:
     ```bash
     aws deploy create-application --application-name strapi-app --compute-platform ECS
     ```

2. **InvalidRoleException (CodeDeploy does not have permissions)**
   - **Error**: `AWS CodeDeploy does not have the permissions required to assume the role arn:aws:iam::118273046134:role/CodeDeployECSServiceRole`
   - **Cause**: This happens when CodeDeploy does not have the necessary permissions to assume the role for ECS deployment.
   - **Solution**: Update the IAM role with the correct trust policy to allow CodeDeploy to assume the role. Use the following policy:
     ```bash
     aws iam update-assume-role-policy \
       --role-name CodeDeployECSServiceRole \
       --policy-document '{
         "Version": "2012-10-17",
         "Statement": [
           {
             "Effect": "Allow",
             "Principal": {
               "Service": "codedeploy.amazonaws.com"
             },
             "Action": "sts:AssumeRole"
           }
         ]
       }'
     ```

3. **AccessDenied for `UpdateAssumeRolePolicy`**
   - **Error**: `User: arn:aws:iam::118273046134:user/ShashiKumar is not authorized to perform: iam:UpdateAssumeRolePolicy on resource: role CodeDeployECSServiceRole`
   - **Cause**: The IAM user does not have the required permissions to update the IAM role.
   - **Solution**: Ensure that the IAM user has the `iam:UpdateAssumeRolePolicy` permission or use an IAM user with sufficient permissions.

4. **NoSuchBucket Error**
   - **Error**: `The user-provided path appspec.yaml does not exist`
   - **Cause**: This error occurs when the file path for the `appspec.yaml` is incorrect or missing.
   - **Solution**: Ensure the file exists at the correct path and is uploaded to the correct S3 bucket.

5. **Docker Image Not Found in ECR**
   - **Error**: `failed to solve: failed to read dockerfile: open Dockerfile: no such file or directory`
   - **Cause**: The Dockerfile is missing or incorrect in your local environment.
   - **Solution**: Ensure the Dockerfile exists and is located in the project directory or pull the image from the correct ECR repository.

6. **Deployment Rejected**
   - **Error**: `error: failed to push some refs to 'https://github.com/your-repo'`
   - **Cause**: Local changes have not been committed or the remote repository is out of sync.
   - **Solution**: Perform a `git pull` to fetch remote changes, resolve conflicts, and then push the changes again.

#### **6. Final Steps**
- **Testing**: After deployment, test the application to ensure that the Green environment is functioning correctly.
- **Rollback**: If the deployment fails, switch back to the Blue environment using the CodeDeploy or ECS console.

### Conclusion
Blue-Green deployment is a powerful strategy to ensure minimal downtime during deployments and enables easy rollback in case of issues. By leveraging AWS CodeDeploy and ECS with ECR Docker images, we can achieve seamless, zero-downtime deployments while minimizing risk.

