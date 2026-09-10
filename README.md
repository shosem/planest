# planest

グループ単位のタスク管理・日報アプリ。
個人タスクを作成し、進捗をコメントで日々報告していく。

## 技術スタック

- Ruby / Ruby on Rails
- PostgreSQL
- Tailwind CSS（tailwindcss-rails）+ daisyUI
- Hotwire（Turbo / Stimulus）
- Docker / Docker Compose
- RSpec / Capybara（テスト）

## 必要な環境

- Docker
- Docker Compose

## セットアップ手順

### 1. リポジトリをクローン

```bash
git clone <リポジトリのURL>
cd planest
```

### 2. 環境変数ファイルを用意

`.env.example` をコピーして `.env` を作成します。

```bash
cp .env.example .env
```

`.env` の中身は基本そのままで動きますが、
**すでにローカルで別のアプリが `3000`（Web）や `5432`（PostgreSQL）を使っている場合**は、`.env` で使用ポートを変更できます。

```dotenv
WEB_PORT=3100
DB_PORT=5433
```

この場合、ブラウザでアクセスするURLは http://localhost:3100 になります。

### 3. コンテナをビルド

```bash
docker compose build
```

### 4. データベースを作成

```bash
docker compose run --rm web rails db:create
docker compose run --rm web rails db:migrate
```

### 5. アプリを起動

```bash
docker compose up
```

ブラウザで http://localhost:3000 にアクセスして、画面が表示されれば成功です。


## テストの実行

```bash
docker compose run --rm web bundle exec rspec
```

## 開発時の注意点

- `.env` はコミットしないこと（`.gitignore` で除外済み）。共有が必要な変数は `.env.example` に追記する
- json gem は v2 系に固定しています（v3 は破壊的変更により一部の機能が動作しないため）
- パッケージ管理は yarn に統一しています（npm と混在させないこと）