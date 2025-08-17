# Quarkdown環境セットアップガイド

## 1. 環境構築

### 必要要件
- Java 17以上
- Git
- テキストエディタ（VS Code推奨）

### インストール手順

#### Linux/Mac
```bash
# Quarkdownダウンロード
wget https://github.com/iamgio/quarkdown/releases/latest/download/quarkdown.jar -O ~/bin/quarkdown.jar

# 実行権限付与とエイリアス設定
echo 'alias quarkdown="java -jar ~/bin/quarkdown.jar"' >> ~/.bashrc
source ~/.bashrc

# 動作確認
quarkdown --version
```

#### Windows (WSL2)
```bash
# WSL2内で上記Linuxの手順を実行
# または、PowerShellで：
Invoke-WebRequest -Uri "https://github.com/iamgio/quarkdown/releases/latest/download/quarkdown.jar" -OutFile "$HOME\quarkdown.jar"
```

### VS Code拡張機能
```bash
# Markdown関連拡張機能（Quarkdown構文も部分的にサポート）
code --install-extension yzhang.markdown-all-in-one
code --install-extension bierner.markdown-preview-github-styles
code --install-extension davidanson.vscode-markdownlint
```

---

## 2. プロジェクト初期化

```bash
# プロジェクトディレクトリ作成
cd /home/dobachi/Sources/memo-blog-text/research/topics/ehds-european-health-data-space
mkdir -p quarkdown-report/{src,build,assets,data}

# 基本ファイル作成
cd quarkdown-report
touch main.qd
touch Makefile
touch .gitignore
```

### .gitignore
```
build/
*.pdf
*.html
*.log
.DS_Store
Thumbs.db
```

---

## 3. 開発ワークフロー

### 基本コマンド

#### コンパイル
```bash
# PDF生成（デフォルト）
quarkdown c main.qd

# HTML生成
quarkdown c main.qd --format html

# 出力先指定
quarkdown c main.qd -o build/report.pdf
```

#### 開発モード
```bash
# ライブプレビュー + ファイル監視
quarkdown c main.qd -p -w

# プレビューのみ
quarkdown c main.qd -p

# ファイル監視のみ
quarkdown c main.qd -w
```

### Makefileでの自動化
```makefile
.PHONY: all pdf html preview watch clean help

# デフォルトターゲット
all: pdf

# PDF生成
pdf:
	@echo "📄 Generating PDF..."
	@quarkdown c src/main.qd -o build/ehds-report.pdf

# HTML生成
html:
	@echo "🌐 Generating HTML..."
	@quarkdown c src/main.qd --format html -o build/ehds-report.html

# 企業向けバージョン
enterprise:
	@echo "🏢 Generating Enterprise Version..."
	@quarkdown c src/main.qd --set audience=enterprise -o build/ehds-enterprise.pdf

# 政府向けバージョン
government:
	@echo "🏛️ Generating Government Version..."
	@quarkdown c src/main.qd --set audience=government -o build/ehds-government.pdf

# ライブプレビュー
preview:
	@echo "👁️ Starting live preview..."
	@quarkdown c src/main.qd -p -w

# ファイル監視のみ
watch:
	@echo "👀 Watching for changes..."
	@quarkdown c src/main.qd -w

# クリーンアップ
clean:
	@echo "🧹 Cleaning build directory..."
	@rm -rf build/*

# ヘルプ
help:
	@echo "Available targets:"
	@echo "  make pdf        - Generate PDF report"
	@echo "  make html       - Generate HTML report"
	@echo "  make enterprise - Generate enterprise version"
	@echo "  make government - Generate government version"
	@echo "  make preview    - Start live preview with auto-reload"
	@echo "  make watch      - Watch files and recompile on change"
	@echo "  make clean      - Clean build directory"
	@echo "  make all        - Generate all formats"
```

---

## 4. トラブルシューティング

### よくある問題と解決策

#### Java バージョンエラー
```bash
# エラー: UnsupportedClassVersionError
# 解決: Java 17以上をインストール
sudo apt update
sudo apt install openjdk-17-jdk
```

#### 日本語フォント問題（PDF）
```bash
# エラー: 日本語が表示されない
# 解決: 日本語フォントをインストール
sudo apt install fonts-noto-cjk
```

#### メモリ不足
```bash
# エラー: OutOfMemoryError
# 解決: JVMメモリを増やす
java -Xmx2g -jar quarkdown.jar c main.qd
```

### デバッグモード
```bash
# 詳細ログ出力
quarkdown c main.qd --verbose

# エラーのスタックトレース表示
quarkdown c main.qd --debug
```

---

## 5. VS Code設定

### settings.json
```json
{
  "files.associations": {
    "*.qd": "markdown"
  },
  "editor.wordWrap": "on",
  "editor.rulers": [80, 120],
  "markdown.preview.breaks": true,
  "[markdown]": {
    "editor.defaultFormatter": "DavidAnson.vscode-markdownlint",
    "editor.formatOnSave": false
  }
}
```

### tasks.json（ビルドタスク）
```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Build PDF",
      "type": "shell",
      "command": "make pdf",
      "group": {
        "kind": "build",
        "isDefault": true
      },
      "problemMatcher": []
    },
    {
      "label": "Live Preview",
      "type": "shell",
      "command": "make preview",
      "problemMatcher": [],
      "isBackground": true
    }
  ]
}
```

### キーボードショートカット（keybindings.json）
```json
[
  {
    "key": "ctrl+shift+b",
    "command": "workbench.action.tasks.runTask",
    "args": "Build PDF"
  },
  {
    "key": "ctrl+shift+p",
    "command": "workbench.action.tasks.runTask",
    "args": "Live Preview"
  }
]
```

---

## 6. Git設定

### コミット前チェック（.git/hooks/pre-commit）
```bash
#!/bin/bash
# Quarkdown構文チェック
echo "Checking Quarkdown syntax..."
quarkdown c src/main.qd --check-only

if [ $? -ne 0 ]; then
    echo "❌ Quarkdown syntax error detected!"
    exit 1
fi

echo "✅ Syntax check passed"
```

---

## 7. 初回ビルドテスト

```bash
# セットアップ確認コマンド
cd quarkdown-report

# 1. Quarkdownバージョン確認
quarkdown --version

# 2. テストファイル作成
echo ".h1 {Test Document}" > test.qd
echo "This is a test." >> test.qd

# 3. コンパイルテスト
quarkdown c test.qd

# 4. 成功したら削除
rm test.qd test.pdf

echo "✅ Setup completed successfully!"
```

---

## 次のステップ

1. `main.qd`の作成開始
2. 変数・関数定義ファイルの作成
3. 最初のセクション執筆
4. ライブプレビューでの確認
5. バージョン管理への追加

---

更新日: 2025-01-08