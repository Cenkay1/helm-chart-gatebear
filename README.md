# GateBear Helm Chart

Helm chart for deploying [GateBear](https://github.com/Cenkay1/Gatebear) — a secure integration and release management platform — on Kubernetes.

## Architecture

```
                        ┌──────────────────────┐
                        │    NGINX Ingress      │
                        └──────┬───┬───┬────────┘
                               │   │   │
                    /          │   │   │  /ai
              ┌────────────┐   │   │   │  ┌──────────────┐
              │  Frontend   │◄──┘   │   └─►│  AI Backend  │
              │  (React)    │       │      │  (RAG Chat)  │
              └────────────┘       │      └──────┬───────┘
                                   │ /api        │
                            ┌──────▼──────┐      │
                            │   Backend   │      │
                            │  (FastAPI)  │      │
                            └──────┬──────┘      │
                                   │             │
                        ┌──────────▼──┐   ┌──────▼──────┐
                        │   MongoDB   │   │   Qdrant    │
                        │  (Database) │   │  (Vectors)  │
                        └─────────────┘   └─────────────┘
```

## Prerequisites

- Kubernetes 1.24+
- Helm 3.x
- NGINX Ingress Controller
- PV provisioner (for persistent storage)

## Quick Start

```bash
# Add the repository (if hosted)
helm repo add gatebear https://cenkay1.github.io/Gatebear
helm repo update

# Install from local chart
helm install gatebear ./helm/gatebear -n gatebear --create-namespace

# Install with custom values
helm install gatebear ./helm/gatebear -n gatebear --create-namespace -f my-values.yaml
```

## Configuration

### Global

| Parameter | Description | Default |
|---|---|---|
| `global.storageClass` | Storage class for PVCs | `""` |
| `global.imagePullSecrets` | Image pull secrets | `[]` |
| `global.nodeSelector` | Node selector for all pods | `{}` |
| `global.tolerations` | Tolerations for all pods | `[]` |
| `global.affinity` | Affinity rules for all pods | `{}` |

### Frontend

| Parameter | Description | Default |
|---|---|---|
| `frontend.replicaCount` | Number of replicas | `2` |
| `frontend.image.repository` | Image repository | `gatebear/frontend` |
| `frontend.image.tag` | Image tag | `1.0.0` |
| `frontend.service.port` | Service port | `80` |
| `frontend.env.REACT_APP_API_URL` | Backend API URL | `http://gatebear.example.com/api` |
| `frontend.env.REACT_APP_AI_API_URL` | AI Backend URL | `http://gatebear.example.com/ai` |
| `frontend.resources.limits.cpu` | CPU limit | `500m` |
| `frontend.resources.limits.memory` | Memory limit | `512Mi` |
| `frontend.autoscaling.enabled` | Enable HPA | `false` |
| `frontend.autoscaling.maxReplicas` | Max replicas | `10` |

### Backend (FastAPI)

| Parameter | Description | Default |
|---|---|---|
| `backend.replicaCount` | Number of replicas | `2` |
| `backend.image.repository` | Image repository | `gatebear/backend` |
| `backend.image.tag` | Image tag | `1.0.0` |
| `backend.service.port` | Service port | `8000` |
| `backend.secrets.SECRET_KEY` | JWT secret key | `change-me-in-production` |
| `backend.secrets.MONGODB_URL` | MongoDB connection string | `mongodb://mongodb:27017` |
| `backend.secrets.DATABASE_NAME` | Database name | `gatebear` |
| `backend.env.CORS_ORIGINS` | Allowed CORS origins | `*` |
| `backend.env.ACCESS_TOKEN_EXPIRE_MINUTES` | JWT access token expiry | `30` |
| `backend.env.REFRESH_TOKEN_EXPIRE_DAYS` | JWT refresh token expiry | `7` |
| `backend.resources.limits.cpu` | CPU limit | `1` |
| `backend.resources.limits.memory` | Memory limit | `1Gi` |
| `backend.autoscaling.enabled` | Enable HPA | `false` |

### AI Backend (RAG Chatbot)

| Parameter | Description | Default |
|---|---|---|
| `aiBackend.replicaCount` | Number of replicas | `1` |
| `aiBackend.image.repository` | Image repository | `gatebear/ai-backend` |
| `aiBackend.image.tag` | Image tag | `1.0.0` |
| `aiBackend.service.port` | Service port | `8001` |
| `aiBackend.secrets.GEMINI_API_KEY` | Google Gemini API key | `""` |
| `aiBackend.env.QDRANT_HOST` | Qdrant host | `localhost` |
| `aiBackend.env.QDRANT_PORT` | Qdrant port | `6333` |
| `aiBackend.env.MODEL_NAME` | LLM model name | `gemini-1.5-flash` |
| `aiBackend.env.EMBEDDING_MODEL` | Embedding model | `all-MiniLM-L6-v2` |
| `aiBackend.persistence.size` | PVC size | `10Gi` |
| `aiBackend.resources.limits.cpu` | CPU limit | `2` |
| `aiBackend.resources.limits.memory` | Memory limit | `4Gi` |

### MongoDB

| Parameter | Description | Default |
|---|---|---|
| `mongodb.image.tag` | MongoDB version | `6` |
| `mongodb.persistence.size` | Storage size | `20Gi` |
| `mongodb.auth.enabled` | Enable authentication | `false` |
| `mongodb.auth.rootPassword` | Root password | `""` |
| `mongodb.resources.limits.cpu` | CPU limit | `1` |
| `mongodb.resources.limits.memory` | Memory limit | `2Gi` |

### Qdrant (Vector Database)

| Parameter | Description | Default |
|---|---|---|
| `qdrant.image.tag` | Qdrant version | `v1.7.4` |
| `qdrant.persistence.size` | Storage size | `10Gi` |
| `qdrant.service.httpPort` | HTTP API port | `6333` |
| `qdrant.service.grpcPort` | gRPC port | `6334` |
| `qdrant.resources.limits.cpu` | CPU limit | `1` |
| `qdrant.resources.limits.memory` | Memory limit | `2Gi` |

### Ingress

| Parameter | Description | Default |
|---|---|---|
| `ingress.enabled` | Enable ingress | `true` |
| `ingress.className` | Ingress class | `nginx` |
| `ingress.host` | Hostname | `gatebear.example.com` |
| `ingress.tls` | TLS configuration | `[]` |

## Examples

### Minimal Production Setup

```yaml
# production-values.yaml
ingress:
  host: gatebear.mycompany.com
  tls:
    - secretName: gatebear-tls
      hosts:
        - gatebear.mycompany.com

frontend:
  env:
    REACT_APP_API_URL: https://gatebear.mycompany.com/api
    REACT_APP_AI_API_URL: https://gatebear.mycompany.com/ai

backend:
  secrets:
    SECRET_KEY: "your-strong-secret-key-here"

aiBackend:
  secrets:
    GEMINI_API_KEY: "your-gemini-api-key"
```

```bash
helm install gatebear ./helm/gatebear -n gatebear --create-namespace -f production-values.yaml
```

### With Autoscaling

```yaml
frontend:
  autoscaling:
    enabled: true
    minReplicas: 2
    maxReplicas: 10

backend:
  autoscaling:
    enabled: true
    minReplicas: 2
    maxReplicas: 10
```

### External MongoDB

```yaml
mongodb:
  enabled: false

backend:
  secrets:
    MONGODB_URL: "mongodb+srv://user:pass@cluster.mongodb.net"
```

## Upgrading

```bash
helm upgrade gatebear ./helm/gatebear -n gatebear -f my-values.yaml
```

## Uninstalling

```bash
helm uninstall gatebear -n gatebear
```

> **Note:** PersistentVolumeClaims are not automatically deleted. To remove all data:
> ```bash
> kubectl delete pvc -l app.kubernetes.io/instance=gatebear -n gatebear
> ```

## Components Overview

| Component | Type | Replicas | Port | Storage |
|---|---|---|---|---|
| Frontend | Deployment | 2 | 80 | - |
| Backend | Deployment | 2 | 8000 | - |
| AI Backend | Deployment | 1 | 8001 | 10Gi |
| MongoDB | StatefulSet | 1 | 27017 | 20Gi |
| Qdrant | StatefulSet | 1 | 6333, 6334 | 10Gi |

## Security

- All pods run as non-root user (UID 1000)
- No privilege escalation allowed
- Sensitive values stored in Kubernetes Secrets
- Optional network policies support
- TLS termination at ingress level

## License

This chart is part of the [GateBear](https://github.com/Cenkay1/Gatebear) project.
