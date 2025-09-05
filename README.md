# Solr Operator with ArgoCD and Vault Integration / Solr Operator с ArgoCD и интеграцией Vault

## English Version

### Overview
This configuration deploys Apache Solr Operator using ArgoCD with HashiCorp Vault integration for secure secret management. The setup includes different security configurations for each environment (development, staging, production) with automatically generated unique passwords.

### Features
- **Multi-environment support**: Separate configurations for dev, staging, and prod
- **Vault integration**: Secure storage of security.json with automatic injection
- **Auto-generated passwords**: Unique passwords for each environment
- **ArgoCD automation**: Automated deployment and synchronization
- **Helm templating**: Flexible configuration using Helm values

### Prerequisites
- Kubernetes cluster (v1.19+)
- ArgoCD installed and configured
- HashiCorp Vault installed and configured
- kubectl configured with cluster access
- Helm (for local testing)

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-org/solr-argo-config.git
   cd solr-argo-config
   ```

2. **Configure Vault**
   ```bash
   cd vault/
   chmod +x *.sh
   ./setup-vault.sh
   ```

3. **Deploy Solr Operator**
   ```bash
   kubectl apply -f applications/solr-operator-application.yaml
   ```

4. **Deploy SolrCloud instances**
   ```bash
   kubectl apply -f applications/solr-multi-stage-applicationset.yaml
   ```

5. **Verify deployment**
   ```bash
   kubectl get applications -n argocd
   kubectl get solrcloud -n solr-dev
   kubectl get solrcloud -n solr-staging  
   kubectl get solrcloud -n solr-prod
   ```

### Project Structure
```
solr-argo-config/
├── applications/          # ArgoCD Application manifests
├── charts/               # Helm charts
├── manifests/           # Kubernetes manifests
├── values/              # Helm values per environment
├── vault/               # Vault configuration scripts
└── README.md
```

### Environment Details

| Environment | Namespace   | Replicas | Storage | Resources       |
|-------------|-------------|----------|---------|-----------------|
| Development | solr-dev    | 1        | 20Gi    | 1Gi RAM, 500m CPU |
| Staging     | solr-staging| 2        | 50Gi    | 2Gi RAM, 1000m CPU |
| Production  | solr-prod   | 3        | 100Gi   | 4Gi RAM, 2000m CPU |

### Vault Secrets Structure
```
secret/
├── solr/
│   ├── security/
│   │   ├── development/  # admin_password, reader_password, writer_password
│   │   ├── staging/      # admin_password, reader_password, writer_password  
│   │   └── production/   # admin_password, reader_password, writer_password
│   └── users/
│       ├── development/  # user mappings and passwords
│       ├── staging/      # user mappings and passwords
│       └── production/   # user mappings and passwords
```

### Monitoring and Logs
```bash
# Check ArgoCD sync status
argocd app get solr-dev
argocd app get solr-staging
argocd app get solr-prod

# Check Solr operator logs
kubectl logs -f deployment/solr-operator -n solr-operator

# Check Vault agent logs
kubectl logs -f deployment/solr-dev -n solr-dev -c vault-agent
```

### Troubleshooting

1. **Vault connection issues**
   ```bash
   kubectl describe pod/solr-dev-0 -n solr-dev
   kubectl logs pod/solr-dev-0 -n solr-dev -c vault-agent
   ```

2. **ArgoCD sync problems**
   ```bash
   argocd app sync solr-dev
   argocd app history solr-dev
   ```

3. **Secret injection verification**
   ```bash
   kubectl exec pod/solr-dev-0 -n solr-dev -- cat /var/solr/security.json
   ```

### Cleanup
```bash
# Delete applications
kubectl delete -f applications/solr-multi-stage-applicationset.yaml
kubectl delete -f applications/solr-operator-application.yaml

# Delete namespaces
kubectl delete namespace solr-dev solr-staging solr-prod solr-operator

# Clean Vault secrets (optional)
vault kv delete secret/solr/security/development
vault kv delete secret/solr/security/staging
vault kv delete secret/solr/security/production
```

---

## Русская версия

### Обзор
Данная конфигурация развертывает Apache Solr Operator с использованием ArgoCD и интеграцией HashiCorp Vault для безопасного управления секретами. Настройка включает различные конфигурации безопасности для каждого окружения (разработка, staging, production) с автоматически генерируемыми уникальными паролями.

### Возможности
- **Поддержка нескольких окружений**: Раздельные конфигурации для dev, staging и prod
- **Интеграция с Vault**: Безопасное хранение security.json с автоматической инъекцией
- **Автогенерация паролей**: Уникальные пароли для каждого окружения
- **Автоматизация ArgoCD**: Автоматическое развертывание и синхронизация
- **Шаблонизация Helm**: Гибкая конфигурация с использованием Helm values

### Предварительные требования
- Kubernetes кластер (v1.19+)
- Установленный и настроенный ArgoCD
- Установленный и настроенный HashiCorp Vault
- Настроенный kubectl с доступом к кластеру
- Helm (для локального тестирования)

### Шаги установки

1. **Клонирование репозитория**
   ```bash
   git clone https://github.com/your-org/solr-argo-config.git
   cd solr-argo-config
   ```

2. **Настройка Vault**
   ```bash
   cd vault/
   chmod +x *.sh
   ./setup-vault.sh
   ```

3. **Развертывание Solr Operator**
   ```bash
   kubectl apply -f applications/solr-operator-application.yaml
   ```

4. **Развертывание экземпляров SolrCloud**
   ```bash
   kubectl apply -f applications/solr-multi-stage-applicationset.yaml
   ```

5. **Проверка развертывания**
   ```bash
   kubectl get applications -n argocd
   kubectl get solrcloud -n solr-dev
   kubectl get solrcloud -n solr-staging
   kubectl get solrcloud -n solr-prod
   ```

### Структура проекта
```
solr-argo-config/
├── applications/          # Манифесты ArgoCD Application
├── charts/               # Helm charts
├── manifests/           # Kubernetes манифесты
├── values/              # Helm values для каждого окружения
├── vault/               # Скрипты конфигурации Vault
└── README.md
```

### Детали окружений

| Окружение   | Namespace   | Реплики | Хранилище | Ресурсы         |
|-------------|-------------|---------|-----------|-----------------|
| Разработка  | solr-dev    | 1       | 20Gi      | 1Gi RAM, 500m CPU |
| Staging     | solr-staging| 2       | 50Gi      | 2Gi RAM, 1000m CPU |
| Production  | solr-prod   | 3       | 100Gi     | 4Gi RAM, 2000m CPU |

### Структура секретов в Vault
```
secret/
├── solr/
│   ├── security/
│   │   ├── development/  # admin_password, reader_password, writer_password
│   │   ├── staging/      # admin_password, reader_password, writer_password
│   │   └── production/   # admin_password, reader_password, writer_password
│   └── users/
│       ├── development/  # маппинг пользователей и пароли
│       ├── staging/      # маппинг пользователей и пароли
│       └── production/   # маппинг пользователей и пароли
```

### Мониторинг и логи
```bash
# Проверка статуса синхронизации ArgoCD
argocd app get solr-dev
argocd app get solr-staging
argocd app get solr-prod

# Логи Solr operator
kubectl logs -f deployment/solr-operator -n solr-operator

# Логи Vault agent
kubectl logs -f deployment/solr-dev -n solr-dev -c vault-agent
```

### Решение проблем

1. **Проблемы с подключением к Vault**
   ```bash
   kubectl describe pod/solr-dev-0 -n solr-dev
   kubectl logs pod/solr-dev-0 -n solr-dev -c vault-agent
   ```

2. **Проблемы с синхронизацией ArgoCD**
   ```bash
   argocd app sync solr-dev
   argocd app history solr-dev
   ```

3. **Проверка инъекции секретов**
   ```bash
   kubectl exec pod/solr-dev-0 -n solr-dev -- cat /var/solr/security.json
   ```

### Очистка
```bash
# Удаление приложений
kubectl delete -f applications/solr-multi-stage-applicationset.yaml
kubectl delete -f applications/solr-operator-application.yaml

# Удаление namespace
kubectl delete namespace solr-dev solr-staging solr-prod solr-operator

# Очистка секретов Vault (опционально)
vault kv delete secret/solr/security/development
vault kv delete secret/solr/security/staging
vault kv delete secret/solr/security/production
```

### Полезные команды
```bash
# Проверка состояния всех компонентов
kubectl get pods -n argocd
kubectl get pods -n solr-operator
kubectl get pods -n solr-dev
kubectl get pods -n solr-staging
kubectl get pods -n solr-prod

# Проверка секретов
kubectl get secrets -n solr-dev
kubectl get secrets -n solr-staging
kubectl get secrets -n solr-prod
```

### Поддержка
Для вопросов и поддержки обращайтесь:
- Документация ArgoCD: https://argo-cd.readthedocs.io/
- Документация Solr Operator: https://solr.apache.org/operator/
- Документация Vault: https://www.vaultproject.io/docs/

Этот README предоставляет полное руководство по развертыванию и управлению Solr кластерами с использованием ArgoCD и Vault для безопасного хранения конфиденциальных данных.
