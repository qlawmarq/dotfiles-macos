---
description: プロジェクト固有のフックを設定して、リント、フォーマット、テストを自動化
category: automation
allowed-tools: Bash, Read, Write, Glob
argument-hint: [--type python|node|go|rust|auto]
---

# Claudeコマンド: フックのセットアップ

このコマンドは、自動コード品質チェック、フォーマット、テストのためのプロジェクト固有のフックをセットアップします。

## 使用方法

プロジェクトタイプを自動検出してフックをセットアップ:
```
/setup-hooks
```

またはプロジェクトタイプを指定:
```
/setup-hooks --type node
/setup-hooks --type python
```

## このコマンドが行うこと

1. **プロジェクトタイプの検出** 以下をチェック:
   - `package.json` → Node.js/JavaScript/TypeScript
   - `pyproject.toml` または `setup.py` → Python
   - `go.mod` → Go
   - `Cargo.toml` → Rust
   - `Gemfile` → Ruby
   - `pom.xml` または `build.gradle` → Java

2. **利用可能なツールの特定** プロジェクト内で:
   - リンター: ESLint, Ruff, golangci-lint, clippy
   - フォーマッター: Prettier, Black, gofmt, rustfmt
   - テストランナー: Jest, pytest, go test, cargo test

3. **フック設定の作成** `.claude/settings.json` に:
   - `PostToolUse` フック（編集後の自動フォーマット用）
   - `PreToolUse` フック（コミット前の検証用）
   - `SessionEnd` フック（最終品質チェック用）

4. **フックスクリプトの生成** `.claude/hooks/` に:
   - 言語固有のフォーマットスクリプト
   - テスト実行スクリプト
   - セキュリティ検証スクリプト

## 設定するフックタイプ

### PostToolUse フック（ファイル編集後に自動実行）
- **自動フォーマット**: 編集したファイルにフォーマッターを実行
- **自動リント**: 自動修正可能なリンターを実行
- **インクリメンタルテスト**: 変更されたファイルのテストを実行

### PreToolUse フック（アクション前の検証）
- **シークレット検出**: ハードコードされたシークレットを含むコミットをブロック
- **ファイル保護**: ロックファイル、.envファイルの編集を防止
- **リント検証**: コミット前にコードがリントを通過することを確認

### SessionEnd フック（クリーンアップと検証）
- **完全テストスイート**: 完全なテストスイートを実行
- **カバレッジレポート**: テストカバレッジレポートを生成
- **Gitステータス**: コミットされていない変更を表示

## プロジェクト固有の例

### Node.js/TypeScriptプロジェクト
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/format-typescript.sh"
          }
        ]
      }
    ]
  }
}
```

生成されるスクリプトは以下を実行:
- `prettier --write` でフォーマット
- `eslint --fix` で自動修正可能な問題を修正

### Pythonプロジェクト
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/format-python.sh"
          }
        ]
      }
    ]
  }
}
```

生成されるスクリプトは以下を実行:
- `ruff format` または `black` でフォーマット
- `ruff check --fix` で自動修正可能な問題を修正

## 設定の配置場所

コマンドは以下を作成します:
- `.claude/settings.json` - プロジェクトレベルのフック設定（チームで共有）
- `.claude/hooks/` - フックスクリプトファイル

これらはチーム共有のためにバージョン管理にコミット可能です。

## ベストプラクティス

- **最小限から開始**: まず自動フォーマットのみから始め、必要に応じてフックを追加
- **フックをテスト**: gitにコミットする前にフックが正しく動作することを確認
- **フックを文書化**: フックスクリプトに目的を説明するコメントを追加
- **チーム調整**: ワークフローに影響するフックを追加する前にチームと議論
- **パフォーマンス**: 開発を遅くしないよう、フックは高速（5秒未満）に保つ

## 要件

コマンドは必要なツールをチェックし、インストールされていない場合は警告します:
- Node.js: `npm`, `npx`, `prettier`, `eslint`
- Python: `ruff`, `black`, `pytest`
- Go: `gofmt`, `golangci-lint`
- Rust: `rustfmt`, `clippy`

## 追加ガイダンス

$ARGUMENTS
