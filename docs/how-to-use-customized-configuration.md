# How to use a customized properties file with Scalar Helm Charts

You can use your customized properties files with Scalar Helm Charts (Scalar DB, Scalar DL Ledger, and Scalar DL Auditor). This document explains how to use a customized properties file.

## Use `ConfigMap` resource to pass a customized properties file

### Step 1. Configure a custom values file to use a customized properties file

1. Set `true` to `[scalardb|ledger|auditor].useCustomizedConfiguration.enabled`.

1. Set `ConfigMap` name as the value of `[scalardb|ledger|auditor].useCustomizedConfiguration.configMapName`.  
   You can specify an arbitrary name as `ConfigMap` name in the custom values file.

* Example
    * Scalar DB
    ```yaml
    scalardb:
      useCustomizedConfiguration:
        enabled: true
        configMapName: "scalardb-customized-config"
    ```
    * Scalar DL Ledger
    ```yaml
    ledger:
      useCustomizedConfiguration:
        enabled: true
        configMapName: "ledger-customized-config"
    ```
    * Scalar DL Auditor
    ```yaml
    auditor:
      useCustomizedConfiguration:
        enabled: true
        configMapName: "auditor-customized-config"  
    ```

### Step 2. Create a `ConfigMap` that includes a customized properties file

1. Create the `ConfigMap`.  
   You need to create `ConfigMap` that includes your customized properties file with the name specified in the custom values file.  
   Also, You need to specify the **key names** as `[database|ledger|auditor].properties.tmpl`.
   * Example
       * Scalar DB
         ```console
         kubectl create configmap scalardb-customized-config --from-file=database.properties.tmpl=<your customized database.properties>
         ```
       * Scalar DL Ledger
         ```console
         kubectl create configmap ledger-customized-config --from-file=ledger.properties.tmpl=<your customized ledger.properties>
         ```
       * Scalar DL Auditor
         ```console
         kubectl create configmap auditor-customized-config --from-file=auditor.properties.tmpl=<your customized auditor.properties>
         ```

### Step 3. Deploy with Helm Charts

After creating the `ConfigMap`, you can deploy Scalar products with your customized properties files using Helm Charts.  
Please specify the custom values file that you created in **Step 1**.
* Example
    * Scalar DB
      ```console
      helm install scalardb scalar-labs/scalardb -f ./scalardb-custom-values.yaml
      ```
    * Scalar DL Ledger
      ```console
      helm install scalardl-ledger scalar-labs/scalardl -f ./scalardl-ledger-custom-values.yaml
      ```
    * Scalar DL Auditor
      ```console
      helm install scalardl-auditor scalar-labs/scalardl-audit -f ./scalardl-auditor-custom-values.yaml
      ```

Please refer to the [Getting Started with Scalar Helm Charts](./getting-started-scalar-helm-charts.md) for more details of each Helm Chart.

## Use `Secret` resource to pass the credentials as the environment variables into the customized properties file (`ConfigMap`)

You can pass the credentials like **username** or **password** as the environment variables via `Secret` resource.

### Step 1. Configure a custom values file to use `Secret`

1. Set `true` to `[scalardb|ledger|auditor].useCustomizedConfiguration.useSecret`.

1. Set `Secret` name as the value of `[scalardb|ledger|auditor].useCustomizedConfiguration.secretName`.  

1. Set **Environment Variable Name** and **Secret Key Name** as the value of `[scalardb|ledger|auditor].useCustomizedConfiguration.secretKeys[]`.  
   You can specify arbitrary names in the custom values file.  
   Also, you can specify several environment variables.  

* Example
    * Scalar DB
      ```yaml
      scalardb:
        useCustomizedConfiguration:
          enabled: true
          configMapName: "scalardb-customized-config"
          useSecret: true
          secretName: "scalardb-customized-secret"
          secretKeys:
            - environmentVariableName: CUSTOMIZED_CONFIG_DB_USERNAME_A
              secretKeyName: db-username-a
            - environmentVariableName: CUSTOMIZED_CONFIG_DB_PASSWORD_A
              secretKeyName: db-password-a
            - environmentVariableName: CUSTOMIZED_CONFIG_DB_USERNAME_B
              secretKeyName: db-username-b
            - environmentVariableName: CUSTOMIZED_CONFIG_DB_PASSWORD_B
              secretKeyName: db-password-b
      ```
    * Scalar DL Ledger
      ```yaml
      ledger:
        useCustomizedConfiguration:
          enabled: true
          configMapName: "ledger-customized-config"
          useSecret: true
          secretName: "ledger-customized-secret"
          secretKeys:
            - environmentVariableName: CUSTOMIZED_CONFIG_DB_USERNAME_C
              secretKeyName: db-username-c
            - environmentVariableName: CUSTOMIZED_CONFIG_DB_PASSWORD_C
              secretKeyName: db-password-c
      ```
    * Scalar DL Auditor
      ```yaml
      auditor:
        useCustomizedConfiguration:
          enabled: true
          configMapName: "auditor-customized-config"
          useSecret: true
          secretName: "auditor-customized-secret"
          secretKeys:
            - environmentVariableName: CUSTOMIZED_CONFIG_DB_USERNAME_D
              secretKeyName: db-username-d
            - environmentVariableName: CUSTOMIZED_CONFIG_DB_PASSWORD_D
              secretKeyName: db-password-d
      ```

### Step 2. Create a `Secret` resource that includes credentials

1. Create the `Secret`.  
   You need to create `Secret` that includes credentials with the name specified in the custom values file.  
   Also, you need to set the **Secret Key Name** same as the value of `secretKeyName` you specified in the custom values file.
   * Example
       * Scalar DB
         ```console
         kubectl create secret generic scalardb-customized-secret \
           --from-literal=db-username-a=<user name of A> \
           --from-literal=db-password-a=<password of A> \
           --from-literal=db-username-b=<user name B> \
           --from-literal=db-password-b=<password of B>
         ```
       * Scalar DL Ledger
         ```console
         kubectl create secret generic ledger-customized-secret \
           --from-literal=db-username-c=<user name of C> \
           --from-literal=db-password-c=<password of C>
         ```
       * Scalar DL Auditor
         ```console
         kubectl create secret generic auditor-customized-secret \
           --from-literal=db-username-d=<user name of D> \
           --from-literal=db-password-d=<password of D>
         ```

### Step 3. Set environment variable name in the customized properties file

The docker images of Scalar products use `dockerize` for templating properties files.  
You can set the values of environment variables in the customized properties file when we run the containers.

1. Set **environment variable name** as Go template syntax in the customized properties file.  
   You need to set **Environment Variable Name** same as the value of `environmentVariableName` you specified in the custom values file.
   * Example
     ```console
     scalar.db.contact_points=jdbc:postgresql://postgresql:5432/postgres
     scalar.db.username={{ default .Env.CUSTOMIZED_CONFIG_DB_USERNAME_A "" }}
     scalar.db.password={{ default .Env.CUSTOMIZED_CONFIG_DB_PASSWORD_A "" }}
     scalar.db.storage=jdbc
     ```
     When the containers ran, the above Go template strings are replaced to the value of environment variable as follows.
     ```console
     scalar.db.contact_points=jdbc:postgresql://postgresql:5432/postgres
     scalar.db.username=<user name of A>
     scalar.db.password=<password of A>
     scalar.db.storage=jdbc
     ```

1. Create a `ConfigMap` from customized properties file that includes environment variable name (Go template strings) as above.  
   Please refer to the **Use `ConfigMap` resource to pass a customized properties file** section of this guide for more details of `ConfigMap`.  

### Step 4. Deploy with Helm Charts

After creating the `Secret` and `ConfigMap`, you can deploy Scalar products with your customized properties files using Helm Charts.  
Please specify the custom values file that you created in **Step 1**.
* Example
    * Scalar DB
      ```console
      helm install scalardb scalar-labs/scalardb -f ./scalardb-custom-values.yaml
      ```
    * Scalar DL Ledger
      ```console
      helm install scalardl-ledger scalar-labs/scalardl -f ./scalardl-ledger-custom-values.yaml
      ```
    * Scalar DL Auditor
      ```console
      helm install scalardl-auditor scalar-labs/scalardl-audit -f ./scalardl-auditor-custom-values.yaml
      ```

Please refer to the [Getting Started with Scalar Helm Charts](./getting-started-scalar-helm-charts.md) for more details of each Helm Chart.
