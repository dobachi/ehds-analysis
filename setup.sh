#!/bin/bash
# EHDS包括レポート環境セットアップスクリプト
# 
# 使用方法:
#   ./setup.sh          # 対話的セットアップ
#   ./setup.sh --all    # すべてを自動インストール
#   ./setup.sh --check  # 環境チェックのみ
#   ./setup.sh --minimal # 最小構成（HTML/DOCXのみ）

set -e

# カラー定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# プロジェクトルートディレクトリ
PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"
QUARTO_DIR="${PROJECT_ROOT}/quarto-report"

# ロゴ表示
show_banner() {
    echo -e "${BLUE}"
    echo "======================================================"
    echo "   EHDS 包括的分析レポート - 環境セットアップ"
    echo "======================================================"
    echo -e "${NC}"
}

# 成功メッセージ
success() {
    echo -e "${GREEN}✓${NC} $1"
}

# エラーメッセージ
error() {
    echo -e "${RED}✗${NC} $1"
}

# 警告メッセージ
warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# 情報メッセージ
info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# 環境チェック関数
check_command() {
    local cmd=$1
    local pkg=$2
    local version_cmd=$3
    
    if command -v "$cmd" &> /dev/null; then
        if [ -n "$version_cmd" ]; then
            local version=$($version_cmd 2>&1 | head -n1)
            success "$cmd が見つかりました: $version"
        else
            success "$cmd が見つかりました"
        fi
        return 0
    else
        error "$cmd が見つかりません"
        if [ -n "$pkg" ]; then
            info "インストール方法: $pkg"
        fi
        return 1
    fi
}

# 環境チェック
check_environment() {
    echo -e "\n${BLUE}=== 環境チェック ===${NC}\n"
    
    local all_ok=true
    
    # 必須コマンド
    echo "【必須コマンド】"
    check_command "quarto" "https://quarto.org/docs/get-started/" "quarto --version" || all_ok=false
    check_command "pandoc" "sudo apt install pandoc" "pandoc --version" || all_ok=false
    check_command "make" "sudo apt install make" "make --version" || all_ok=false
    check_command "git" "sudo apt install git" "git --version" || all_ok=false
    
    # オプションコマンド
    echo -e "\n【オプションコマンド】"
    echo "● PDF生成用:"
    check_command "lualatex" "sudo apt install texlive-luatex" "lualatex --version" || true
    
    echo -e "\n● Mermaid図変換用:"
    check_command "mmdc" "npm install -g @mermaid-js/mermaid-cli" "mmdc --version" || true
    check_command "node" "https://nodejs.org/" "node --version" || true
    check_command "npm" "https://nodejs.org/" "npm --version" || true
    
    # Playwright確認（Mermaid用）
    if command -v mmdc &> /dev/null; then
        if [ -d "$HOME/.cache/ms-playwright" ]; then
            success "Playwright がインストール済みです"
        else
            warning "Playwright が未インストールです"
            info "インストール方法: npx playwright install chromium"
        fi
    fi
    
    # ファイル確認
    echo -e "\n【プロジェクトファイル】"
    if [ -f "${QUARTO_DIR}/_quarto.yml" ]; then
        success "_quarto.yml が存在します"
    else
        error "_quarto.yml が見つかりません"
        all_ok=false
    fi
    
    if [ -f "${QUARTO_DIR}/template.docx" ]; then
        success "template.docx が存在します"
    else
        warning "template.docx が見つかりません（DOCX生成時に必要）"
    fi
    
    if [ -f "${QUARTO_DIR}/references.bib" ]; then
        success "references.bib が存在します"
    else
        error "references.bib が見つかりません"
        all_ok=false
    fi
    
    if $all_ok; then
        echo -e "\n${GREEN}基本環境のチェックが完了しました！${NC}"
        return 0
    else
        echo -e "\n${RED}必須コンポーネントが不足しています${NC}"
        return 1
    fi
}

# Quartoインストール
install_quarto() {
    info "Quartoの最新版をインストールします..."
    
    # 最新リリースのURLを取得
    local latest_url=$(curl -s https://api.github.com/repos/quarto-dev/quarto-cli/releases/latest \
        | grep "browser_download_url.*linux-amd64.deb" \
        | cut -d '"' -f 4)
    
    if [ -z "$latest_url" ]; then
        error "QuartoのダウンロードURLを取得できませんでした"
        return 1
    fi
    
    # ダウンロードとインストール
    local tmp_file="/tmp/quarto.deb"
    info "ダウンロード中: $latest_url"
    wget -q -O "$tmp_file" "$latest_url"
    
    info "インストール中..."
    sudo dpkg -i "$tmp_file"
    rm "$tmp_file"
    
    success "Quartoをインストールしました"
}

# LaTeX環境セットアップ
setup_latex() {
    echo -e "\n${BLUE}=== LaTeX環境セットアップ ===${NC}\n"
    
    info "LaTeXパッケージをインストールします..."
    sudo apt update
    sudo apt install -y \
        texlive-luatex \
        texlive-fonts-extra \
        texlive-lang-japanese \
        fonts-noto-cjk
    
    success "LaTeX環境をセットアップしました"
}

# Mermaid環境セットアップ
setup_mermaid() {
    echo -e "\n${BLUE}=== Mermaid環境セットアップ ===${NC}\n"
    
    # Node.js確認
    if ! command -v node &> /dev/null; then
        warning "Node.jsがインストールされていません"
        info "Node.jsのインストールをスキップします（手動でインストールしてください）"
        return 1
    fi
    
    # mermaid-cli インストール
    info "Mermaid CLIをインストールします..."
    npm install -g @mermaid-js/mermaid-cli
    
    # Playwright インストール
    info "Playwrightをインストールします..."
    npx playwright install chromium
    
    success "Mermaid環境をセットアップしました"
}

# DOCXテンプレート生成
setup_docx_template() {
    echo -e "\n${BLUE}=== DOCXテンプレート生成 ===${NC}\n"
    
    if [ -f "${QUARTO_DIR}/template.docx" ]; then
        info "template.docx は既に存在します"
        return 0
    fi
    
    info "DOCXテンプレートを生成します..."
    cd "$QUARTO_DIR"
    pandoc --print-default-data-file reference.docx > template.docx
    cd "$PROJECT_ROOT"
    
    success "DOCXテンプレートを生成しました"
}

# 依存関係インストール
install_dependencies() {
    echo -e "\n${BLUE}=== 依存関係インストール ===${NC}\n"
    
    local packages=""
    
    # 基本パッケージ
    if ! command -v make &> /dev/null; then
        packages="$packages make"
    fi
    
    if ! command -v git &> /dev/null; then
        packages="$packages git"
    fi
    
    if ! command -v pandoc &> /dev/null; then
        packages="$packages pandoc"
    fi
    
    if [ -n "$packages" ]; then
        info "必要なパッケージをインストールします: $packages"
        sudo apt update
        sudo apt install -y $packages
        success "パッケージをインストールしました"
    else
        info "基本パッケージは全てインストール済みです"
    fi
}

# ビルドテスト
test_build() {
    echo -e "\n${BLUE}=== ビルドテスト ===${NC}\n"
    
    cd "$PROJECT_ROOT"
    
    # HTML
    info "HTMLビルドをテストしています..."
    if make html > /dev/null 2>&1; then
        success "HTMLビルド成功"
    else
        error "HTMLビルド失敗"
    fi
    
    # DOCX
    if [ -f "${QUARTO_DIR}/template.docx" ]; then
        info "DOCXビルドをテストしています..."
        if make docx > /dev/null 2>&1; then
            success "DOCXビルド成功"
        else
            error "DOCXビルド失敗"
        fi
    fi
    
    # PDF
    if command -v lualatex &> /dev/null; then
        info "PDFビルドをテストしています..."
        if make pdf > /dev/null 2>&1; then
            success "PDFビルド成功"
        else
            error "PDFビルド失敗"
        fi
    fi
    
    # 成果物確認
    echo -e "\n【生成された成果物】"
    if [ -d "build" ]; then
        ls -lh build/*.html 2>/dev/null && success "HTML生成確認" || true
        ls -lh build/*.docx 2>/dev/null && success "DOCX生成確認" || true
        ls -lh build/*.pdf 2>/dev/null && success "PDF生成確認" || true
    fi
}

# 対話的セットアップ
interactive_setup() {
    show_banner
    
    echo "このスクリプトはEHDSレポート生成環境をセットアップします。"
    echo ""
    echo "セットアップオプション:"
    echo "  1) 完全セットアップ（推奨）"
    echo "  2) 最小セットアップ（HTML/DOCXのみ）"
    echo "  3) 環境チェックのみ"
    echo "  4) 終了"
    echo ""
    read -p "選択してください [1-4]: " choice
    
    case $choice in
        1)
            info "完全セットアップを開始します..."
            check_environment || true
            install_dependencies
            
            if ! command -v quarto &> /dev/null; then
                read -p "Quartoをインストールしますか？ [y/N]: " yn
                if [[ $yn =~ ^[Yy]$ ]]; then
                    install_quarto
                fi
            fi
            
            setup_docx_template
            
            read -p "PDF生成環境（LaTeX）をセットアップしますか？ [y/N]: " yn
            if [[ $yn =~ ^[Yy]$ ]]; then
                setup_latex
            fi
            
            read -p "Mermaid図変換環境をセットアップしますか？ [y/N]: " yn
            if [[ $yn =~ ^[Yy]$ ]]; then
                setup_mermaid
            fi
            
            test_build
            ;;
        2)
            info "最小セットアップを開始します..."
            check_environment || true
            install_dependencies
            
            if ! command -v quarto &> /dev/null; then
                read -p "Quartoをインストールしますか？ [y/N]: " yn
                if [[ $yn =~ ^[Yy]$ ]]; then
                    install_quarto
                fi
            fi
            
            setup_docx_template
            test_build
            ;;
        3)
            check_environment
            ;;
        4)
            echo "終了します"
            exit 0
            ;;
        *)
            error "無効な選択です"
            exit 1
            ;;
    esac
}

# メイン処理
main() {
    case "${1:-}" in
        --all)
            show_banner
            info "完全自動セットアップを開始します..."
            install_dependencies
            
            if ! command -v quarto &> /dev/null; then
                install_quarto
            fi
            
            setup_docx_template
            setup_latex
            setup_mermaid || true
            test_build
            
            echo -e "\n${GREEN}セットアップが完了しました！${NC}"
            ;;
        --check)
            show_banner
            check_environment
            ;;
        --minimal)
            show_banner
            info "最小構成セットアップを開始します..."
            install_dependencies
            
            if ! command -v quarto &> /dev/null; then
                install_quarto
            fi
            
            setup_docx_template
            test_build
            
            echo -e "\n${GREEN}最小構成のセットアップが完了しました！${NC}"
            ;;
        --help|-h)
            echo "使用方法: $0 [オプション]"
            echo ""
            echo "オプション:"
            echo "  --all      完全自動セットアップ"
            echo "  --check    環境チェックのみ"
            echo "  --minimal  最小構成セットアップ"
            echo "  --help     このヘルプを表示"
            echo ""
            echo "オプションなしで実行すると対話的セットアップになります"
            ;;
        *)
            interactive_setup
            ;;
    esac
}

# 実行
main "$@"