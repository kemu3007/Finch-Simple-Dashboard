# Finch Simple Dashboard (フィンチ・シンプル・ダッシュボード)

Finch Simple Dashboard is a macOS application that provides a graphical user interface (GUI) for managing containers using Finch CLI. This tool simplifies container, image, and volume management through an intuitive interface.

Finch Simple Dashboardは、Finch CLIを使用したコンテナ管理のためのグラフィカルユーザインタフェース（GUI）を提供するmacOSアプリケーションです。このツールは、直感的なインターフェースを通じてコンテナ、イメージ、ボリュームの管理を簡素化します。

## Features (主な機能)

- **Container Management (コンテナ管理)**: View and manage running or stopped containers. (稼働中または停止中のコンテナを管理、表示)
- **Image Management (イメージ管理)**: List and inspect Docker images with details like platform and size. (Dockerイメージを一覧表示し、プラットフォームやサイズなどの詳細を確認)
- **Volume Management (ボリューム管理)**: Display and manage volumes, including mount points and properties. (ボリュームを表示・管理し、マウントポイントやプロパティを確認)
- **Log Viewer (ログビューア)**: View logs related to specific containers in real-time. (特定のコンテナに関連するログをリアルタイムで表示)

## Technology Stack (使用技術)

- **SwiftUI**: For building the macOS user interface. (macOS向けのモダンなUI構築)
- **Foundation**: Backend logic for command execution and JSON parsing. (コマンド実行やJSONパースなどのバックエンドロジック)
- **Finch CLI**: As the backend for executing container management commands. (コンテナ操作コマンドのバックエンドとしてFinch CLIを使用)

## Setup (セットアップ)

### Requirements (必要条件)
- macOS 14.0 or later (macOS 14.0以降)
- Finch CLI or Docker CLI installed (Finch / Docker CLIがインストールされていること)

## Usage (使用方法)

1. [Releases](https://github.com/kemu3007/Finch-Simple-Dashboard/releases)ページにアクセスします。
2. 最新バージョンの`.app`ファイルをダウンロードします。
3. ダウンロードしたアプリケーションをアプリケーションフォルダに移動します。
4. アプリを起動し、Finch CLIのパスが正しく設定されていることを確認します（デフォルト: `/usr/local/bin/finch`）。

## Project Structure (プロジェクト構成)

- **Views**: Contains UI-related code, e.g., `ContentView.swift`, `ConfigView.swift`. (UI関連のコードが含まれています)
- **Models**: Defines data models for Finch CLI, e.g., `Image.swift`, `Container.swift`, `Volume.swift`. (Finch CLIのデータモデルを定義)
- **Assets**: Manages app icons and resources. (アプリのアイコンやリソースを管理)

## License (ライセンス)

This project is licensed under the Apache License 2.0. See the [LICENSE](./LICENSE) file for details. (このプロジェクトはApache License 2.0の下でライセンスされています。詳細は[LICENSE](./LICENSE)ファイルを参照してください)

## Contributing (貢献)

Contributions are welcome! Please file bug reports or feature requests via [Issues](https://github.com/kemu3007/Finch-Simple-Dashboard/issues). (貢献を歓迎します！バグ報告や機能追加の提案は[Issues](https://github.com/kemu3007/Finch-Simple-Dashboard/issues)から行ってください)
