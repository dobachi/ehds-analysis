# EHDS包括レポート - Docker環境
FROM ubuntu:22.04

LABEL maintainer="EHDS Report Team"
LABEL description="EHDS包括的分析レポート ビルド環境"

# 環境変数
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo
ENV LANG=ja_JP.UTF-8
ENV LC_ALL=ja_JP.UTF-8

# 基本パッケージインストール
RUN apt-get update && apt-get install -y \
    # 基本ツール
    curl \
    wget \
    git \
    make \
    locales \
    tzdata \
    # Python環境
    python3 \
    python3-pip \
    # Node.js環境（Mermaid用）
    nodejs \
    npm \
    # LaTeX環境（PDF生成用）
    texlive-luatex \
    texlive-fonts-extra \
    texlive-lang-japanese \
    fonts-noto-cjk \
    # Pandoc
    pandoc \
    && rm -rf /var/lib/apt/lists/*

# ロケール設定
RUN locale-gen ja_JP.UTF-8

# Quarto最新版インストール
RUN QUARTO_VERSION=$(curl -s https://api.github.com/repos/quarto-dev/quarto-cli/releases/latest | grep "tag_name" | cut -d '"' -f 4 | sed 's/v//') && \
    wget -q https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.deb && \
    dpkg -i quarto-${QUARTO_VERSION}-linux-amd64.deb && \
    rm quarto-${QUARTO_VERSION}-linux-amd64.deb

# 作業ディレクトリ設定
WORKDIR /workspace

# package.jsonとrequirements.txtをコピー
COPY package.json requirements.txt ./

# Node.js依存関係インストール
RUN npm install -g @mermaid-js/mermaid-cli && \
    npx playwright install chromium && \
    npx playwright install-deps

# Python依存関係インストール（オプション）
RUN pip3 install --no-cache-dir -r requirements.txt || true

# セットアップスクリプトをコピー
COPY setup.sh ./
RUN chmod +x setup.sh

# プロジェクトファイルをコピー
COPY . .

# DOCXテンプレート生成
RUN cd quarto-report && \
    pandoc --print-default-data-file reference.docx > template.docx || true

# ビルドコマンド
CMD ["make", "all"]