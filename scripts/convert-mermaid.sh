#!/bin/bash

# Mermaid図(.mmd)をPNG画像に変換する汎用スクリプト
# 使用方法: ./convert-mermaid.sh [入力ディレクトリ] [出力ディレクトリ]

# デフォルトのディレクトリ設定
INPUT_DIR="${1:-images}"
OUTPUT_DIR="${2:-images}"

# ディレクトリが存在しない場合は作成
mkdir -p "$OUTPUT_DIR"

# mermaid-cliがインストールされているか確認
if ! command -v mmdc &> /dev/null; then
    echo "エラー: mermaid-cli (mmdc) がインストールされていません。"
    echo "以下のコマンドでインストールしてください："
    echo "  npm install -g @mermaid-js/mermaid-cli"
    echo ""
    echo "代替方法："
    echo "  1. https://mermaid.live/ にアクセス"
    echo "  2. ${INPUT_DIR}/*.mmd ファイルの内容をコピー＆ペースト"
    echo "  3. PNG画像としてダウンロード"
    echo "  4. ${OUTPUT_DIR}/ ディレクトリに保存"
    exit 1
fi

# .mmdファイルを検索して変換
found_files=0
for mmd_file in "$INPUT_DIR"/*.mmd; do
    # ファイルが存在するか確認
    if [ ! -f "$mmd_file" ]; then
        continue
    fi
    
    found_files=$((found_files + 1))
    
    # ファイル名を取得（拡張子なし）
    basename=$(basename "$mmd_file" .mmd)
    output_file="$OUTPUT_DIR/${basename}.png"
    
    echo "変換中: $mmd_file -> $output_file"
    
    # mmdcコマンドで変換
    # -w: 幅（ピクセル）
    # -b: 背景色
    # -t: テーマ（default, dark, forest, neutral）
    mmdc -i "$mmd_file" \
         -o "$output_file" \
         -w 1200 \
         -b white \
         -t default
    
    if [ $? -eq 0 ]; then
        echo "  ✓ 成功: $output_file"
    else
        echo "  ✗ 失敗: $mmd_file の変換に失敗しました"
    fi
done

if [ $found_files -eq 0 ]; then
    echo "警告: ${INPUT_DIR}/ に .mmd ファイルが見つかりませんでした。"
    echo ""
    echo "Mermaidファイルの作成例："
    echo "cat > ${INPUT_DIR}/example.mmd << 'EOF'"
    echo "graph TD"
    echo "    A[開始] --> B[処理]"
    echo "    B --> C[終了]"
    echo "EOF"
else
    echo ""
    echo "変換完了: ${found_files} 個のファイルを処理しました。"
fi