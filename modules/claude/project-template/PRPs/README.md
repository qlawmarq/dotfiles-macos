# Product Requirement Prompt (PRP) Framework

[日本語](#日本語) | [English](#english)

---

## 日本語

### PRPとは？

**Product Requirement Prompt (PRP)** は、AI コーディングエージェントが動作するソフトウェアを実装するために必要なすべてを提供する構造化されたプロンプトです。

従来のPRD（Product Requirements Document）は「何を」「なぜ」を明確にしますが、「どのように」は意図的に避けます。

PRPは、PRDの目標と正当性を維持しつつ、以下の3つのAI重要レイヤーを追加します:

#### 1. コンテキスト
- 正確なファイルパスと内容
- ライブラリバージョンとコンテキスト
- コードスニペットの例
- `ai_docs/`ディレクトリによるライブラリドキュメントのパイプイン

#### 2. 実装詳細
- APIエンドポイント、テストランナー、エージェントパターンの使用方法
- 型ヒント、依存関係、アーキテクチャパターン

#### 3. 検証ゲート
- pytest、ruff、静的型チェックなどの決定的チェック
- 早期の品質管理でdefectを早期に発見

### ディレクトリ構造

```
PRPs/
├── templates/          # PRPテンプレート
│   ├── prp_base.md    # 包括的実装用テンプレート
│   └── prp_task.md    # タスク特化テンプレート
├── scripts/
│   └── prp_runner.py  # PRP実行スクリプト
├── ai_docs/           # プロジェクト固有ドキュメント
├── completed/         # 完了したPRP
└── *.md               # アクティブなPRP
```

### 使い方

#### 1. PRPの作成

Claude Codeで以下のコマンドを使用:

```
/prp-create [機能の説明]
```

または、テンプレートから手動で作成:

```bash
cp PRPs/templates/prp_base.md PRPs/my-feature.md
# PRPs/my-feature.md を編集
```

#### 2. PRPの実行

```
/prp-execute PRPs/my-feature.md
```

または、prp_runnerスクリプトを使用:

```bash
# インタラクティブモード（開発推奨）
uv run PRPs/scripts/prp_runner.py --prp my-feature --interactive

# ヘッドレスモード（CI/CD用）
uv run PRPs/scripts/prp_runner.py --prp my-feature --output-format json
```

### PRPベストプラクティス

1. **コンテキストが王様**: 必要なドキュメント、例、注意点をすべて含める
2. **検証ループ**: AIが実行して修正できる実行可能なテスト/リントを提供
3. **情報密度**: コードベースのキーワードとパターンを使用
4. **段階的成功**: シンプルに始め、検証し、次に拡張

### ai_docs/ ディレクトリの使用

複雑なライブラリや統合パターンには、`ai_docs/`に簡潔なドキュメントを作成:

```bash
# 例: FastAPI統合パターン
cat > PRPs/ai_docs/fastapi_patterns.md << 'EOF'
# FastAPI Integration Patterns

## Async Endpoints
[コード例とベストプラクティス]

## Dependency Injection
[コード例とベストプラクティス]
EOF
```

### 参考リンク

#### Claude Code公式ドキュメント
- [Claude Code概要](https://docs.claude.com/en/docs/claude-code/overview)
- [カスタムスラッシュコマンド](https://docs.claude.com/en/docs/claude-code/slash-commands)
- [サブエージェント](https://docs.claude.com/en/docs/claude-code/sub-agents)
- [Hooks](https://docs.claude.com/en/docs/claude-code/hooks-guide)

---

## English

### What is a PRP?

**Product Requirement Prompt (PRP)** is a structured prompt that supplies an AI coding agent with everything needed to deliver working software.

A traditional PRD clarifies what the product must do and why customers need it, but deliberately avoids how it will be built.

A PRP keeps the goal and justification sections of a PRD yet adds three AI-critical layers:

#### 1. Context
- Precise file paths and content
- Library versions and context
- Code snippet examples
- Library documentation via `ai_docs/` directory

#### 2. Implementation Details
- How to use API endpoints, test runners, agent patterns
- Type hints, dependencies, architectural patterns

#### 3. Validation Gates
- Deterministic checks like pytest, ruff, static type checks
- Shift-left quality controls catch defects early

### Directory Structure

```
PRPs/
├── templates/          # PRP templates
│   ├── prp_base.md    # Comprehensive implementation template
│   └── prp_task.md    # Task-specific template
├── scripts/
│   └── prp_runner.py  # PRP execution script
├── ai_docs/           # Project-specific documentation
├── completed/         # Completed PRPs
└── *.md               # Active PRPs
```

### Usage

#### 1. Create a PRP

Use Claude Code command:

```
/prp-create [feature description]
```

Or manually from template:

```bash
cp PRPs/templates/prp_base.md PRPs/my-feature.md
# Edit PRPs/my-feature.md
```

#### 2. Execute a PRP

```
/prp-execute PRPs/my-feature.md
```

Or use prp_runner script:

```bash
# Interactive mode (recommended for development)
uv run PRPs/scripts/prp_runner.py --prp my-feature --interactive

# Headless mode (for CI/CD)
uv run PRPs/scripts/prp_runner.py --prp my-feature --output-format json
```

### PRP Best Practices

1. **Context is King**: Include ALL necessary documentation, examples, and caveats
2. **Validation Loops**: Provide executable tests/lints the AI can run and fix
3. **Information Dense**: Use keywords and patterns from the codebase
4. **Progressive Success**: Start simple, validate, then enhance

### Using ai_docs/ Directory

For complex libraries or integration patterns, create condensed documentation in `ai_docs/`:

```bash
# Example: FastAPI integration patterns
cat > PRPs/ai_docs/fastapi_patterns.md << 'EOF'
# FastAPI Integration Patterns

## Async Endpoints
[Code examples and best practices]

## Dependency Injection
[Code examples and best practices]
EOF
```

### Reference Links

#### Claude Code Official Documentation
- [Claude Code Overview](https://docs.claude.com/en/docs/claude-code/overview)
- [Custom Slash Commands](https://docs.claude.com/en/docs/claude-code/slash-commands)
- [Sub-agents](https://docs.claude.com/en/docs/claude-code/sub-agents)
- [Hooks](https://docs.claude.com/en/docs/claude-code/hooks-guide)

---

## Summary / 要約

**PRP = PRD + curated codebase intelligence + agent/runbook**

PRPは、AIエージェントが初回で本番環境レディなコードを出荷するために必要な最小限のパッケージです。

A PRP is the minimum viable packet an AI needs to plausibly ship production-ready code on the first pass.
