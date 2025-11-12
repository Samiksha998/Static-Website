# Kubernetes Manifests Removed

This folder previously contained Kubernetes deployment manifests, but the repository has been simplified to focus on the static website core files.

If you need Kubernetes deployment, re-create focused Deployment and Service manifests.

Expected output:
```
deployment.apps/static-website-app created
```

### 3. Apply Service

```bash
kubectl apply -f app-service.yaml
```

Expected output:
```
service/static-website-service created
```

### 4. Verify Deployment

Check deployment status:
```bash
kubectl get deployments
```

Expected output:
```
NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
static-website-app        2/2     2            2           10s
```

### 5. Verify Pods

```bash
kubectl get pods -l app=static-website
```

Expected output (example):
```
NAME                                    READY   STATUS    RESTARTS   AGE
static-website-app-6d8b7f4c8f-abc12    1/1     Running   0          10s
static-website-app-6d8b7f4c8f-def45    1/1     Running   0          8s
```

### 6. Verify Service

```bash
kubectl get svc static-website-service
```

Expected output:
```
NAME                        TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
static-website-service      NodePort   10.96.123.45   <none>        8080:30080/TCP   10s
```

## Accessing the Application

### On Minikube (Local Development)

1. **Get Minikube IP**:
   ```bash
   minikube ip
   # Example output: 192.168.49.2
   ```

2. **Access Application**:
   ```
   http://192.168.49.2:30080/
   http://192.168.49.2:30080/login.html
   ```

3. **Direct Port Forward (Alternative)**:
   ```bash
   kubectl port-forward service/static-website-service 8080:8080
   # Then access: http://localhost:8080
   ```

### On Amazon EKS (Production)

1. **Get Worker Node Public IP**:
   ```bash
   kubectl get nodes -o wide
   ```

2. **Access Application**:
   ```
   http://<WORKER_NODE_PUBLIC_IP>:30080/
   ```

3. **Using Load Balancer (Optional)**:
   - Change Service type to `LoadBalancer`
   - AWS will create a load balancer automatically
   - Access via the load balancer DNS name

### On Other Cloud Providers

- **GKE**: Get external IP of any node
- **AKS**: Get public IP of any node
- **Digital Ocean**: Use Load Balancer service type

## Monitoring and Troubleshooting

### View Deployment Logs

```bash
# Logs from all pods
kubectl logs -l app=static-website --tail=50 -f

# Logs from specific pod
kubectl logs <pod-name>

# Logs with timestamps
kubectl logs <pod-name> --timestamps=true
```

### Describe Resources

```bash
# Deployment details
kubectl describe deployment static-website-app

# Pod details
kubectl describe pod <pod-name>

# Service details
kubectl describe service static-website-service
```

### Check Pod Events

```bash
kubectl get events
kubectl describe pod <pod-name> | grep -A 10 Events
```

### Test Connectivity

From any pod:
```bash
kubectl exec -it <pod-name> -- bash
# Inside the container:
curl http://localhost:8080/
```

## Self-Healing Demonstration

### Delete a Pod (Auto-Restart)

```bash
# Get pod name
kubectl get pods -l app=static-website

# Delete one pod
kubectl delete pod <pod-name>

# Watch it auto-restart
kubectl get pods -l app=static-website -w
```

You should see:
1. Pod status changes to `Terminating`
2. Pod disappears from list
3. A new pod is created with a new name
4. New pod initializes (Pending → Running)
5. After ~30 seconds, becomes fully ready

**The replica count stays at 2** - Kubernetes automatically created a replacement!

### Simulate Node Failure

```bash
# Watch pod movements
kubectl get pods -l app=static-website -o wide -w

# In another terminal, simulate node drain
kubectl drain <node-name> --ignore-daemonsets --delete-emptydir-data

# Pods will move to other nodes automatically
```

## Scaling the Application

### Increase Replicas

```bash
# Scale to 5 replicas
kubectl scale deployment static-website-app --replicas=5

# Verify
kubectl get pods -l app=static-website --no-headers | wc -l
# Output: 5
```

### Decrease Replicas

```bash
# Scale back to 2
kubectl scale deployment static-website-app --replicas=2
```

### Auto-Scaling with HPA (Horizontal Pod Autoscaler)

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: static-website-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: static-website-app
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

Apply HPA:
```bash
kubectl apply -f hpa.yaml
```

## Rolling Updates

### Update Image Version

```bash
# Update deployment to use new image
kubectl set image deployment/static-website-app \
  static-website=samikshav/app:v2 \
  --record

# Watch rollout progress
kubectl rollout status deployment/static-website-app
```

### Rollback on Issues

```bash
# View rollout history
kubectl rollout history deployment/static-website-app

# Rollback to previous version
kubectl rollout undo deployment/static-website-app

# Rollback to specific revision
kubectl rollout undo deployment/static-website-app --to-revision=1
```

## Cleanup

### Delete Service

```bash
kubectl delete service static-website-service
```

### Delete Deployment

```bash
kubectl delete deployment static-website-app
```

### Delete Everything at Once

```bash
kubectl delete -f app-deploy.yaml -f app-service.yaml

# Or by label
kubectl delete all -l app=static-website
```

### Delete Namespace (if created)

```bash
kubectl delete namespace production
```

## Best Practices

1. **Health Checks**: Always define liveness and readiness probes
2. **Resource Limits**: Set CPU and memory requests/limits
3. **Rolling Updates**: Use rolling update strategy for zero downtime
4. **Pod Affinity**: Distribute pods across nodes
5. **Graceful Shutdown**: Set terminationGracePeriodSeconds
6. **Labels**: Use consistent labeling for management
7. **Namespaces**: Isolate applications in namespaces
8. **Monitoring**: Use Prometheus, Grafana, or cloud provider tools

## Advanced: Using Helm Charts

For production deployments, create a Helm chart:

```bash
helm create static-website
# Edit values.yaml for configuration
helm install static-website ./static-website
helm upgrade static-website ./static-website
helm rollback static-website
```

## Environment-Specific Deployments

### Development (Minikube)
```bash
kubectl apply -f app-deploy.yaml -f app-service.yaml
```

### Staging (EKS)
```bash
kubectl apply -f app-deploy.yaml -f app-service.yaml -n staging
```

### Production (EKS with advanced settings)
- Use namespaces
- Enable network policies
- Use LoadBalancer service type
- Configure auto-scaling
- Set resource quotas per namespace

## Useful kubectl Commands

```bash
# Get resources
kubectl get deployment,svc,pods

# Watch resources
kubectl get pods -w

# Describe resources
kubectl describe pod <pod-name>

# View logs
kubectl logs <pod-name> -f

# Execute commands in pod
kubectl exec -it <pod-name> -- bash

# Port forwarding
kubectl port-forward pod/<pod-name> 8080:8080

# Edit resources
kubectl edit deployment static-website-app

# Delete resources
kubectl delete -f app-deploy.yaml

# Apply changes
kubectl apply -f app-deploy.yaml
```

## Troubleshooting Common Issues

### Pods Not Starting

```bash
# Check pod status
kubectl describe pod <pod-name>

# Check events
kubectl get events --sort-by='.lastTimestamp'

# Check node resources
kubectl top nodes
kubectl top pods
```

### Image Pull Errors

```bash
# Verify image exists
docker pull samikshav/app:v1

# Check image pull policy
kubectl describe pod <pod-name> | grep ImagePullPolicy
```

### Network Issues

```bash
# Test DNS
kubectl run -it --rm debug --image=alpine -- sh
# nslookup static-website-service

# Test connectivity
kubectl exec -it <pod-name> -- curl http://localhost:8080/
```

### Pending Pods

```bash
# Check resource availability
kubectl describe node

# Check for persistent volume claims
kubectl get pvc
```

## References

- [Kubernetes Official Documentation](https://kubernetes.io/docs/)
- [Kubectl Reference](https://kubernetes.io/docs/reference/kubectl/)
- [Deployment API](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [Service API](https://kubernetes.io/docs/concepts/services-networking/service/)
- [Best Practices](https://kubernetes.io/docs/concepts/configuration/overview/)

---

**Last Updated**: November 2025  
**Kubernetes Version**: 1.24+  
**Application**: Static Website (samikshav/app:v1)
