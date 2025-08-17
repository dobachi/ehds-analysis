# EHDSレポート環境セットアップガイド

## 概要
このドキュメントでは、EHDSレポートをHTML/DOCX/PDF形式で生成するための環境セットアップ手順を説明します。

## 🚀 クイックスタート

### 自動セットアップ
```bash
# 完全セットアップ（推奨）
./setup.sh --all

# 最小構成（HTML/DOCXのみ）
./setup.sh --minimal

# 環境チェック
./setup.sh --check
```

### Dockerを使用したビルド
```bash
# Docker環境で全形式をビルド
docker-compose up ehds-report

# プレビューサーバー起動
docker-compose up ehds-preview
```

## 前提条件

### 必須
- Ubuntu/Debian系Linux（WSL2でも動作確認済み）
- Git
- Make

### 推奨
- Quarto 1.7以上
- Node.js 18以上（Mermaid図変換用）
- Docker（環境依存を避けたい場合）

## セットアップ手順

### 1. Quarto基本環境

#### 自動インストール
```bash
./setup.sh --all
# または
./setup.sh  # 対話的セットアップ
```

#### 手動インストール
```bash
# Quartoの最新版をダウンロードしてインストール
wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.7.32/quarto-1.7.32-linux-amd64.deb
sudo dpkg -i quarto-1.7.32-linux-amd64.deb
```

### 2. HTML生成環境
HTMLは追加パッケージなしで生成可能です。
```bash
# ビルドコマンド
make build
```

### 3. DOCX生成環境
初回実行時にテンプレートファイルの生成が必要です。

```bash
# テンプレートファイルの生成
cd quarto-report
pandoc --print-default-data-file reference.docx > template.docx

# DOCX生成
cd ..
make docx
```

### 4. PDF生成環境（LaTeX）

日本語PDFの生成にはLuaLaTeX環境が必要です。

#### 自動インストール
```bash
./setup.sh --all
# LaTeX環境も自動でセットアップされます
```
日本語PDFの生成にはLuaLaTeX環境が必要です。

#### 必要なパッケージのインストール
```bash
# LuaLaTeX本体
sudo apt update
sudo apt install texlive-luatex

# フォントパッケージ（fontawesome5等を含む）
sudo apt install texlive-fonts-extra

# 日本語環境（オプション、既にインストール済みの場合は不要）
sudo apt install texlive-lang-japanese
```

#### PDF生成
```bash
make pdf
```

## ビルドコマンド一覧

```bash
# 作業ディレクトリへ移動
cd /home/dobachi/Sources/memo-blog-text/research/topics/ehds-european-health-data-space

# HTML生成（デフォルト）
make build

# PDF生成
make pdf

# Word文書生成
make docx

# プレビューサーバー起動
make preview

# クリーンビルド
make clean && make build

# すべての形式を生成
make all
```

## 生成される成果物

| 形式 | ファイルパス | サイズ | 用途 |
|------|------------|--------|------|
| HTML | `build/index.html` 他 | 約1MB | Web公開、インタラクティブ閲覧 |
| DOCX | `build/EHDS（欧州健康データ空間）包括的分析レポート.docx` | 約1.5MB | 編集可能文書、企業配布 |
| PDF | `build/EHDS（欧州健康データ空間）包括的分析レポート.pdf` | 約2.0MB | 印刷、正式文書 |

## トラブルシューティング

### PDF生成時のエラー

#### エラー: `luatexbase.sty not found`
```bash
sudo apt install texlive-luatex
```

#### エラー: `fontawesome5.sty not found`
```bash
sudo apt install texlive-fonts-extra
```

#### エラー: `File template.docx not found`
```bash
cd quarto-report
pandoc --print-default-data-file reference.docx > template.docx
```

### 日本語フォントの問題
PDFで日本語が表示されない場合：
```bash
sudo apt install fonts-noto-cjk
```

## 環境確認コマンド

```bash
# Quartoバージョン確認
quarto --version

# Pandocバージョン確認
pandoc --version

# LuaLaTeX確認
lualatex --version

# インストール済みTeXパッケージ確認
dpkg -l | grep texlive
```

## 最小構成でのセットアップ

時間がない場合の最小構成：

```bash
# HTML/DOCXのみ（PDFなし）
# 追加パッケージ不要、Quartoのみで動作

# DOCXテンプレート生成
cd quarto-report
pandoc --print-default-data-file reference.docx > template.docx
cd ..

# ビルド
make build  # HTML
make docx   # DOCX
```

## 完全セットアップ

### 提供されているセットアップスクリプト

本プロジェクトには`setup.sh`が含まれており、以下の機能を提供します：

```bash
# 完全自動セットアップ
./setup.sh --all

# 対話的セットアップ
./setup.sh

# 環境チェック
./setup.sh --check

# 最小構成（HTML/DOCXのみ）
./setup.sh --minimal
```

スクリプトは以下を自動化します：
- 必要なパッケージのインストール
- Quartoの最新版インストール
- LaTeX環境のセットアップ
- Mermaid CLIのインストール
- DOCXテンプレートの生成
- ビルドテストの実行

## 推奨事項

1. **開発環境**: HTML形式でプレビューしながら作業
2. **配布用**: 用途に応じて適切な形式を選択
   - Web公開: HTML
   - 編集が必要: DOCX
   - 正式文書: PDF
3. **バックアップ**: `build/`ディレクトリの成果物を定期的にバックアップ

## Mermaid図の変換

本レポートではMermaid図をPNG形式に変換して使用しています。

### セットアップ
```bash
# npmを使用
npm install
npm run setup

# またはスクリプトで
./setup.sh --all
```

### 変換実行
```bash
# Makefile経由
make mermaid

# 直接実行
cd quarto-report
../scripts/convert-mermaid.sh images images
```

## Docker環境

環境依存を避けたい場合はDockerを使用できます。

### ビルド
```bash
# 全形式をビルド
docker-compose up ehds-report

# プレビューサーバー
docker-compose up ehds-preview
```

### Dockerイメージのビルド
```bash
# イメージをビルド
docker build -t ehds-report .

# コンテナで実行
docker run -v $(pwd)/build:/workspace/build ehds-report
```

---

**最終更新**: 2025年8月16日
**動作確認環境**: Ubuntu on WSL2, Quarto 1.7.32, LuaLaTeX 1.14.0, Docker 24.0