# GitHub Pagesデプロイ手順

## 初回設定

1. `quarto-report/_quarto.yml`のURLを更新:
```yaml
website:
  site-url: "https://dobachi.github.io/ehds-analysis"
  repo-url: "https://github.com/dobachi/ehds-analysis"
```

2. GitHub Settings → Pages → Source を「GitHub Actions」に設定

## デプロイ

```bash
git add .
git commit -m "Update report"
git push
```

pushすると自動的にGitHub Actionsが起動し、サイトが更新される。

## 確認

- Actions タブで進行状況確認
- https://dobachi.github.io/ehds-analysis でアクセス

## ローカルプレビュー

```bash
cd quarto-report
quarto preview
```