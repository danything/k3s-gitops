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

## Secret

各アプリの `*-secrets-sealed.yaml` は [Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets) で暗号化済み。
平文の Secret はコミットしない。
