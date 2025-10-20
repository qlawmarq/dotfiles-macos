name: "ベースPRPテンプレート v3 - 実装重視・精度基準付き"
description: |

---

## 目標

**機能目標**: [構築すべき具体的で測定可能な最終状態]

**成果物**: [具体的な成果物 - APIエンドポイント、サービスクラス、統合など]

**成功の定義**: [これが完了し動作していることをどのように確認するか]

## ユーザーペルソナ（該当する場合）

**対象ユーザー**: [具体的なユーザータイプ - 開発者、エンドユーザー、管理者など]

**ユースケース**: [この機能が使用される主なシナリオ]

**ユーザージャーニー**: [ユーザーがこの機能とどのようにやり取りするかのステップバイステップフロー]

**対処する課題**: [この機能が解決する具体的なユーザーの不満]

## なぜ

- [ビジネス価値とユーザーへの影響]
- [既存機能との統合]
- [これが解決する問題と対象者]

## 何を

[ユーザーに見える動作と技術要件]

### 成功基準

- [ ] [具体的で測定可能な成果]

## 必要なすべてのコンテキスト

### コンテキスト完全性チェック

_このPRPを書く前に検証: 「このコードベースについて何も知らない人が、これを成功裏に実装するために必要なすべてを持っているか？」_

### ドキュメントと参照

```yaml
# 必読 - コンテキストウィンドウに含める
- url: [セクションアンカー付きの完全なURL]
  why: [実装に必要な特定のメソッド/概念]
  critical: [一般的な実装エラーを防ぐ重要な洞察]

- file: [exact/path/to/pattern/file.py]
  why: [従うべき特定のパターン - クラス構造、エラー処理など]
  pattern: [抽出すべきパターンの簡単な説明]
  gotcha: [避けるべき既知の制約や制限]

- docfile: [PRPs/ai_docs/domain_specific.md]
  why: [複雑なライブラリ/統合パターンのカスタムドキュメント]
  section: [ドキュメントが大きい場合の特定セクション]
```

### 現在のコードベースツリー（プロジェクトのルートで`tree`を実行してコードベースの概要を取得）

```bash

```

### 追加するファイルとファイルの責任を含む望ましいコードベースツリー

```bash

```

### コードベースとライブラリの既知の注意点

```python
# 重要: [ライブラリ名]は[特定のセットアップ]が必要
# 例: FastAPIはエンドポイントに非同期関数が必要
# 例: このORMは1000レコードを超えるバッチインサートをサポートしない
```

## 実装設計図

### データモデルと構造

型安全性と一貫性を保証するため、コアデータモデルを作成します。

```python
例:
 - ORMモデル
 - Pydanticモデル
 - Pydanticスキーマ
 - Pydanticバリデータ

```

### 実装タスク（依存関係順）

```yaml
タスク1: src/models/{domain}_models.py を作成
  - 実装: {SpecificModel}Request、{SpecificModel}Response Pydanticモデル
  - パターンに従う: src/models/existing_model.py (フィールド検証アプローチ)
  - 命名: クラスはCamelCase、フィールドはsnake_case
  - 配置: src/models/内のドメイン固有モデルファイル

タスク2: src/services/{domain}_service.py を作成
  - 実装: 非同期メソッドを持つ{Domain}Serviceクラス
  - パターンに従う: src/services/database_service.py (サービス構造、エラー処理)
  - 命名: {Domain}Serviceクラス、async def create_*、get_*、update_*、delete_*メソッド
  - 依存関係: タスク1からモデルをインポート
  - 配置: src/services/のサービス層

タスク3: src/tools/{action}_{resource}.py を作成
  - 実装: サービスメソッドを呼び出すMCPツールラッパー
  - パターンに従う: src/tools/existing_tool.py (FastMCPツール構造)
  - 命名: snake_caseファイル名、説明的なツール関数名
  - 依存関係: タスク2からサービスをインポート
  - 配置: src/tools/のツール層

タスク4: src/main.py または src/server.py を変更
  - 統合: MCPサーバーに新しいツールを登録
  - パターンを見つける: 既存のツール登録
  - 追加: 既存のパターンに従って新しいツールをインポートして登録
  - 保持: 既存のツール登録とサーバー設定

タスク5: src/services/tests/test_{domain}_service.py を作成
  - 実装: すべてのサービスメソッドの単体テスト（正常系、エッジケース、エラー処理）
  - パターンに従う: src/services/tests/test_existing_service.py (フィクスチャ使用、アサーションパターン)
  - 命名: test_{method}_{scenario}関数命名
  - カバレッジ: 正負のテストケースを持つすべてのパブリックメソッド
  - 配置: テストするコードと一緒

タスク6: src/tools/tests/test_{action}_{resource}.py を作成
  - 実装: MCPツール機能の単体テスト
  - パターンに従う: src/tools/tests/test_existing_tool.py (MCPツールテストアプローチ)
  - モック: 外部サービス依存関係
  - カバレッジ: ツール入力検証、成功レスポンス、エラー処理
  - 配置: src/tools/tests/のツールテスト
```

### 実装パターンと重要な詳細

```python
# 重要なパターンと注意点を表示 - 簡潔に、自明でない詳細に焦点を当てる

# 例: サービスメソッドパターン
async def {domain}_operation(self, request: {Domain}Request) -> {Domain}Response:
    # パターン: 最初に入力検証（src/services/existing_service.pyに従う）
    validated = self.validate_request(request)

    # 注意点: [ライブラリ固有の制約または要件]
    # パターン: エラー処理アプローチ（既存のサービスパターンを参照）
    # 重要: [自明でない要件または設定の詳細]

    return {Domain}Response(status="success", data=result)

# 例: MCPツールパターン
@app.tool()
async def {tool_name}({parameters}) -> str:
    # パターン: ツール検証とサービス委譲（src/tools/existing_tool.pyを参照）
    # 戻り値: 標準化されたレスポンスフォーマットを持つJSON文字列
```

### 統合ポイント

```yaml
DATABASE:
  - migration: "usersテーブルに'feature_enabled'カラムを追加"
  - index: "CREATE INDEX idx_feature_lookup ON users(feature_id)"

CONFIG:
  - add to: config/settings.py
  - pattern: "FEATURE_TIMEOUT = int(os.getenv('FEATURE_TIMEOUT', '30'))"

ROUTES:
  - add to: src/api/routes.py
  - pattern: "router.include_router(feature_router, prefix='/feature')"
```

## 検証ループ

### レベル1: 構文とスタイル（即時フィードバック）

```bash
# 各ファイル作成後に実行 - 続行前に修正
ruff check src/{new_files} --fix     # 自動フォーマットとリント問題の修正
mypy src/{new_files}                 # 特定ファイルの型チェック
ruff format src/{new_files}          # 一貫したフォーマットの保証

# プロジェクト全体の検証
ruff check src/ --fix
mypy src/
ruff format src/

# 期待: エラーゼロ。エラーが存在する場合、出力を読んで続行前に修正。
```

### レベル2: 単体テスト（コンポーネント検証）

```bash
# 各コンポーネント作成時にテスト
uv run pytest src/services/tests/test_{domain}_service.py -v
uv run pytest src/tools/tests/test_{action}_{resource}.py -v

# 影響を受ける領域の完全なテストスイート
uv run pytest src/services/tests/ -v
uv run pytest src/tools/tests/ -v

# カバレッジ検証（カバレッジツールが利用可能な場合）
uv run pytest src/ --cov=src --cov-report=term-missing

# 期待: すべてのテストが合格。失敗している場合、根本原因をデバッグして実装を修正。
```

### レベル3: 統合テスト（システム検証）

```bash
# サービス起動検証
uv run python main.py &
sleep 3  # 起動時間を許可

# ヘルスチェック検証
curl -f http://localhost:8000/health || echo "Service health check failed"

# 機能固有のエンドポイントテスト
curl -X POST http://localhost:8000/{your_endpoint} \
  -H "Content-Type: application/json" \
  -d '{"test": "data"}' \
  | jq .  # JSONレスポンスを整形出力

# MCPサーバー検証（MCPベースの場合）
# MCPツール機能のテスト
echo '{"method": "tools/call", "params": {"name": "{tool_name}", "arguments": {}}}' | \
  uv run python -m src.main

# データベース検証（データベース統合がある場合）
# データベーススキーマ、接続、マイグレーションを検証
psql $DATABASE_URL -c "SELECT 1;" || echo "Database connection failed"

# 期待: すべての統合が動作、適切なレスポンス、接続エラーなし
```

### レベル4: 創造的＆ドメイン固有の検証

```bash
# MCPサーバー検証例:

# Playwright MCP（Webインターフェース用）
playwright-mcp --url http://localhost:8000 --test-user-journey

# Docker MCP（コンテナ化されたサービス用）
docker-mcp --build --test --cleanup

# Database MCP（データ操作用）
database-mcp --validate-schema --test-queries --check-performance

# カスタムビジネスロジック検証
# [ここにドメイン固有の検証コマンドを追加]

# パフォーマンステスト（パフォーマンス要件がある場合）
ab -n 100 -c 10 http://localhost:8000/{endpoint}

# セキュリティスキャン（セキュリティ要件がある場合）
bandit -r src/

# 負荷テスト（スケーラビリティ要件がある場合）
# wrk -t12 -c400 -d30s http://localhost:8000/{endpoint}

# APIドキュメント検証（APIエンドポイントがある場合）
# swagger-codegen validate -i openapi.json

# 期待: すべての創造的検証が合格、パフォーマンスが要件を満たす
```

## 最終検証チェックリスト

### 技術検証

- [ ] 4つの検証レベルすべてが正常に完了
- [ ] すべてのテストが合格: `uv run pytest src/ -v`
- [ ] リントエラーなし: `uv run ruff check src/`
- [ ] 型エラーなし: `uv run mypy src/`
- [ ] フォーマット問題なし: `uv run ruff format src/ --check`

### 機能検証

- [ ] 「何を」セクションのすべての成功基準が満たされている
- [ ] 手動テストが成功: [レベル3の特定コマンド]
- [ ] エラーケースが適切なエラーメッセージで適切に処理されている
- [ ] 統合ポイントが指定通りに動作
- [ ] ユーザーペルソナ要件が満たされている（該当する場合）

### コード品質検証

- [ ] 既存のコードベースパターンと命名規則に従っている
- [ ] ファイル配置が望ましいコードベースツリー構造と一致
- [ ] アンチパターンを回避（アンチパターンセクションと照合）
- [ ] 依存関係が適切に管理されインポートされている
- [ ] 設定変更が適切に統合されている

### ドキュメントとデプロイメント

- [ ] 明確な変数/関数名でコードが自己文書化されている
- [ ] ログは情報的だが冗長でない
- [ ] 新しい環境変数が追加された場合は文書化されている

---

## 避けるべきアンチパターン

- ❌ 既存のパターンが機能するときに新しいパターンを作成しない
- ❌ 「動作するはず」だからといって検証をスキップしない
- ❌ 失敗したテストを無視しない - 修正する
- ❌ 非同期コンテキストで同期関数を使用しない
- ❌ 設定であるべき値をハードコーディングしない
- ❌ すべての例外をキャッチしない - 具体的にする
