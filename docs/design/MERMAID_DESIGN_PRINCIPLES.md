# Mermaid図表のデザイン・配色原則

## 概要
本ドキュメントは、EHDS技術文書におけるMermaid図表のデザイン原則と配色ガイドラインを定義します。
IBM Design Language/Carbon Design Systemをベースに、WCAG 2.1アクセシビリティ基準を満たす配色を採用しています。

## 1. 基本原則

### 1.1 デザイン哲学
- **明確性**: 情報の階層と関係性を視覚的に明確化
- **一貫性**: 同じ意味の要素には同じスタイルを適用
- **アクセシビリティ**: すべてのユーザーが情報を理解できる設計
- **プロフェッショナル**: 技術文書に相応しい信頼感のあるデザイン

### 1.2 WCAG 2.1準拠
- **コントラスト比**: 最小3:1（グラフィック要素）、4.5:1（テキスト）
- **色以外の識別方法**: ボーダーの太さ、形状、ラベルで補完
- **カラーブラインド対応**: 赤緑色覚異常でも識別可能な配色

## 2. カラーパレット

### 2.1 プライマリカラー
```css
/* IBM Carbon Design System準拠 */
--primary-blue:     #0f62fe;  /* プライマリアクション */
--primary-blue-dark: #0043ce;  /* 強調・ボーダー */
--text-primary:     #161616;  /* メインテキスト */
--text-secondary:   #525252;  /* 補助テキスト */
--border-subtle:    #8d8d8d;  /* 控えめなボーダー */
```

### 2.2 セマンティックカラー
```css
/* 意味的な色の定義 */
--color-platform:   #d0e2ff;  /* プラットフォーム層（青系） */
--color-data:       #fff1f1;  /* データ層（赤系） */
--color-standard:   #defbe6;  /* 標準規格（緑系） */
--color-infra:      #f6f2ff;  /* インフラ層（紫系） */
--color-clinical:   #e5f6ff;  /* 臨床リソース（水色系） */
--color-admin:      #fff6e6;  /* 管理系（オレンジ系） */
```

### 2.3 ボーダーカラー
```css
/* 各要素のボーダー色 */
--border-platform:  #0043ce;  /* プラットフォーム */
--border-data:      #da1e28;  /* データ（注意喚起） */
--border-standard:  #198038;  /* 標準（成功・準拠） */
--border-infra:     #6929c4;  /* インフラ */
--border-clinical:  #0072c3;  /* 臨床 */
--border-admin:     #ee5a24;  /* 管理 */
```

## 3. 要素別スタイルガイド

### 3.1 技術スタック図
```mermaid
graph TB
    classDef app fill:#d0e2ff,stroke:#0043ce,stroke-width:2px,color:#161616
    classDef data fill:#fff1f1,stroke:#da1e28,stroke-width:3px,color:#161616
    classDef standard fill:#defbe6,stroke:#198038,stroke-width:2px,color:#161616
    classDef infra fill:#f6f2ff,stroke:#6929c4,stroke-width:2px,color:#161616
```

**使用ルール**:
- アプリケーション層: 青系（信頼・安定）
- データフォーマット層: 赤系（重要・注目）
- 標準規格層: 緑系（成功・準拠）
- インフラ基盤層: 紫系（技術的・高度）

### 3.2 FHIRリソース図
```mermaid
graph TB
    classDef clinical fill:#e5f6ff,stroke:#0072c3,stroke-width:2px,color:#161616
    classDef admin fill:#fff6e6,stroke:#ee5a24,stroke-width:2px,color:#161616
    classDef infra fill:#e8daff,stroke:#8a3ffc,stroke-width:2px,color:#161616
```

**使用ルール**:
- 臨床リソース: 水色系（医療・ケア）
- 管理リソース: オレンジ系（運用・管理）
- インフラリソース: 紫系（基盤・システム）

### 3.3 国際比較図
```mermaid
graph LR
    classDef euStyle fill:#d0e2ff,stroke:#0043ce,stroke-width:2px,color:#161616
    classDef jpStyle fill:#defbe6,stroke:#198038,stroke-width:2px,color:#161616
```

**使用ルール**:
- 欧州（EU）: 青系（EU旗の色を意識）
- 日本: 緑系（自然・調和）
- その他の国: 状況に応じて黄系、オレンジ系を使用

## 4. Mermaid実装テンプレート

### 4.1 基本設定
```javascript
%%{init: {
    'theme':'base', 
    'themeVariables': {
        'primaryColor':'#0f62fe',
        'primaryTextColor':'#161616',
        'primaryBorderColor':'#8d8d8d',
        'lineColor':'#525252',
        'secondaryColor':'#f4f4f4',
        'background':'#ffffff',
        'mainBkg':'#ffffff',
        'secondBkg':'#f4f4f4'
    }
}}%%
```

### 4.2 クラス定義例
```javascript
classDef highlight fill:#fff1f1,stroke:#da1e28,stroke-width:3px,color:#161616
classDef normal fill:#f4f4f4,stroke:#8d8d8d,stroke-width:1px,color:#161616
classDef success fill:#defbe6,stroke:#198038,stroke-width:2px,color:#161616
classDef warning fill:#fff6e6,stroke:#ee5a24,stroke-width:2px,color:#161616
```

## 5. アクセシビリティチェックリスト

- [ ] すべての色の組み合わせでWCAG 2.1 AAレベルのコントラスト比を満たしているか
- [ ] 色だけでなく、形状やラベルでも情報を伝えているか
- [ ] カラーブラインドシミュレーターでチェックしたか
- [ ] 白黒印刷でも情報が理解できるか
- [ ] ダークモードでも適切に表示されるか

## 6. 使用上の注意

### 6.1 避けるべきこと
- 純粋な赤と緑の組み合わせ（赤緑色覚異常で識別困難）
- 薄すぎる色（コントラスト不足）
- 10色以上の使い分け（認知負荷が高い）
- グラデーションの過度な使用（印刷時に問題）

### 6.2 推奨事項
- 重要度に応じてボーダーの太さを変える（1px, 2px, 3px）
- サブグラフの背景は薄いグレー（#f4f4f4）を使用
- テキストは常に濃いグレー（#161616）を使用
- ホバー効果は控えめに（brightness: 0.95）

## 7. 更新履歴

| 日付 | バージョン | 変更内容 |
|------|-----------|----------|
| 2025-08-13 | 1.0.0 | 初版作成。IBM Carbon Design Systemベースの配色を採用 |

## 8. 参考資料

- [IBM Design Language - Color](https://www.ibm.com/design/language/color/)
- [Carbon Design System](https://carbondesignsystem.com/elements/color/overview/)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [Accessible Data Visualization](https://accessibility.digital.gov/visual-design/data-visualizations/)

---

**メンテナンス**: このドキュメントは、EHDSプロジェクトのデザインガイドラインとして管理されています。
変更が必要な場合は、プロジェクトチームと協議の上、更新してください。