# Web App with Private Endpoint and Front Door

Deploy template with:

```
az deployment sub create --location eastus --template-file main.bicep --parameter adminPassword=somepassword
```

Front Door deployment based on: https://github.com/Azure/azure-quickstart-templates/tree/master/201-front-door-premium-app-service-private-link

Video: https://www.youtube.com/watch?v=yRIC2U-Vnts
