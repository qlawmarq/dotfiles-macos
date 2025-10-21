# Product Requirement Prompt (PRP) Framework

## PRP とは？

**Product Requirement Prompt (PRP)** は、AI コーディングエージェントが動作するソフトウェアを実装するために必要なすべてを提供する構造化されたプロンプトです。

従来の PRD（Product Requirements Document）は「何を」「なぜ」を明確にしますが、「どのように」は意図的に避けます。

PRP は、PRD の目標と正当性を維持しつつ、以下の 3 つの AI 重要レイヤーを追加します:

### 1. コンテキスト

- 正確なファイルパスと内容
- ライブラリバージョンとコンテキスト
- コードスニペットの例
- `ai_docs/`ディレクトリによるライブラリドキュメントのパイプイン

### 2. 実装詳細

- API エンドポイント、テストランナー、エージェントパターンの使用方法
- 型ヒント、依存関係、アーキテクチャパターン

### 3. 検証ゲート

- pytest、ruff、静的型チェックなどの決定的チェック
- 早期の品質管理で defect を早期に発見

## ディレクトリ構造

```
PRPs/
├── templates/          # PRPテンプレート
│   ├── prp_base.md    # 包括的実装用テンプレート
│   └── prp_task.md    # タスク特化テンプレート
├── ai_docs/           # プロジェクト固有ドキュメント
├── completed/         # 完了したPRP
└── *.md               # アクティブなPRP
```

## 使い方

### 1. PRP の作成

Claude Code で以下のコマンドを使用:

```
/prp-create [機能の説明]
```

または、テンプレートから手動で作成:

```bash
cp PRPs/templates/prp_base.md PRPs/my-feature.md
# PRPs/my-feature.md を編集
```

### 2. PRP の実行

```
/prp-execute PRPs/my-feature.md
```

## PRP ベストプラクティス

1. **コンテキストが王様**: 必要なドキュメント、例、注意点をすべて含める
2. **検証ループ**: AI が実行して修正できる実行可能なテスト/リントを提供
3. **情報密度**: コードベースのキーワードとパターンを使用
4. **段階的成功**: シンプルに始め、検証し、次に拡張

## ai_docs/ ディレクトリの使用

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

## 参考リンク

### Claude Code 公式ドキュメント

- [Claude Code 概要](https://docs.claude.com/en/docs/claude-code/overview)
- [カスタムスラッシュコマンド](https://docs.claude.com/en/docs/claude-code/slash-commands)
- [サブエージェント](https://docs.claude.com/en/docs/claude-code/sub-agents)
- [Hooks](https://docs.claude.com/en/docs/claude-code/hooks-guide)

## 要約

**PRP = PRD + curated codebase intelligence + agent/runbook**

PRP は、AI エージェントが初回で本番環境レディなコードを出荷するために必要な最小限のパッケージです。
