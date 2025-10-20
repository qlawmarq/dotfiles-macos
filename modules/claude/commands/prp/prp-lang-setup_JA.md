---
description: このプロジェクト用の言語特化PRPコマンドを生成
argument-hint: [--type typescript|python|go|rust|auto]
allowed-tools: Read, Write, Glob, Bash
---

# 言語特化PRPコマンドのセットアップ

現在のプロジェクト用の言語またはフレームワーク特化のPRPコマンドとテンプレートを生成します。

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

3. **言語特化コマンドを作成** (`.claude/commands/prp-{lang}/`):
   - `{lang}-create.md` - 言語特化PRP作成
   - `{lang}-execute.md` - 言語特化PRP実行

4. **言語特化テンプレートを生成** (`PRPs/templates/`):
   - `prp_{lang}.md` - 以下を含む言語特化PRPテンプレート:
     - 言語特化検証コマンド
     - フレームワーク特化パターン
     - 言語/フレームワークの一般的な注意点

## 出力例

### TypeScriptプロジェクト

作成されるもの:
- `.claude/commands/prp-typescript/ts-create.md`
- `.claude/commands/prp-typescript/ts-execute.md`
- `PRPs/templates/prp_typescript.md`

テンプレートに含まれる内容:
```yaml
validation_commands:
  syntax: "npm run lint && npm run type-check"
  test: "npm test"
  build: "npm run build"

common_patterns:
  - 厳格なTypeScriptモードを使用
  - オブジェクト形状にはtypeよりinterfaceを優先
  - promiseよりasync/awaitを使用

gotchas:
  - "TypeScript strictモードは明示的な型が必要"
  - "ESLintとPrettierが競合する可能性 - eslint-config-prettierを使用"
```

### Pythonプロジェクト

作成されるもの:
- `.claude/commands/prp-python/py-create.md`
- `.claude/commands/prp-python/py-execute.md`
- `PRPs/templates/prp_python.md`

テンプレートに含まれる内容:
```yaml
validation_commands:
  syntax: "ruff check . && mypy ."
  test: "pytest tests/ -v"
  coverage: "pytest --cov=src tests/"

common_patterns:
  - 関数シグネチャに型ヒントを使用
  - PEP 8スタイルガイドに従う
  - モデルにdataclassesまたはPydanticを使用

gotchas:
  - "依存関係管理にuvを使用"
  - "仮想環境は分離されている - 実行前にアクティベート"
```

## 実装プロセス

1. プロジェクトタイプを検出または指定されたタイプを使用
2. 利用可能なツールをスキャン（リンター、フォーマッター、テストランナー）
3. `.claude/commands/prp-{lang}/` ディレクトリを作成
4. 以下を含む言語特化コマンドを生成:
   - ツール固有の検証コマンド
   - 言語固有のパターンと規約
   - エコシステムの一般的な注意点
5. `PRPs/templates/prp_{lang}.md` テンプレートを作成
6. 作成されたファイルと次のステップのサマリーを表示

## 言語特化機能

### TypeScript/JavaScript
- TypeScriptコンパイラ統合
- ESLintとPrettier設定
- Jest/Vitestテストパターン
- Next.js/React/Vueフレームワーク検出
- パッケージマネージャ検出（npm/pnpm/yarn/bun）

### Python
- Ruffリンティングとフォーマッティング
- Mypy型チェック
- pytestテストパターン
- 仮想環境ハンドリング
- Poetry/uv/pip検出

### Go
- gofmtフォーマッティング
- golangci-lint統合
- Goテストパターン
- モジュール構造

### Rust
- rustfmtフォーマッティング
- Clippyリンティング
- Cargoテストパターン
- ワークスペース検出

## セットアップ後の次のステップ

1. **言語特化コマンドを使用**:
   ```
   /{lang}-create ユーザー認証
   /{lang}-execute PRPs/user-auth.md
   ```

2. **テンプレートをカスタマイズ**: プロジェクト固有のニーズに合わせて`PRPs/templates/prp_{lang}.md`を編集

3. **フレームワーク特化パターンを追加**: フレームワーク（Next.js、FastAPIなど）を使用している場合、フレームワーク特化の検証とパターンを追加

## 重要な注意事項

- 言語特化コマンドは**プロジェクト固有**（`.claude/commands/`に保存）
- テンプレートは**プロジェクト固有**（`PRPs/templates/`に保存）
- これらのコマンドは同じ基盤のPRPフレームワークを使用し、言語特化のデフォルト設定を持つだけ
- 汎用の`/prp-create`と`/prp-execute`コマンドは引き続き使用可能

## ワークフロー例

```bash
# 1. PRPフレームワークを初期化
> /prp-init

# 2. 言語特化コマンドをセットアップ
> /prp-lang-setup --type typescript

# 3. 言語特化コマンドを使用
> /ts-create ユーザー登録用APIエンドポイント

# 4. TypeScript特化検証で実行
> /ts-execute PRPs/api-endpoint-for-user-registration.md
```

## 追加ガイダンス

$ARGUMENTS
