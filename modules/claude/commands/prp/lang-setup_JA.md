---
description: このプロジェクト用の言語特化PRPコマンドを生成
category: prp
argument-hint: [--type typescript|python|go|rust|auto]
allowed-tools: Read, Write, Glob, Bash
---

# 言語特化 PRP コマンドのセットアップ

現在のプロジェクト用の言語またはフレームワーク特化した PRP コマンドとテンプレートに更新します。

`~/.claude/project-template/PRPs/README_JA.md`に PRP フレームワークの概要が記載されています。

PRP フレームワークが使用されていない場合は`~/.claude/commands/prp/prp-init.md`の実行を促して作業を中断できます。

## 使い方

プロジェクトタイプを自動検出:

```
/prp-lang-setup
```

または、プロジェクトタイプを指定:

```
/prp-lang-setup --type typescript
/prp-lang-setup --type python
/prp-lang-setup --type go
/prp-lang-setup --type rust
```

## このコマンドが行うこと

0. **プロジェクトの概要を把握**:

- `README.md`
- `CLAUDE.md`
- `AGENTS.md`

1. **プロジェクトタイプを検出**:

- `package.json` → TypeScript/JavaScript/Node.js
- `pyproject.toml` または `setup.py` → Python
- `go.mod` → Go
- `Cargo.toml` → Rust
- `Gemfile` → Ruby
- `pom.xml` または `build.gradle` → Java

2. **プロジェクトで利用可能なツールを特定**:

- リンター: ESLint、Ruff、golangci-lint、Clippy
- フォーマッター: Prettier、Black、gofmt、rustfmt
- テストランナー: Jest、pytest、Go test、Cargo test
- ビルドツール: tsc、webpack、setuptools、cargo

3. **既存の PRP フレームワークのコマンドとテンプレートを確認**:

- 更新が必要になる既存の PRP フレームワークの使用状況（コマンドとテンプレート）を確認する
- `PRPs/`フォルダが存在するか確認
  - 存在する場合はテンプレートの内容を確認
- `.claude/commands/`に PRP 関連のコマンドが存在するか確認
  - 存在する場合はコマンドの内容を確認
- 両方存在しない場合は、ユーザーに`/prp-init`コマンドの実行を促し作業を中断（`~/.claude/commands/prp/prp-init.md`が事前に実行されている前提）

4. **言語特化コマンドとテンプレートを生成** (`PRPs/templates/`):

- 既存の PRP フレームワークのコマンドとテンプレート存在する場合は既存テンプレートをを更新:
  - 以下を含む言語特化 PRP テンプレート:
    - 言語特化検証コマンド
    - フレームワーク特化パターン
    - 言語/フレームワークの一般的な注意点

## 実装プロセス

0. プロジェクトと PRP フレームワークの概要を理解
1. プロジェクトタイプを検出または指定されたタイプを使用
2. 利用可能なツールをスキャン（リンター、フォーマッター、テストランナー）
3. 既存の PRP フレームワークの使用状況の確認
4. 以下を含む言語特化コマンドとテンプレートの生成（既存の PRP フレームワークの更新）:
   - ツール固有の検証コマンド
   - 言語固有のパターンと規約
   - エコシステムの一般的な注意点
5. 作成されたファイルと次のステップのサマリーを表示

## 言語特化機能

### TypeScript/JavaScript

- TypeScript コンパイラ統合
- ESLint と Prettier 設定
- Jest/Vitest テストパターン
- Next.js/React/Vue フレームワーク検出
- パッケージマネージャ検出（npm/pnpm/yarn/bun）

### Python

- Ruff リンティングとフォーマッティング
- Mypy 型チェック
- pytest テストパターン
- 仮想環境ハンドリング
- Poetry/uv/pip 検出

### Go

- gofmt フォーマッティング
- golangci-lint 統合
- Go テストパターン
- モジュール構造

### Rust

- rustfmt フォーマッティング
- Clippy リンティング
- Cargo テストパターン
- ワークスペース検出

## 重要な注意事項

- コマンドは**プロジェクト固有**（`.claude/commands/`に保存）
- テンプレートは**プロジェクト固有**（`PRPs/templates/`に保存）
- これらのコマンドは同じ基盤の PRP フレームワークを使用し、言語特化のデフォルト設定を持つ

## 追加ガイダンス

$ARGUMENTS
