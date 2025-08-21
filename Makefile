# EHDS Research Project Makefile for Quarto
# ==========================================
# 欧州健康データ空間（EHDS）調査プロジェクトのビルド管理（Quarto版）

# 設定
QUARTO := quarto
BUILD_DIR := build
REPORT_DIR := quarto-report
FINAL_DIR := final
TIMESTAMP := $(shell date +%Y%m%d_%H%M%S)

# 色定義（ターミナル出力用）
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[1;33m
NC := \033[0m # No Color

.PHONY: all clean build html watch preview serve check-deps help install-quarto mermaid

# デフォルトターゲット
all: check-deps mermaid html
	@echo "$(GREEN)✓ HTMLビルドが完了しました$(NC)"
	@echo "  - HTML: $(BUILD_DIR)/index.html"

# ヘルプ表示
help:
	@echo "$(GREEN)EHDS Research Project - Quarto Makefile Commands$(NC)"
	@echo ""
	@echo "$(YELLOW)基本コマンド:$(NC)"
	@echo "  make all        - HTMLでビルド"
	@echo "  make build      - HTMLレポートをビルド"
	@echo "  make html       - HTMLフォーマットでビルド"
	@echo "  make clean      - ビルド成果物をクリーン"
	@echo ""
	@echo "$(YELLOW)開発コマンド:$(NC)"
	@echo "  make mermaid    - Mermaid図をPNG画像に変換"
	@echo "  make watch      - ファイル変更を監視して自動ビルド"
	@echo "  make preview    - プレビューサーバー起動"
	@echo "  make serve      - 静的サーバーでレポート配信"
	@echo ""
	@echo "$(YELLOW)検証コマンド:$(NC)"
	@echo "  make check      - レポート構造の検証"
	@echo "  make stats      - レポート統計情報の表示"
	@echo ""
	@echo "$(YELLOW)配布コマンド:$(NC)"
	@echo "  make final      - 最終版レポートの生成"
	@echo "  make archive    - プロジェクト全体のアーカイブ作成"
	@echo ""
	@echo "$(YELLOW)セットアップ:$(NC)"
	@echo "  make install-quarto - Quartoのインストール"
	@echo "  make check-deps     - 依存関係のチェック"

# Quartoインストール
install-quarto:
	@echo "$(YELLOW)Quartoをインストール中...$(NC)"
	@if [ "$$(uname)" = "Linux" ]; then \
		wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.4.550/quarto-1.4.550-linux-amd64.deb; \
		sudo dpkg -i quarto-1.4.550-linux-amd64.deb; \
		rm quarto-1.4.550-linux-amd64.deb; \
	elif [ "$$(uname)" = "Darwin" ]; then \
		brew install quarto; \
	else \
		echo "$(RED)手動でQuartoをインストールしてください: https://quarto.org/docs/get-started/$(NC)"; \
	fi
	@echo "$(GREEN)✓ Quartoインストール完了$(NC)"

# 依存関係チェック
check-deps:
	@echo "$(YELLOW)依存関係をチェック中...$(NC)"
	@command -v $(QUARTO) >/dev/null 2>&1 || { echo "$(RED)Error: Quarto が見つかりません。'make install-quarto' を実行してください$(NC)"; exit 1; }
	@echo "  Quarto version: $$($(QUARTO) --version)"
	@command -v pandoc >/dev/null 2>&1 || { echo "$(YELLOW)Warning: Pandoc が見つかりません（Quartoに含まれています）$(NC)"; }
	@echo "$(GREEN)✓ 全ての依存関係が満たされています$(NC)"

# Mermaid図をPNG画像に変換
mermaid:
	@echo "$(YELLOW)Mermaid図をPNG画像に変換中...$(NC)"
	@if [ -x scripts/convert-mermaid.sh ]; then \
		cd $(REPORT_DIR) && ../scripts/convert-mermaid.sh images images; \
		echo "$(GREEN)✓ Mermaid図の変換完了$(NC)"; \
	else \
		echo "$(YELLOW)警告: Mermaid変換スクリプトが見つかりません$(NC)"; \
		echo "  scripts/convert-mermaid.sh が存在し、実行可能か確認してください"; \
	fi

# Mermaidソースファイルとターゲット画像を定義
MERMAID_SOURCES := $(wildcard $(REPORT_DIR)/images/*.mmd)
MERMAID_IMAGES := $(MERMAID_SOURCES:.mmd=.png)

# HTMLビルド（画像ファイルの依存関係を追加）
build html: check-deps $(MERMAID_IMAGES)
	@echo "$(YELLOW)HTMLレポートをビルド中...$(NC)"
	@cd $(REPORT_DIR) && $(QUARTO) render --to html
	@echo "$(GREEN)✓ HTMLビルド完了: $(BUILD_DIR)/index.html$(NC)"

# 個別の.mmdファイルから.pngを生成するルール
$(REPORT_DIR)/images/%.png: $(REPORT_DIR)/images/%.mmd
	@echo "$(YELLOW)Mermaid図を変換中: $< → $@$(NC)"
	@cd $(REPORT_DIR)/images && mmdc -i $$(basename $<) -o $$(basename $@)
	@echo "$(GREEN)✓ 変換完了: $@$(NC)"



# ファイル監視と自動ビルド
watch: check-deps mermaid
	@echo "$(YELLOW)ファイル変更を監視中... (Ctrl+C で紂了)$(NC)"
	@cd $(REPORT_DIR) && $(QUARTO) preview --no-browser

# プレビューサーバー起動
preview: check-deps mermaid
	@echo "$(YELLOW)プレビューサーバーを起動中...$(NC)"
	@echo "$(GREEN)URL: http://localhost:4000$(NC)"
	@cd $(REPORT_DIR) && $(QUARTO) preview

# 静的サーバー起動
serve: build
	@echo "$(GREEN)静的サーバーを起動中...$(NC)"
	@echo "$(YELLOW)URL: http://localhost:8000$(NC)"
	@cd $(BUILD_DIR) && python3 -m http.server 8000

# レポート構造の検証
check:
	@echo "$(YELLOW)レポート構造を検証中...$(NC)"
	@echo "- _quarto.yml の確認..."
	@test -f $(REPORT_DIR)/_quarto.yml || { echo "$(RED)✗ _quarto.yml が見つかりません$(NC)"; exit 1; }
	@echo "$(GREEN)  ✓ _quarto.yml$(NC)"
	@echo "- 章ファイルの確認..."
	@for file in index 01-introduction 02-regulatory-framework; do \
		test -f $(REPORT_DIR)/$$file.qmd || echo "$(YELLOW)  ! $$file.qmd が見つかりません$(NC)"; \
	done
	@echo "- BibTeXファイルの確認..."
	@test -f $(REPORT_DIR)/references.bib || echo "$(YELLOW)  ! references.bib が見つかりません$(NC)"
	@echo "$(GREEN)✓ 基本構造の検証完了$(NC)"

# レポート統計
stats: build
	@echo "$(GREEN)レポート統計情報:$(NC)"
	@echo "--------------------------------"
	@find $(REPORT_DIR) -name "*.qmd" -exec wc -l {} + | tail -1 | awk '{printf "Quartoファイル合計行数: %d\n", $$1}'
	@find sources -name "*.md" -exec wc -l {} + | tail -1 | awk '{printf "調査資料合計行数: %d\n", $$1}'
	@test -d $(BUILD_DIR) && du -sh $(BUILD_DIR) | awk '{printf "ビルドサイズ: %s\n", $$1}' || echo "ビルドサイズ: 未ビルド"
	@echo "--------------------------------"
	@echo "最終更新: $$(date '+%Y年%m月%d日 %H:%M:%S')"

# 最終版レポート生成
final: clean mermaid html
	@echo "$(YELLOW)最終版レポートを生成中...$(NC)"
	@mkdir -p $(FINAL_DIR)/$(TIMESTAMP)
	@cp -r $(BUILD_DIR)/* $(FINAL_DIR)/$(TIMESTAMP)/
	@echo "$(GREEN)✓ 最終版生成完了: $(FINAL_DIR)/$(TIMESTAMP)/$(NC)"

# プロジェクトアーカイブ
archive:
	@echo "$(YELLOW)プロジェクトをアーカイブ中...$(NC)"
	@tar -czf ehds-research_$(TIMESTAMP).tar.gz \
		--exclude='build' \
		--exclude='*.log' \
		--exclude='.git' \
		--exclude='_site' \
		--exclude='.quarto' \
		$(REPORT_DIR) sources *.md Makefile.quarto
	@echo "$(GREEN)✓ アーカイブ作成完了: ehds-research_$(TIMESTAMP).tar.gz$(NC)"

# クリーンアップ
clean:
	@echo "$(YELLOW)ビルド成果物をクリーンアップ中...$(NC)"
	@rm -rf $(BUILD_DIR)
	@rm -rf $(REPORT_DIR)/_site
	@rm -rf $(REPORT_DIR)/.quarto
	@find $(REPORT_DIR) -name "*.html" -not -path "*/site_libs/*" -delete 2>/dev/null || true
	@echo "$(GREEN)✓ クリーンアップ完了$(NC)"

# 完全クリーン
distclean: clean
	@echo "$(YELLOW)全ての生成物を削除中...$(NC)"
	@rm -rf $(FINAL_DIR)
	@find . -name "*.log" -delete
	@find . -name ".DS_Store" -delete
	@echo "$(GREEN)✓ 完全クリーンアップ完了$(NC)"

# Quarto設定の検証
validate-config:
	@echo "$(YELLOW)Quarto設定を検証中...$(NC)"
	@cd $(REPORT_DIR) && $(QUARTO) check
	@echo "$(GREEN)✓ 設定検証完了$(NC)"

# メタデータの更新
update-metadata:
	@echo "$(YELLOW)メタデータを更新中...$(NC)"
	@sed -i "s/date: \".*\"/date: \"$$(date +%Y-%m-%d)\"/" $(REPORT_DIR)/_quarto.yml
	@echo "$(GREEN)✓ 日付を $$(date +%Y-%m-%d) に更新$(NC)"

# デバッグ情報表示
debug:
	@echo "QUARTO: $(QUARTO)"
	@echo "BUILD_DIR: $(BUILD_DIR)"
	@echo "REPORT_DIR: $(REPORT_DIR)"
	@echo "TIMESTAMP: $(TIMESTAMP)"
	@echo ""
	@echo "Quarto バージョン:"
	@$(QUARTO) --version
	@echo ""
	@echo "Pandoc バージョン:"
	@$(QUARTO) pandoc --version | head -1
	@echo ""
	@echo "利用可能なフォーマット:"
	@cd $(REPORT_DIR) && $(QUARTO) render --help | grep -A5 "FORMAT"