name: "計画PRPテンプレート - 図表付きPRD生成"
description: |

## 目的
図表を含む包括的なProduct Requirements Documents（PRD）を生成し、大まかなアイデアを実装PRP用の詳細な仕様に変換します。

## 哲学
1. **リサーチ優先**: 計画前にコンテキストを収集
2. **ビジュアル思考**: 図表を使用して概念を明確化
3. **組み込み検証**: 課題とエッジケースを含める
4. **実装準備完了**: 出力は他のPRPに直接フィード

---

## 初期コンセプト
$ARGUMENTS

## 計画プロセス

### フェーズ1: アイデア拡張とリサーチ

#### コンテキスト収集
```yaml
research_areas:
  market_analysis:
    - competitors: [類似ソリューションのリサーチ]
    - user_needs: [課題の特定]
    - trends: [現在の業界動向]

  technical_research:
    - existing_solutions: [他者の解決方法]
    - libraries: [利用可能なツール/フレームワーク]
    - patterns: [一般的な実装アプローチ]

  internal_context:
    - current_system: [現在の動作方法]
    - constraints: [技術的/ビジネス的制約]
    - integration_points: [連携が必要なもの]
```

#### 初期探索
```
類似ソリューションをRESEARCH:
  - WEB_SEARCH: "{concept} 実装例"
  - WEB_SEARCH: "{concept} ベストプラクティス"
  - WEB_SEARCH: "{concept} アーキテクチャパターン"

既存コードベースをANALYZE:
  - FIND: 既に実装されている類似機能
  - IDENTIFY: 従うべきパターン
  - NOTE: 技術的制約
```

### フェーズ2: PRD構造生成

#### 1. エグゼクティブサマリー
```markdown
## 問題文
[解決される問題の明確な説明]

## ソリューション概要
[提案されたソリューションの高レベル説明]

## 成功指標
- 指標1: [測定可能な成果]
- 指標2: [測定可能な成果]
- KPI: [主要業績評価指標]
```

#### 2. ユーザーストーリーとシナリオ
```markdown
## 主要ユーザーフロー
\```mermaid
graph LR
    A[ユーザーアクション] --> B{判断ポイント}
    B -->|パス1| C[結果1]
    B -->|パス2| D[結果2]
    D --> E[最終状態]
    C --> E
\```

## ユーザーストーリー
1. **[ユーザータイプ]として**、[アクション]したい、[利益]のために
   - 受け入れ基準:
     - [ ] 基準1
     - [ ] 基準2
   - エッジケース:
     - [エッジケース1]
     - [エッジケース2]
```

#### 3. システムアーキテクチャ
```markdown
## 高レベルアーキテクチャ
\```mermaid
graph TB
    subgraph "フロントエンド"
        UI[ユーザーインターフェース]
        State[状態管理]
    end

    subgraph "バックエンド"
        API[APIレイヤー]
        BL[ビジネスロジック]
        DB[(データベース)]
    end

    subgraph "外部"
        EXT[外部サービス]
    end

    UI --> API
    API --> BL
    BL --> DB
    BL --> EXT
    State --> UI
\```

## コンポーネント分解
- **フロントエンドコンポーネント**:
  - [コンポーネント1]: [目的]
  - [コンポーネント2]: [目的]

- **バックエンドサービス**:
  - [サービス1]: [目的]
  - [サービス2]: [目的]

- **データモデル**:
  - [モデル1]: [フィールドとリレーションシップ]
  - [モデル2]: [フィールドとリレーションシップ]
```

#### 4. 技術仕様
```markdown
## API設計
\```mermaid
sequenceDiagram
    participant U as ユーザー
    participant F as フロントエンド
    participant A as API
    participant D as データベース
    participant E as 外部サービス

    U->>F: アクション開始
    F->>A: POST /api/endpoint
    A->>D: データクエリ
    D-->>A: データ返却
    A->>E: 外部API呼び出し
    E-->>A: レスポンス
    A-->>F: 処理結果
    F-->>U: 結果表示
\```

## APIエンドポイント
### POST /api/endpoint
- **目的**: [エンドポイントの目的]
- **リクエスト**:
  ```json
  {
    "field1": "string",
    "field2": "number"
  }
  ```
- **レスポンス**:
  ```json
  {
    "status": "success",
    "data": {}
  }
  ```
- **エラー処理**:
  - 400: [不正なリクエスト]
  - 401: [認証エラー]
  - 500: [サーバーエラー]
```

#### 5. データモデル
```markdown
## データベーススキーマ
\```mermaid
erDiagram
    USER ||--o{ ORDER : places
    USER {
        int id PK
        string email
        string name
    }
    ORDER ||--|{ ORDER_ITEM : contains
    ORDER {
        int id PK
        int user_id FK
        datetime created_at
    }
    ORDER_ITEM {
        int id PK
        int order_id FK
        int product_id FK
        int quantity
    }
    PRODUCT ||--o{ ORDER_ITEM : "ordered in"
    PRODUCT {
        int id PK
        string name
        decimal price
    }
\```

## スキーマ詳細
- **User**:
  - Validation: Email format, unique email
  - Indexes: email (unique)

- **Order**:
  - Validation: user_id must exist
  - Indexes: user_id, created_at
```

### フェーズ3: 実装計画

#### 実装フェーズ
```markdown
## フェーズ1: 基盤構築
**目標**: 基本的なインフラストラクチャのセットアップ

**タスク**:
1. データベーススキーマの作成
2. 基本APIエンドポイントの実装
3. 認証システムのセットアップ

**成功基準**:
- [ ] データベースマイグレーション完了
- [ ] APIヘルスチェック動作
- [ ] 基本認証フロー動作

## フェーズ2: コア機能
**目標**: 主要ユーザーフローの実装

**タスク**:
1. ユーザー登録フロー
2. 主要機能の実装
3. エラー処理の追加

**成功基準**:
- [ ] ユーザーが登録できる
- [ ] 主要機能が動作する
- [ ] エラーが適切に処理される

## フェーズ3: 拡張と最適化
**目標**: 追加機能とパフォーマンス改善

**タスク**:
1. 追加機能の実装
2. パフォーマンス最適化
3. セキュリティ強化

**成功基準**:
- [ ] すべての機能が動作
- [ ] パフォーマンス目標達成
- [ ] セキュリティ監査合格
```

#### リスクと軽減策
```yaml
risks:
  technical:
    - risk: "パフォーマンスのボトルネック"
      mitigation: "早期にパフォーマンステスト実施"

    - risk: "外部API依存"
      mitigation: "フォールバック機構とキャッシング"

  business:
    - risk: "ユーザー採用が低い"
      mitigation: "MVP早期リリースとフィードバック収集"

  security:
    - risk: "データ侵害"
      mitigation: "暗号化と定期セキュリティ監査"
```

### フェーズ4: 検証と成功基準

#### 技術検証
```markdown
## 単体テスト
- カバレッジ目標: 80%以上
- 重要パス: 100%カバレッジ

## 統合テスト
- すべてのAPIエンドポイント
- 外部サービス統合
- エンドツーエンドフロー

## パフォーマンステスト
- レスポンスタイム: < 200ms (95パーセンタイル)
- スループット: > 1000 req/sec
- 同時ユーザー: 10,000人サポート
```

#### ユーザー受け入れ
```markdown
## UAT基準
- [ ] すべてのユーザーストーリーが完了
- [ ] エッジケースが処理される
- [ ] エラーメッセージが明確
- [ ] パフォーマンスが受け入れ可能
- [ ] セキュリティ要件が満たされる
```

### 付録

#### 技術スタック
```yaml
frontend:
  framework: [選択したフレームワーク]
  libraries:
    - [ライブラリ1]: [目的]
    - [ライブラリ2]: [目的]

backend:
  language: [言語]
  framework: [フレームワーク]
  database: [データベース]

infrastructure:
  hosting: [ホスティングプラットフォーム]
  ci_cd: [CI/CDツール]
  monitoring: [モニタリングツール]
```

#### 用語集
```markdown
- **用語1**: 定義
- **用語2**: 定義
```

#### 参考資料
```markdown
- [ドキュメント1]: URL
- [ドキュメント2]: URL
```

---

## 次のステップ

このPRDが完成したら:

1. レビューとフィードバック収集
2. 実装PRP作成（`/prp-create`使用）
3. フェーズ1の開始
4. 定期的なレビューと調整

---

## 品質チェックリスト

- [ ] 問題が明確に説明されている
- [ ] ソリューションが問題に対処している
- [ ] すべてのユーザーフローが図表化されている
- [ ] アーキテクチャが視覚化されている
- [ ] APIが完全に仕様化されている
- [ ] データモデルが含まれている
- [ ] 依存関係が特定されている
- [ ] リスクが特定され軽減策がある
- [ ] 成功指標が測定可能
- [ ] 実装フェーズが論理的
- [ ] 実装PRP準備完了
