- name: Build and Push Docker image to ECR
  run: |
    docker build -t $ECR_REPO:$IMAGE_TAG .
    docker tag $ECR_REPO:$IMAGE_TAG ${{ secrets.ECR_REGISTRY }}/$ECR_REPO:$IMAGE_TAG
    docker push ${{ secrets.ECR_REGISTRY }}/$ECR_REPO:$IMAGE_TAG
