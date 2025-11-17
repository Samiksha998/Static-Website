pipeline {
    agent any

    environment {
        KUBECONFIG = "/var/lib/jenkins/.kube/config"
        IMAGE_NAME = "samikshav/static-website:latest"
        AWS_REGION = "us-east-1"
        CLUSTER_NAME = "mycluster"
    }

    stages {

        /* ----------------------------
           1. CHECKOUT CODE
        ----------------------------- */
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Samiksha998/Static-Website.git', branch: 'main'
            }
        }

        /* ----------------------------
           2. BUILD & PUSH DOCKER IMAGE
        ----------------------------- */
        stage('Build & Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS')]) {

                        sh '''
                        echo "=== Logging in to Docker Hub ==="
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin

                        echo "=== Building Docker Image ==="
                        docker build -t $IMAGE_NAME $WORKSPACE

                        echo "=== Pushing Docker Image ==="
                        docker push $IMAGE_NAME

                        docker logout
                        '''
                    }
                }
            }
        }

        /* ----------------------------
           3. SETUP KUBECONFIG & AWS CREDS
        ----------------------------- */
        stage('Setup kubeconfig for Jenkins') {
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'aws-creds']]) {

                        sh '''
                        echo "=== Updating kubeconfig from EKS ==="
                        aws eks update-kubeconfig \
                            --region $AWS_REGION \
                            --name $CLUSTER_NAME \
                            --kubeconfig $KUBECONFIG

                        echo "=== Test EKS Connectivity ==="
                        kubectl get nodes --kubeconfig=$KUBECONFIG
                        '''
                    }
                }
            }
        }

        /* ----------------------------
           4. DEPLOY TO KUBERNETES
        ----------------------------- */
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'aws-creds']]) {

                        sh '''
                        echo "=== Applying Deployment & Service Manifests ==="
                        kubectl apply -f $WORKSPACE/kubernetes/app-deploy.yaml --kubeconfig=$KUBECONFIG
                        kubectl apply -f $WORKSPACE/kubernetes/app-service.yaml --kubeconfig=$KUBECONFIG

                        echo "=== Updating Deployment Image ==="
                        kubectl set image deployment/static-website-app \
                            web=$IMAGE_NAME --namespace=default --kubeconfig=$KUBECONFIG

                        echo "=== Waiting for Rollout ==="
                        kubectl rollout status deployment/static-website-app \
                            -n default --kubeconfig=$KUBECONFIG
                        '''
                    }
                }
            }
        }

        /* ----------------------------
           5. DELETE LOAD BALANCER (NEW)
        ----------------------------- */
        stage('Delete Load Balancer') {
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'aws-creds']]) {

                        sh '''
                        echo "=== Fetching LoadBalancer Info ==="
                        LB_ARN=$(aws elbv2 describe-load-balancers \
                            --region $AWS_REGION \
                            --query "LoadBalancers[?starts_with(DNSName, 'a')].LoadBalancerArn" \
                            --output text)

                        echo "Found LB ARN: $LB_ARN"

                        if [ "$LB_ARN" != "None" ] && [ -n "$LB_ARN" ]; then
                            echo "=== Deleting Kubernetes Service ==="
                            kubectl delete svc static-website-service --kubeconfig=$KUBECONFIG || true

                            echo "=== Deleting AWS Load Balancer ==="
                            aws elbv2 delete-load-balancer \
                                --load-balancer-arn $LB_ARN \
                                --region $AWS_REGION

                            echo "Waiting for LB deletion..."
                            sleep 40

                            echo "=== Deleting Target Groups ==="
                            TG_ARNS=$(aws elbv2 describe-target-groups \
                                --region $AWS_REGION \
                                --query "TargetGroups[*].TargetGroupArn" --output text)

                            for TG in $TG_ARNS; do
                                echo "Deleting Target Group: $TG"
                                aws elbv2 delete
