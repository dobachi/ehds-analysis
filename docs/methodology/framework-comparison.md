# ドキュメンテーションフレームワーク比較分析
## Quarkdown vs Quarto vs Markdown+Pandoc

---

## 1. フレームワーク概要

### 📘 Quarto
**特徴**
- RStudio社（現Posit）が開発
- 科学技術文書作成に特化
- R、Python、Julia、Observable JSの統合実行
- 多様な出力形式（HTML、PDF、Word、ePub、Reveal.js等）

**成熟度**: ⭐⭐⭐⭐⭐（非常に成熟）

### 🪐 Quarkdown
**特徴**
- Turing完全なMarkdown拡張
- 関数型プログラミング要素
- 動的コンテンツ生成
- 美しいPDF出力（paged.js）

**成熟度**: ⭐⭐⭐（発展中）

### 📝 Markdown + Pandoc
**特徴**
- 業界標準のシンプルさ
- 幅広いエコシステム
- 豊富なプラグイン
- 安定性と互換性

**成熟度**: ⭐⭐⭐⭐⭐（完全に成熟）

---

## 2. EHDSレポート要件との適合性

| 要件 | Quarto | Quarkdown | Markdown+Pandoc |
|------|--------|-----------|-----------------|
| **多言語対応** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| **複数読者層対応** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| **動的コンテンツ** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐ |
| **データ可視化** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ |
| **引用管理** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| **バージョン管理** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **コラボレーション** | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **学習コスト** | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **出力品質** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **エコシステム** | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐⭐ |

---

## 3. 🏆 推奨：Quarto（主軸）+ Quarkdown（実験的）

### なぜQuartoが最適か

#### 1. 専門家向けレポートに最適化
```yaml
project:
  type: book
  output-dir: _output

book:
  title: "EHDS分析レポート"
  subtitle: "日本の医療データスペース構築への示唆"
  author: "調査チーム"
  date: "2025-01-08"
  
  chapters:
    - index.qmd
    - part: "規制フレームワーク"
      chapters:
        - regulation/overview.qmd
        - regulation/gdpr.qmd
    - part: "技術実装"
      chapters:
        - tech/architecture.qmd
        - tech/standards.qmd

format:
  html:
    theme: cosmo
    toc: true
  pdf:
    documentclass: report
    papersize: a4
  docx:
    reference-doc: template.docx
```

#### 2. 条件付きコンテンツ（プロファイル機能）
```markdown
---
title: "EHDS概要"
---

::: {.content-visible when-profile="enterprise"}
## 技術詳細
HL7 FHIR R4実装における具体的な要件...
:::

::: {.content-visible when-profile="government"}
## 政策的含意
日本の医療DX推進における示唆...
:::
```

実行コマンド：
```bash
# 企業向け
quarto render --profile enterprise

# 政府向け
quarto render --profile government
```

#### 3. データ分析・可視化の統合
```{python}
#| label: fig-timeline
#| fig-cap: "EHDS実装タイムライン"

import pandas as pd
import plotly.express as px

timeline_data = pd.read_csv("data/ehds_timeline.csv")
fig = px.gantt(timeline_data, 
               x_start="start", 
               x_end="end", 
               y="country",
               title="各国のEHDS実装スケジュール")
fig.show()
```

#### 4. 相互参照と引用管理
```markdown
EHDSは@EC2022により提案され（図 @fig-timeline 参照）、
@sec-regulation で詳述する規制フレームワークに基づく。

## 規制フレームワーク {#sec-regulation}
```

---

## 4. 実装アーキテクチャ提案

### ディレクトリ構造
```
ehds-report/
├── _quarto.yml              # プロジェクト設定
├── _quarto-enterprise.yml   # 企業向けプロファイル
├── _quarto-government.yml   # 政府向けプロファイル
│
├── index.qmd               # トップページ
├── executive-summary.qmd   # エグゼクティブサマリー
│
├── chapters/
│   ├── 01-overview/
│   │   ├── index.qmd
│   │   └── _metadata.yml
│   ├── 02-regulation/
│   ├── 03-technology/
│   ├── 04-business/
│   └── 05-japan/
│
├── appendix/
│   ├── glossary.qmd
│   └── references.bib
│
├── data/                   # データファイル
│   ├── timeline.csv
│   └── statistics.xlsx
│
├── code/                   # 分析コード
│   ├── analysis.py
│   └── visualization.R
│
├── assets/
│   ├── images/
│   └── custom.scss
│
├── _freeze/                # 計算結果キャッシュ
└── _output/               # 出力ファイル
```

### _quarto.yml（メイン設定）
```yaml
project:
  type: book
  output-dir: _output
  
metadata-files:
  - _metadata.yml

book:
  title: "EHDS（欧州健康データ空間）分析レポート"
  subtitle: "日本の医療データスペース構築への示唆"
  author:
    - name: "調査チーム"
      affiliation: "組織名"
  date: today
  date-format: "YYYY年MM月DD日"
  
  repo-url: https://github.com/org/ehds-report
  repo-branch: main
  repo-actions: [edit, issue]
  
  chapters:
    - index.qmd
    - executive-summary.qmd
    - part: "第1部：総論"
      chapters:
        - chapters/01-overview/index.qmd
    - part: "第2部：規制"
      chapters:
        - chapters/02-regulation/index.qmd
    - part: "第3部：技術"
      chapters:
        - chapters/03-technology/index.qmd
    - part: "第4部：ビジネス"
      chapters:
        - chapters/04-business/index.qmd
    - part: "第5部：日本への示唆"
      chapters:
        - chapters/05-japan/index.qmd
    - references.qmd
    - appendix/glossary.qmd

bibliography: references.bib
csl: apa-7th.csl

format:
  html:
    theme: 
      light: flatly
      dark: darkly
    css: assets/custom.css
    toc: true
    toc-depth: 3
    number-sections: true
    code-fold: true
    code-tools: true
    
  pdf:
    documentclass: ltjsbook
    classoption: [a4paper, 11pt]
    geometry:
      - top=25mm
      - bottom=25mm
      - left=25mm
      - right=25mm
    toc: true
    toc-depth: 3
    number-sections: true
    colorlinks: true
    
  docx:
    reference-doc: templates/reference.docx
    toc: true
    toc-depth: 3
    number-sections: true

execute:
  freeze: auto
  cache: true
  echo: false
  warning: false
  
crossref:
  fig-title: "図"
  tbl-title: "表"
  eq-prefix: "式"
  sec-prefix: "節"
  
lang: ja
```

### プロファイル設定例（_quarto-enterprise.yml）
```yaml
profile:
  name: enterprise
  
metadata:
  audience: "IT企業技術者・事業企画担当者"
  detail-level: "high"
  include-technical: true
  include-code-examples: true
  
format:
  html:
    include-in-header:
      - text: |
          <style>
          .government-only { display: none; }
          </style>
  pdf:
    include-before-body:
      - text: |
          \newcommand{\audience}{企業向け詳細版}
```

### GitHub Actions
```yaml
name: Build Quarto Report

on:
  push:
    branches: [main]
  pull_request:

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - uses: quarto-dev/quarto-actions/setup@v2
      with:
        version: 1.4.0
        
    - uses: actions/setup-python@v4
      with:
        python-version: '3.11'
        
    - name: Install dependencies
      run: |
        pip install -r requirements.txt
        
    - name: Render Enterprise Version
      run: |
        quarto render --profile enterprise
        
    - name: Render Government Version  
      run: |
        quarto render --profile government
        
    - name: Deploy to GitHub Pages
      if: github.ref == 'refs/heads/main'
      uses: peaceiris/actions-gh-pages@v3
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        publish_dir: ./_output
```

---

## 5. Quarkdownの補完的活用

### 実験的機能として
```markdown
# 特定のセクションでQuarkdownを活用

## 動的な数値管理が必要な箇所
.let {investment = 500}
.let {timeline = 2025}

投資額：{investment}億ユーロ
実装年：{timeline}年
```

### 変換パイプライン
```bash
# Quarkdown → Markdown → Quarto
quarkdown c section.qd -o section.md
quarto render section.md
```

---

## 6. 意思決定マトリクス

| 判断基準 | Quarto | Quarkdown | ハイブリッド |
|---------|--------|-----------|------------|
| **即座に開始可能** | ✅ | ❌ | ✅ |
| **長期的な保守性** | ✅ | ⚠️ | ✅ |
| **チーム協業** | ✅ | ⚠️ | ✅ |
| **革新性** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **リスク** | 低 | 中 | 低〜中 |

---

## 7. 推奨実装計画

### Phase 1: Quarto基盤構築（Week 1-2）
- [ ] Quarto環境セットアップ
- [ ] 基本構造の実装
- [ ] プロファイル設定
- [ ] CI/CD構築

### Phase 2: コンテンツ移行（Week 3-4）
- [ ] 既存コンテンツのQMD変換
- [ ] データ分析コード統合
- [ ] 相互参照設定
- [ ] 引用管理

### Phase 3: 高度な機能（Week 5-6）
- [ ] インタラクティブ要素追加
- [ ] 条件付きコンテンツ実装
- [ ] 自動レポート生成

### Phase 4: Quarkdown実験（Optional）
- [ ] 動的セクションの特定
- [ ] Quarkdown試験実装
- [ ] 統合パイプライン構築

---

## 8. 結論

### 🎯 最終推奨
**Quartoをメインフレームワークとして採用**

理由：
1. **実績と安定性**: 科学技術文書作成の業界標準
2. **日本語対応**: 優れた多言語サポート
3. **データ統合**: Python/Rコードの直接実行
4. **エコシステム**: 豊富な拡張機能とコミュニティ
5. **将来性**: Posit社による継続的な開発

### 補完戦略
- **Quarkdown**: 特定の動的セクションで実験的に活用
- **Pandoc**: フォールバックとして維持

この組み合わせにより、安定性と革新性のバランスが取れた、持続可能なドキュメンテーション環境を構築できます。