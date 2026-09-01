# k3s-gitops

k3s クラスタ上のセルフホストアプリを [Argo CD](https://argo-cd.readthedocs.io/) で管理するマニフェスト群。

## 仕組み

`danything/bootstrap` の ApplicationSet (`argocd/appsets/repos.yaml`) が org 内のリポジトリを走査し、
このリポジトリ直下の [`k3s/argocd.yaml`](k3s/argocd.yaml) を見つけて Argo CD の Application を生成する。
そのため、このリポジトリがどうデプロイされるか(同期対象パス・autoSync 等)は
クラスタ側ではなく `k3s/argocd.yaml` で決まる。ルート以下のマニフェストが再帰的に同期される。

## アプリ

| ディレクトリ | 内容 |
| --- | --- |
| [`adguardhome/`](adguardhome/) | AdGuard Home (DNS フィルタ) |
| [`cloudflare-ddns/`](cloudflare-ddns/) | DDNS |
| [`erpnext/`](erpnext/) | ERPNext (Helm chart + OIDC セットアップ) |
| [`mattermost/`](mattermost/) | Mattermost + PostgreSQL |
| [`portainer/`](portainer/) | Portainer |
| [`wireguard/`](wireguard/) | wg-easy (WireGuard VPN) |
| [`3proxy/`](3proxy/) | 3proxy (国内IP経由の HTTPS フォワードプロキシ) |

## Secret

各アプリの `*-secrets-sealed.yaml` は [Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets) で暗号化済み。
平文の Secret はコミットしない。

値を変えるときは、直接編集せず GitHub Secrets (`ERPNEXT_*` / `MATTERMOST_*`) を更新して、
対応する `.github/workflows/reseal-<app>.yml` を Actions から `workflow_dispatch` で実行する。
`danything` org の Actions variable `SEALED_SECRETS_CERT`(公開鍵、クラスタへの問い合わせ不要)で
kubeseal し、結果をこのリポジトリへコミットする。詳しくは `danything/bootstrap` の README。
