---
Jira/GitHubタスクまたは他のタスク管理システムで実装を分解して計画することを目的としています。
---

# タスクテンプレート v2 - 検証ループ付き情報密度重視

> 組み込みコンテキストと検証コマンドを持つ簡潔で実行可能なタスク

## フォーマット

```
[ACTION] path/to/file:
  - [OPERATION]: [DETAILS]
  - VALIDATE: [COMMAND]
  - IF_FAIL: [DEBUG_HINT]
```

## 簡潔で意味のある説明のためにタスクを作成する際に使用するアクションキーワード

- **READ**: 既存のパターンを理解
- **CREATE**: 特定の内容を持つ新しいファイル
- **UPDATE**: 既存のファイルを変更
- **DELETE**: ファイル/コードを削除
- **FIND**: パターンを検索
- **TEST**: 動作を検証
- **FIX**: デバッグして修復

## 重要なコンテキストセクション

```yaml
# コンテキストが重要な場合、タスクの前にこれらを含める
context:
  docs:
    - url: [APIドキュメント]
      focus: [特定のメソッド/セクション]

  patterns:
    - file: existing/example.py
      copy: [パターン名]

  gotchas:
    - issue: "ライブラリXはYが必要"
      fix: "常に最初にZを行う"
```

## 検証付きタスク例

### セットアップタスク

```
READ src/config/settings.py:
  - UNDERSTAND: 現在の設定構造
  - FIND: モデル設定パターン
  - NOTE: 設定はpydantic BaseSettingsを使用

READ tests/test_models.py:
  - UNDERSTAND: モデルのテストパターン
  - FIND: フィクスチャのセットアップアプローチ
  - NOTE: 非同期テストにpytest-asyncioを使用
```

### 実装タスク

````
UPDATE path/to/file:
  - FIND: MODEL_REGISTRY = {
  - ADD: "new-model": NewModelClass,
  - VALIDATE: python -c "from path/to/file import MODEL_REGISTRY; assert 'new-model' in MODEL_REGISTRY"
  - IF_FAIL: NewModelClassのimport文を確認

CREATE path/to/file:
  - COPY_PATTERN: path/to/other/file
  - IMPLEMENT:
   - [コードベースインテリジェンスに基づいて実装する必要がある詳細な説明]
  - VALIDATE: uv run pytest path/to/file -v

UPDATE path/to/file:
  - FIND: app.include_router(
  - ADD_AFTER:
    ```python
    from .endpoints import new_model_router
    app.include_router(new_model_router, prefix="/api/v1")
    ```
  - VALIDATE: uv run pytest path/to/file -v
````

## 検証チェックポイント

```
CHECKPOINT syntax:
  - RUN: ruff check && mypy .
  - FIX: 報告された問題を修正
  - CONTINUE: クリーンな場合のみ

CHECKPOINT tests:
  - RUN: uv run pytest path/to/file -v
  - REQUIRE: すべて合格
  - DEBUG: uv run pytest -vvs path/to/file/failing_test.py
  - CONTINUE: すべてグリーンの場合のみ

CHECKPOINT integration:
  - START: docker-compose up -d
  - RUN: ./scripts/integration_test.sh
  - EXPECT: "All tests passed"
  - CLEANUP: docker-compose down
```

## デバッグパターン

```
DEBUG import_error:
  - CHECK: パスにファイルが存在
  - CHECK: すべての親ディレクトリに__init__.py
  - TRY: python -c "import path/to/file"
  - FIX: PYTHONPATHに追加またはimportを修正

DEBUG test_failure:
  - RUN: uv run pytest -vvs path/to/test.py::test_name
  - ADD: print(f"Debug: {variable}")
  - IDENTIFY: アサーション vs 実装の問題
  - FIX: テストを更新またはコードを修正

DEBUG api_error:
  - CHECK: サーバーが実行中 (ps aux | grep uvicorn)
  - TEST: curl http://localhost:8000/health
  - READ: スタックトレースのサーバーログ
  - FIX: 特定のエラーに基づいて修正
```

## 一般的なタスク例

### 新機能の追加

```
1. READ 既存の類似機能
2. CREATE 新機能ファイル（パターンをコピー）
3. UPDATE レジストリ/ルーターに含める
4. CREATE 機能のテスト
5. TEST すべてのテストが合格
6. FIX リント/型の問題
7. TEST 統合が動作
```

### バグ修正

```
1. CREATE バグを再現する失敗テスト
2. TEST テストが失敗することを確認
3. READ 関連コードを理解
4. UPDATE 修正でコードを更新
5. TEST テストが今度は合格することを確認
6. TEST 他のテストが壊れていない
7. UPDATE 変更履歴
```

### コードのリファクタリング

```
1. TEST 現在のテストが合格（ベースライン）
2. CREATE 新しい構造（まだ古いものを削除しない）
3. UPDATE 新しい構造への1つの使用方法
4. TEST まだ合格
5. UPDATE 残りの使用方法を段階的に
6. DELETE 古い構造
7. TEST 完全なスイートが合格
```

## 効果的なタスクのためのヒント

- すべての変更の後にVALIDATEを使用
- 一般的な問題のIF_FAILヒントを含める
- 特定の行番号またはパターンを参照
- 検証コマンドをシンプルで高速に保つ
- 明確な依存関係を持つ関連タスクをチェーン
- リスクのある変更には常にロールバック/元に戻す手順を含める
