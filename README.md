# kickstart-api

## 目次
1. リポジトリをforkする
2. developmentのデプロイの環境を用意する
3. ローカル開発環境の構築をする
4. デプロイ

## 1. リポジトリをforkする
### 1. githubからforkする。fork先名は解りやすく同じ名前にして下さい。もし変更する場合は、以降`kickstart-api`を`変更した名前`に読み替えて作業をおこなって下さい。
### 2. forkした先のリポジトリに、`development`ブランチを作成して下さい。

## 2. developmentのデプロイの環境を用意する
### 1. githubにsecretsを設定する。

| 参照名 | 使用箇所 | 取得方法 | ステータス |
| :--- | :--- | :--- | :--- |
| aws_access_key_id | api / github / actions / secretes |  | 取得済み |
| aws_secret_access_key | api / github / actions / secretes |  | 取得済み |
| aws_region | api / github / actions / secretes |  | 取得済み |

上記の内容を以下名前で、githubのactionsのSecretsに設定します。上記の内容の取得がまだの方は、[こちら](https://github.com/yokohama/kickstart/blob/main/README.md#kickstart-1)を参照して先に取得をして下さい。

