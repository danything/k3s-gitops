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

各アプリの `*-secrets.yaml` は [External Secrets Operator](https://external-secrets.io) の `ExternalSecret`。
値は Infisical（https://il.doany.io、`danything/bootstrap` の README 参照）のフォルダ
`/<namespace>/<Secret 名>`（例: `/erpnext/erpnext`、`/mattermost/mattermost`）にあり、
シークレット名がそのまま Secret のキーになる。平文の Secret も暗号化した Secret もコミットしない。

値を変えるときは Infisical の UI で書き換えるだけ。ESO が 1 時間ごとに取り直す（急ぐなら
`kubectl -n <ns> annotate externalsecret <name> force-sync=$(date +%s) --overwrite`）。
環境変数で読んでいるアプリ（mattermost など）は `kubectl rollout restart` で入れ替える。
