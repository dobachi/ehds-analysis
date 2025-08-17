# EHDS技術仕様 - FHIR実装ガイド（2025年8月調査）

## HL7 FHIR実装ガイドの最新状況

### 2025年5月28日の重要な進展
- HL7 Europeが4つのHL7 FHIR実装ガイド（IG）のレビュー期間を開始 [21]
- EHDSの要件と6つの優先データカテゴリーの技術仕様に対応
- グローバル標準であるHL7 FHIRのEU適用方法を定義

### EHDS優先データカテゴリー
「EHDS FHIR IGエコシステム」は以下の優先カテゴリーに対応 [21]：
1. 患者サマリー（Patient Summaries）
2. 電子処方箋（e-Prescriptions）
3. 電子調剤（e-Dispensations）
4. 医療画像・レポート（Medical Images/Reports）
5. 検査結果（Laboratory Results）
6. 退院報告書（Discharge Reports）

## MyHealth@EU統合仕様

### NCPeH API仕様
- MyHealth@EU HL7 FHIR実装ガイドがサービス仕様を記述 [22]
- ゲートウェイ（NCPeH）間通信のインターフェース仕様を含む
- HL7 FHIR技術に基づく新しいMyHealth@EUサービスに焦点
- ノード間通信のワンストップガイドを目指す [22]

### ベースライン要件
- HL7 Europe base FHIR実装ガイドがEU内実装のベースライン [21]
- 越境交換（MyHealth@EU）と国内レポート共有の両方に適用

## 具体的な実装ガイド

### 1. 検査結果（Laboratory Reports）
- **バージョン**: MyHealth@EU Laboratory Report v0.1.1 [22]
- **内容**: 欧州越境交換のための検査レポート表現方法を規定
- **基盤**: HL7 Europe Laboratory Report HL7 FHIR IGから派生
- **要件**: MyHealth@EU機能要件を満たす

### 2. 処方箋・調剤（Medication Prescription and Dispense）
- **バージョン**: v0.1.0-ballot [22]
- **目的**: 処方箋・調剤データの欧州標準を定義
- **用途**: 
  - 各国イニシアチブの調和促進
  - EEHRxF仕様の一部として使用
  - MyHealth@EUのEU越境サービスで使用

### 3. 画像診断（Imaging Studies）
- **目的**: EHDS要件への準拠 [21]
- **対象**: 医療画像研究と関連レポートの優先カテゴリー
- **仕様**: EU FHIR Imaging report

## 実装タイムライン

### 2027年3月まで
- 欧州委員会が技術仕様を定義する実施法令を公表予定 [21][1]

### 現在の作業（2025年8月）
- HL7 Europe、加盟国、ステークホルダーによる協働準備
- 基盤仕様の開発による相互運用可能な健康データ交換の実現
- EHDS目標の直接的な支援

## 技術的な特徴

### 標準化アプローチ
- グローバル標準（HL7 FHIR）のEU特有要件への適応
- 各国実装の調和と標準化
- MyHealth@EUインフラとの統合

### 相互運用性の確保
- EU Base/Coreプロファイル
- 各優先カテゴリー別の専門IGの開発
- 将来のEEHRxF（European EHR eXchange Format）の基盤

## 重要な留意点

### パブリックレビュープロセス
- 2025年5月28日にレビュー期間開始 [21]
- ステークホルダーからのフィードバック収集
- 実装前の品質保証プロセス

### 協力体制
- HL7 EuropeとIHE-Europeの連携強化 [21]
- 加盟国の専門家の参加
- 産業界との協働

## 文献参照
※ 番号は[REFERENCES.md](../REFERENCES.md)の文献番号に対応
- [1] EHDS Regulation (EU) 2025/327 - European Commission
- [21] HL7 Europe FHIR Implementation Guides for EHDS (2025/05/28)
- [22] MyHealth@EU NCPeH API Documentation

---
更新日: 2025年8月12日