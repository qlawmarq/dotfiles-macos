---
description: 現在のプロジェクトにPRPディレクトリ構造を初期化
allowed-tools: Bash, Write, Read, Glob
---

# PRPフレームワークの初期化

現在のプロジェクトにProduct Requirement Prompt（PRP）フレームワークを初期化します。

## このコマンドが行うこと

1. 現在の作業ディレクトリに`PRPs/`ディレクトリ構造を作成
2. ユーザーレベル設定（`~/.claude/project-template/PRPs/`）からPRPテンプレートをコピー
3. 必要なサブディレクトリを作成（`templates/`, `scripts/`, `ai_docs/`, `completed/`）
4. PRPフレームワークのドキュメントを含むREADME.mdをコピー
5. 空のディレクトリに`.gitkeep`ファイルを作成

## 作成されるディレクトリ構造

```
PRPs/
├── templates/          # PRPテンプレート
│   ├── prp_base.md    # 包括的実装用テンプレート
│   ├── prp_base_JA.md # 日本語版
│   ├── prp_task.md    # タスク特化テンプレート
│   └── prp_task_JA.md # 日本語版
├── scripts/
│   └── prp_runner.py  # PRP実行スクリプト
├── ai_docs/           # プロジェクト固有ドキュメント
│   └── .gitkeep
├── completed/         # 完了したPRP
│   └── .gitkeep
└── README.md          # PRPフレームワークガイド
```

## 使い方

プロジェクトのルートディレクトリでこのコマンドを実行:

```
/prp-init
```

## 次に行うこと

初期化後:

1. **PRPを作成**: `/prp-create [機能]`を使用してPRPを生成
2. **PRPを実行**: `/prp-execute PRPs/my-feature.md`で実装
3. **AIドキュメントを追加**: `PRPs/ai_docs/`にライブラリ固有のドキュメントを配置
4. **完了したPRPを移動**: 完了したPRPは`PRPs/completed/`に移動

## 実装プロセス

1. PRPs/ディレクトリが既に存在するか確認（存在する場合は警告し、続行するか確認）
2. ディレクトリ構造を作成
3. `~/.claude/project-template/PRPs/`からすべてのテンプレートとスクリプトをコピー
4. 空のディレクトリに`.gitkeep`ファイルを作成
5. 次のステップを含む成功メッセージを表示

## 重要な注意事項

- このコマンドは**現在のプロジェクト**のためにPRPフレームワークを初期化します
- テンプレートはユーザーレベルのClaude Code設定からコピーされます
- `PRPs/`が既に存在する場合、上書き前にプロンプトが表示されます
- 初期化後、このプロジェクト固有のテンプレートをカスタマイズできます

## ワークフロー例

```bash
# 1. PRPフレームワークを初期化
> /prp-init
✓ PRPsディレクトリ構造が作成されました

# 2. 最初のPRPを作成
> /prp-create ユーザー認証システム

# 3. PRPを実行
> /prp-execute PRPs/user-authentication-system.md

# 4. 完了後
PRPs/user-authentication-system.md → PRPs/completed/
```

## 追加ガイダンス

$ARGUMENTS
