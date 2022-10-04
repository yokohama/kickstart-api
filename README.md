# kickstart-api

## 目次
1. リポジトリをforkする
2. developmentのデプロイの環境を用意する
3. ローカル開発環境の構築をする
4. mockの動作確認
5. API Gatewayの初期化
6. 変更のデプロイ

## 1. リポジトリをforkする
### 1. githubからforkする。
fork先名は解りやすく同じ名前にして下さい。もし変更する場合は、以降`kickstart-api`を`変更した名前`に読み替えて作業をおこなって下さい。

### 2. ブランチの作成
forkした先のリポジトリに、`development`ブランチを作成して下さい。

## 2. developmentのデプロイの環境を用意する
### 1. githubにsecretsを設定する。

| 参照名 | 使用箇所 | 取得方法 | ステータス |
| :--- | :--- | :--- | :--- |
| aws_access_key_id | api / github / actions / secretes |  | 取得済み |
| aws_secret_access_key | api / github / actions / secretes |  | 取得済み |
| aws_region | api / github / actions / secretes |  | 取得済み |

上記の内容を以下名前で、githubのactionsのSecretsに設定します。上記の内容の取得がまだの方は、[こちら](https://github.com/yokohama/kickstart/blob/main/README.md#kickstart-1)を参照して先に取得をして下さい。

| 変数名 | 参照名 |
| :--- | :--- |
| AWS_ACCESS_KEY_ID | aws_access_key_id |
| AWS_SECRET_ACCESS_KEY | aws_secret_access_key |
| AWS_REGION | aws_region |

<img src="https://user-images.githubusercontent.com/1023421/193436088-07c7bf0d-5f06-4006-affb-13172e458949.png" width="400">

<img src="https://user-images.githubusercontent.com/1023421/193436108-65696dc7-ea34-4d03-967e-7f04182aadb3.png" width="400">

<img src="https://user-images.githubusercontent.com/1023421/193436277-18b88ba9-9bba-4d7f-9fd7-3f935c39a03d.png" width="400">

## 3. ローカル開発環境の構築をする
### 1. 必要なパッケージをインストールします
```
$ cd ./kickstart-api
$ yarn
```

## 4. mockの動作確認
### 1. mockサーバーを起動します
```
$ cd ./kickstart-api
$ prism mock ./openapi/root.yaml

[12:15:58 PM] › [CLI] …  awaiting  Starting Prism…
[12:15:58 PM] › [CLI] ℹ  info      GET        http://127.0.0.1:4010/users
[12:15:58 PM] › [CLI] ▶  start     Prism is listening on http://127.0.0.1:4010
```

### 2. 通信の確認
```
$curl http://localhost:4010/users

HTTP/1.1 401 Unauthorized
Access-Control-Allow-Origin: *
Access-Control-Allow-Headers: *
Access-Control-Allow-Credentials: true
Access-Control-Expose-Headers: *
content-type: application/problem+json
WWW-Authenticate: Bearer
Content-Length: 316
Date: Sun, 02 Oct 2022 03:21:43 GMT
Connection: keep-alive
Keep-Alive: timeout=5

{"type":"https://stoplight.io/prism/errors#UNAUTHORIZED","title":"Invalid security scheme used","status":401,"detail":"Your request does not fullfil the security requirements and no HTTP unauthorized response was found in the spec, so Prism is generating this error for you.","headers":{"WWW-Authenticate":"Bearer"}}
```
ステータス401で失敗しますが、`Bearerトークン`が入っていないので、認証に弾かれているという正しい結果です。

### 3. Bearerトークンを入れた通信の確認
- Bearerの後ろに、適当に文字を入れます。

```
curl --include -H GET -H 'Authorization: Bearer xxxx' http://localhost:4010/users

HTTP/1.1 200 OK
Access-Control-Allow-Origin: *
Access-Control-Allow-Headers: *
Access-Control-Allow-Credentials: true
Access-Control-Expose-Headers: *
Content-type: application/json
Content-Length: 55
Date: Sun, 02 Oct 2022 03:21:32 GMT
Connection: keep-alive
Keep-Alive: timeout=5

[{"id":1,"name":"Hoge Moge"},{"id":2,"name":"Foo Bar"}]
```
ステータス200で成功。2名のユーザーのモックデータも取得できました。

## 5. API Gatewayの初期化
### 1. インフラの構築
- openapiファイルをデプロイするためには、先にインフラを構築する必要が有ります。
- 先に、[こちら](https://github.com/yokohama/kickstart-cdk)でインフラを構築を完了させて、指示に従いここに戻ってきて下さい。

- API Gatewayの動作確認のために、フロントで取得できるFirebaseのBearerトークンが必要となります。
- フロントの構築がまだの方は、先に[こちら](https://github.com/yokohama/kickstart-front)からフロントの構築を完了させて、指示に従いここに戻ってく来て下さい。
- フロントから来た方は、このまま進めて下さい。

<a id="kickstart-api-5-2" />

### 2. API Gatewayの確認
- CDKの構築を終わらせている場合、以下の3つのAPI Gatewayが確認できます。
- サブドメインはそれぞれの環境で違います。

```
$ ./ops/apigateways.sh

Api-local = https://9cmzrav93l.execute-api.ap-northeast-1.amazonaws.com/prod
Api-dev = https://fh3ao3lhll.execute-api.ap-northeast-1.amazonaws.com/prod
Api-prd = https://hlsfkbtf28.execute-api.ap-northeast-1.amazonaws.com/prod
```

### 3. API Gateway(aws上のlocal）の初期化
```
$ TARGET_ENV=local ./ops/deploy.sh
```

### 4. 疎通確認用の、Bearerトークンの取得
- Vercelで作成したドメインのどちらでもいいので公開されているURLにアクセスします。
- ログインして、`SETTINGS` => `APIコール`をクリックします。
- コンソールログの、トークンをコピーします。
<img src="https://user-images.githubusercontent.com/1023421/193776158-85c9d828-82dc-4b6f-9be0-d904582afa80.png" width="400" />

### 5. API Gateway(aws上のlocal）の疎通確認
- トークンがないと、401エラー
```
$ curl --include -H GET https://fh3ao3lhll.execute-api.ap-northeast-1.amazonaws.com/prod/users

HTTP/2 401 
content-type: application/json; charset=utf-8
content-length: 22
date: Tue, 04 Oct 2022 09:08:27 GMT
x-amzn-requestid: d125af27-df4b-4a93-99ba-0a67e08a0168
referrer-policy: strict-origin-when-cross-origin
x-permitted-cross-domain-policies: none
x-xss-protection: 0
x-runtime: 0.390973
x-frame-options: SAMEORIGIN
x-download-options: noopen
x-request-id: bd39d914-52a3-493c-93b0-4d2c36c42d10
x-amz-apigw-id: ZeOxhFaqNjMFaBw=
vary: Accept, Origin
cache-control: no-cache
server-timing: sql.active_record;dur=77.95, start_processing.action_controller;dur=0.27, halted_callback.action_controller;dur=0.06, process_action.action_controller;dur=8.23
x-content-type-options: nosniff
x-cache: Error from cloudfront
via: 1.1 1b688f7d4f90b6acf6d7774ff14f6eae.cloudfront.net (CloudFront)
x-amz-cf-pop: NRT20-C3
x-amz-cf-id: pScoRMJT54tC-wWUMouxzdvH3is3Y8TLBpcltZNEKO2DxTAVClK-MA==

"authorization error."
```

- トークンを入れると成功
```
$ curl --include -H GET -H 'Authorization: Bearer ＜コピーしたトークン＞' https://9cmzrav93l.execute-api.ap-northeast-1.amazonaws.com/prod/users

HTTP/2 200 
content-type: application/json; charset=utf-8
content-length: 2
date: Tue, 04 Oct 2022 09:03:59 GMT
x-amzn-requestid: 69fc29be-2737-42d7-a218-5320313befd6
referrer-policy: strict-origin-when-cross-origin
x-permitted-cross-domain-policies: none
x-xss-protection: 0
x-runtime: 0.681381
x-frame-options: SAMEORIGIN
x-download-options: noopen
x-request-id: 8f175f6a-0ed0-403d-b770-32ce39bc1843
x-amz-apigw-id: ZeOHpHNlNjMFwDg=
vary: Accept, Origin
cache-control: max-age=0, private, must-revalidate
server-timing: sql.active_record;dur=42.87, start_processing.action_controller;dur=0.15, process_action.action_controller;dur=293.35
x-content-type-options: nosniff
etag: W/"4f53cda18c2baa0c0354bb5f9a3ecbe5"
x-cache: Miss from cloudfront
via: 1.1 438d269423fd1b81498db6d9617daa70.cloudfront.net (CloudFront)
x-amz-cf-pop: NRT20-C3
x-amz-cf-id: f36rnKlGojnjtdCHMCIpkmPbXX9tpZv-gemiPk-2NMBSf3R8EjPRCA==

[]
```








### 3. root.yamlを変更
- openapi/root.yamlに、`/pets'のpathを追加します。

```
$ git diff openapi/root.yaml

diff --git a/openapi/root.yaml b/openapi/root.yaml
index 0585f10..db06a02 100644
--- a/openapi/root.yaml
+++ b/openapi/root.yaml
@@ -78,6 +78,66 @@ paths:
         connectionId: "{NEXT-STARTUP-VPC-LINK-ID}" 
         uri: "http://{NEXT-STARTUP-LB-URI}/users"
 
+  /pets:
+    options:
+      summary: CORS support
+      description: |
+        Enable CORS by returning correct headers
+      tags:
+      - CORS
+      responses:
+        200:
+          description: Default response for CORS method
+          headers: 
+            Access-Control-Allow-Origin:  
+              $ref: '#/components/headers/Access-Control-Allow-Origin'
+            Access-Control-Allow-Methods: 
+              $ref: '#/components/headers/Access-Control-Allow-Methods'
+            Access-Control-Allow-Headers: 
+              $ref: '#/components/headers/Access-Control-Allow-Headers'
+          content: {}
+      x-amazon-apigateway-integration:
+        type: mock
+        requestTemplates:
+          application/json: |
+            { "statusCode" : 200 }
+        responses:
+          default:
+            statusCode: "200"
+            responseParameters:
+              method.response.header.Access-Control-Allow-Headers: '''Content-Type,X-Amz-Date,Authorization,X-Api-Key'''
+              method.response.header.Access-Control-Allow-Methods: '''*'''
+              method.response.header.Access-Control-Allow-Origin: '''*'''
+            responseTemplates:
+              application/json: |
+                {}
+    get:
+      tags:
+        - users
+      summary: Get all users.
+      description: Returns an array of User model.
+      parameters: []
+      responses:
+        '200':
+          description: A Json array of User model.
+          content:
+            application/json:
+              schema:
+                type: array
+                items:
+                  $ref: '#/components/schemas/User'
+                example:
+                  - id: 1
+                    name: Hoge Moge
+                  - id: 2
+                    name: Foo Bar
+      x-amazon-apigateway-integration:
+        type: "http_proxy" 
+        httpMethod: "GET" 
+        connectionType: "VPC_LINK" 
+        connectionId: "{NEXT-STARTUP-VPC-LINK-ID}" 
+        uri: "http://{NEXT-STARTUP-LB-URI}/users"
+
 components:
    headers:
     Access-Control-Allow-Origin:
```


## 6. 変更のデプロイ

curl --include -H GET -H 'Authorization: Bearer' http://localhost:4010/pets 


