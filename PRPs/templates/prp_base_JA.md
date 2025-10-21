name: "Shell/Bash PRP テンプレート - macOS dotfiles プロジェクト特化"
description: |

---

## 目標

**機能目標**: [構築すべき具体的で測定可能な最終状態]

**成果物**: [具体的な成果物 - 新しいモジュール、設定スクリプト、バックアップスクリプトなど]

**成功の定義**: [これが完了し動作していることをどのように確認するか]

## ユーザーペルソナ（該当する場合）

**対象ユーザー**: [具体的なユーザータイプ - macOS開発者、システム管理者など]

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

_この PRP を書く前に検証: 「このコードベースについて何も知らない人が、これを成功裏に実装するために必要なすべてを持っているか？」_

### ドキュメントと参照

```yaml
# 必読 - コンテキストウィンドウに含める
- file: CLAUDE.md
  why: プロジェクトのアーキテクチャ、モジュール構造、開発ガイドライン
  pattern: モジュール依存関係、Shell スクリプト規約、設定ファイルの場所

- file: AGENTS.md
  why: プロジェクト構造、ビルド/テストコマンド、コーディングスタイル
  pattern: Bash スクリプトの規約、インデント、ユーティリティの再利用

- file: modules/dependencies.txt
  why: モジュール間の依存関係定義
  pattern: 依存関係の宣言方法

- file: lib/utils.sh
  why: 共有ユーティリティ関数（print_info、success、error、confirm など）
  pattern: エラーハンドリング、カラー出力、macOS チェック

- file: lib/defaults.sh
  why: macOS defaults コマンドユーティリティ
  pattern: 設定管理のハイブリッド XML/テキストアプローチ

- file: modules/{existing_module}/apply.sh
  why: 既存モジュールのパターン参照
  pattern: スクリプト構造、エラーハンドリング、ユーザープロンプト

# プロジェクト固有ドキュメント
- docfile: [PRPs/ai_docs/shell_patterns.md]
  why: [Shell スクリプトのベストプラクティス]
  section: [特定セクション]
```

### 現在のコードベースツリー（プロジェクトのルートで`tree`を実行してコードベースの概要を取得）

```bash
# 例: tree -L 2 -a
```

### 追加するファイルとファイルの責任を含む望ましいコードベースツリー

```bash
# 例: 新しいモジュールを追加する場合
modules/
  ├── new_module/
  │   ├── apply.sh         # 設定適用スクリプト
  │   ├── backup.sh        # バックアップスクリプト（オプション）
  │   └── config_files/    # 設定ファイル（必要に応じて）
```

### コードベースとツールの既知の注意点

```bash
# 重要: Shell スクリプトは #!/bin/sh で POSIX 互換
# Bash 固有の機能は使用しない（配列、[[ ]]、プロセス置換など）

# 重要: macOS の defaults コマンドは再起動が必要な場合がある
# 例: Finder 設定変更後は `killall Finder` が必要

# 重要: パスは絶対パスではなく、SCRIPT_DIR と DOTFILES_DIR を使用
# 例: SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 重要: シンボリックリンク作成時は既存ファイルの確認とバックアップ
# 例: [ -e "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
```

## 実装設計図

### ファイル構造とスクリプトの責任

```bash
# 新しいモジュールの構造
modules/new_module/
├── apply.sh              # メインの適用スクリプト
│   - 設定の適用
│   - シンボリックリンクの作成
│   - アプリケーションの設定
│   - 必要に応じて再起動
│
├── backup.sh            # バックアップスクリプト（オプション）
│   - 現在の設定をファイルに保存
│   - defaults read でシステム設定を取得
│   - 設定ファイルのコピー
│
└── config/              # 設定ファイル（必要に応じて）
    ├── settings.txt     # 人間が読める形式の設定
    └── config.xml       # XML 形式の設定（必要に応じて）
```

### 実装タスク（依存関係順）

```yaml
タスク1: modules/{module_name}/ ディレクトリを作成
  - 実行: mkdir -p modules/{module_name}
  - 配置: modules/ ディレクトリ内
  - 権限: 必要に応じて chmod +x

タスク2: modules/{module_name}/apply.sh を作成
  - 実装: 設定適用スクリプト
  - パターンに従う: modules/{existing_module}/apply.sh
  - 必須要素:
    * shebang: #!/bin/sh
    * SCRIPT_DIR の定義
    * lib/utils.sh のソース
    * macOS チェック: check_macos
    * エラーハンドリング: set -e または手動確認
    * ユーザーフィードバック: print_info、success、error
  - 命名: 小文字、アンダースコア区切り
  - 配置: modules/{module_name}/

タスク3: modules/{module_name}/backup.sh を作成（オプション）
  - 実装: バックアップスクリプト
  - パターンに従う: modules/{existing_module}/backup.sh
  - 必須要素: apply.sh と同じ構造
  - 機能: 現在の設定をファイルに保存
  - 配置: modules/{module_name}/

タスク4: modules/dependencies.txt を更新
  - 追加: 新しいモジュールの依存関係
  - フォーマット: {module_name}: {dependency1} {dependency2}
  - 例: new_module: brew mise
  - 依存関係なしの場合: new_module:

タスク5: 設定ファイルを作成（必要に応じて）
  - 配置: modules/{module_name}/config/
  - フォーマット: 人間が読める形式（.txt）または必要に応じて XML
  - パターン: 既存モジュールの設定ファイルを参照

タスク6: スクリプトのテスト
  - 実行: bash -n modules/{module_name}/apply.sh
  - 構文チェック: shellcheck が利用可能な場合
  - 手動テスト: sh modules/{module_name}/apply.sh
  - 検証: 期待される設定が適用されているか確認
```

### 実装パターンと重要な詳細

```bash
#!/bin/sh
# 重要: POSIX 互換のため /bin/sh を使用

# パターン: スクリプトディレクトリの取得
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

# パターン: ユーティリティのソース
. "$DOTFILES_DIR/lib/utils.sh"

# パターン: macOS チェック
check_macos

# パターン: 情報表示
print_info "Setting up {module_name}..."

# パターン: エラーハンドリング
if ! command -v {required_tool} >/dev/null 2>&1; then
    print_error "{required_tool} is not installed"
    confirm "Continue anyway?" || exit 1
fi

# パターン: シンボリックリンク作成
create_symlink() {
    src="$1"
    dest="$2"

    if [ -e "$dest" ]; then
        print_warning "$dest already exists"
        confirm "Backup and replace?" || return
        mv "$dest" "${dest}.backup"
    fi

    ln -sf "$src" "$dest"
    print_success "Created symlink: $dest -> $src"
}

# パターン: defaults コマンドの使用
# 設定の適用
defaults write com.apple.{domain} {key} -bool {value}

# 設定の読み取り（backup.sh で使用）
defaults read com.apple.{domain} {key} > settings.txt

# パターン: アプリケーションの再起動
killall {ApplicationName}

# パターン: 成功メッセージ
print_success "{module_name} setup completed!"
```

### 統合ポイント

```yaml
DEPENDENCIES:
  - add to: modules/dependencies.txt
  - pattern: "{module_name}: {dependency1} {dependency2}"
  - validate: 循環依存がないことを確認

UTILITIES:
  - use from: lib/utils.sh
  - functions: print_info、success、error、warning、confirm、check_macos
  - use from: lib/defaults.sh（macOS 設定の場合）
  - functions: settings management utilities

ROOT_SCRIPTS:
  - integration: apply.sh と backup.sh が自動的に新しいモジュールを検出
  - no changes needed: モジュールが modules/ にあれば自動的に利用可能
```

## 検証ループ

### レベル 1: 構文とスタイル（即時フィードバック）

```bash
# 各スクリプト作成後に実行 - 続行前に修正

# 構文チェック
bash -n modules/{module_name}/apply.sh
bash -n modules/{module_name}/backup.sh

# ShellCheck（利用可能な場合）
shellcheck modules/{module_name}/apply.sh
shellcheck modules/{module_name}/backup.sh

# 実行権限の確認と設定
chmod +x modules/{module_name}/apply.sh
chmod +x modules/{module_name}/backup.sh

# 期待: 構文エラーゼロ、ShellCheck 警告ゼロ
```

### レベル 2: 単体テスト（コンポーネント検証）

```bash
# モジュールの適用テスト（dry-run または安全な環境で）
sh modules/{module_name}/apply.sh

# バックアップスクリプトのテスト
sh modules/{module_name}/backup.sh

# シンボリックリンクの確認
ls -la ~/{expected_symlink}

# 設定の確認（macOS defaults の場合）
defaults read com.apple.{domain} {key}

# 期待: スクリプトがエラーなく実行される
# 期待: シンボリックリンクが正しく作成される
# 期待: 設定が期待通りに適用される
```

### レベル 3: 統合テスト（システム検証）

```bash
# 完全な適用フローのテスト
sh apply.sh
# メニューから新しいモジュールを選択

# 依存関係解決の確認
# 出力に依存関係の正しい順序が表示されることを確認

# バックアップフローのテスト
sh backup.sh
# メニューから新しいモジュールを選択

# 設定ファイルの確認
cat modules/{module_name}/config/{settings_file}

# アプリケーション動作の確認
# 設定が適用されたアプリケーションを開いて動作確認

# 期待: 依存関係が正しい順序で解決される
# 期待: すべての設定が適用される
# 期待: バックアップが正常に作成される
```

### レベル 4: 創造的＆ドメイン固有の検証

```bash
# macOS 固有の検証

# Finder の再起動（Finder 設定の場合）
killall Finder
# 設定が適用されているか視覚的に確認

# システム環境設定の確認
# システム環境設定アプリを開いて設定を確認

# シェルの再起動（dotfiles の場合）
exec $SHELL -l
# 環境変数、エイリアス、関数が正しく読み込まれているか確認

# アプリケーションの起動（アプリ設定の場合）
open -a "{ApplicationName}"
# 設定が反映されているか確認

# Git 設定の確認（Git モジュールの場合）
git config --list | grep {expected_setting}

# Homebrew パッケージの確認（Brew モジュールの場合）
brew list | grep {expected_package}

# Claude Desktop MCP の確認（Claude モジュールの場合）
cat "$HOME/Library/Application Support/Claude/claude_desktop_config.json"
tail -f "$HOME/Library/Logs/Claude/mcp*.log"

# 期待: すべての設定が視覚的に確認できる
# 期待: アプリケーションが期待通りに動作する
```

## 最終検証チェックリスト

### 技術検証

- [ ] 4 つの検証レベルすべてが正常に完了
- [ ] 構文エラーなし: `bash -n modules/{module_name}/*.sh`
- [ ] ShellCheck 警告なし: `shellcheck modules/{module_name}/*.sh`（利用可能な場合）
- [ ] 実行権限設定済み: `ls -l modules/{module_name}/*.sh`
- [ ] POSIX 互換性確認: Bash 固有の機能を使用していない

### 機能検証

- [ ] 「何を」セクションのすべての成功基準が満たされている
- [ ] 手動テストが成功: `sh modules/{module_name}/apply.sh`
- [ ] シンボリックリンクが正しく作成されている
- [ ] macOS 設定が適用されている（該当する場合）
- [ ] バックアップスクリプトが動作する（該当する場合）
- [ ] アプリケーションの再起動が正常に動作する（該当する場合）

### コード品質検証

- [ ] CLAUDE.md と AGENTS.md のガイドラインに従っている
- [ ] lib/utils.sh のユーティリティ関数を再利用している
- [ ] 既存のコードベースパターンと命名規則に従っている
- [ ] ファイル配置が望ましいディレクトリ構造と一致
- [ ] 依存関係が modules/dependencies.txt に正しく定義されている
- [ ] エラーハンドリングが適切に実装されている

### ドキュメントとデプロイメント

- [ ] スクリプトにコメントが適切に記載されている
- [ ] エラーメッセージが明確で理解しやすい
- [ ] README.md が更新されている（新しいモジュールの場合）
- [ ] 新しい環境変数が文書化されている（該当する場合）

---

## 避けるべきアンチパターン

- ❌ #!/bin/bash を使用しない - POSIX 互換のため #!/bin/sh を使用
- ❌ Bash 固有の機能（配列、[[]]、プロセス置換など）を使用しない
- ❌ ハードコードされた絶対パスを使用しない - SCRIPT_DIR と DOTFILES_DIR を使用
- ❌ lib/utils.sh のユーティリティ関数を再実装しない - 既存のものを再利用
- ❌ シンボリックリンク作成時に既存ファイルをチェックせずに上書きしない
- ❌ macOS チェックをスキップしない - check_macos を使用
- ❌ エラーメッセージなしでサイレントに失敗しない - print_error を使用
- ❌ ユーザー確認なしで破壊的な操作を実行しない - confirm を使用
- ❌ 依存関係を modules/dependencies.txt に定義せずに他のモジュールに依存しない
- ❌ apply.sh の実行後にアプリケーションの再起動が必要な場合に通知しない
