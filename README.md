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

<a id="kickstart-api-5-2" />

### 2. 初期化

## 6. 変更のデプロイ


