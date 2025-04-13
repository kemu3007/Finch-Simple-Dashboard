# Finch Simple Dashboard

## English

### Overview

**Finch Simple Dashboard** is a macOS application that provides a graphical user interface (GUI) for managing containers using the Finch CLI. This tool simplifies container, image, and volume management through an intuitive interface.

### Features

- **Container Management**: View and manage running or stopped containers.
- **Image Management**: List and inspect Docker images with details like platform and size.
- **Volume Management**: Display and manage volumes, including mount points and properties.
- **Log Viewer**: View logs related to specific containers in real-time.

### Technology Stack

- **SwiftUI**: For building the macOS user interface.
- **Foundation**: Backend logic for command execution and JSON parsing.
- **Finch CLI**: As the backend for executing container management commands.

### Setup

#### Requirements

- macOS 14.0 or later  
- Finch CLI or Docker CLI installed

### Usage

1. Go to the [Releases](https://github.com/kemu3007/Finch-Simple-Dashboard/releases) page.  
2. Download the latest `.app` file.  
3. Move the downloaded app to your Applications folder.  
4. Launch the app and ensure that the path to the Finch CLI is correctly set (default: `/usr/local/bin/finch`).

### Project Structure

- **Views**: Contains UI-related code, e.g., `ContentView.swift`, `ConfigView.swift`.
- **Models**: Defines data models for Finch CLI, e.g., `Image.swift`, `Container.swift`, `Volume.swift`.
- **Assets**: Manages app icons and resources.

### License

This project is licensed under the Apache License 2.0. See the [LICENSE](./LICENSE) file for details.

### Contributing

Contributions are welcome! Please file bug reports or feature requests via [Issues](https://github.com/kemu3007/Finch-Simple-Dashboard/issues).

---

## 日本語

### 概要

**Finch Simple Dashboard**は、Finch CLIを使用したコンテナ管理のためのグラフィカルユーザインタフェース（GUI）を提供するmacOSアプリケーションです。このツールは、直感的なインターフェースを通じてコンテナ、イメージ、ボリュームの管理を簡素化します。

### 主な機能

- **コンテナ管理**: 稼働中または停止中のコンテナを管理、表示  
- **イメージ管理**: Dockerイメージを一覧表示し、プラットフォームやサイズなどの詳細を確認  
- **ボリューム管理**: ボリュームを表示・管理し、マウントポイントやプロパティを確認  
- **ログビューア**: 特定のコンテナに関連するログをリアルタイムで表示

### 使用技術

- **SwiftUI**: macOS向けのモダンなUI構築  
- **Foundation**: コマンド実行やJSONパースなどのバックエンドロジック  
- **Finch CLI**: コンテナ操作コマンドのバックエンドとして使用

### セットアップ

#### 必要条件

- macOS 14.0以降  
- Finch / Docker CLIがインストールされていること

### 使用方法

1. [Releases](https://github.com/kemu3007/Finch-Simple-Dashboard/releases)ページにアクセスします。  
2. 最新バージョンの`.app`ファイルをダウンロードします。  
3. ダウンロードしたアプリケーションをアプリケーションフォルダに移動します。  
4. アプリを起動し、Finch CLIのパスが正しく設定されていることを確認します（デフォルト: `/usr/local/bin/finch`）。

### プロジェクト構成

- **Views**: UI関連のコードが含まれています（例: `ContentView.swift`, `ConfigView.swift`）  
- **Models**: Finch CLIのデータモデルを定義（例: `Image.swift`, `Container.swift`, `Volume.swift`）  
- **Assets**: アプリのアイコンやリソースを管理

### ライセンス

このプロジェクトはApache License 2.0の下でライセンスされています。詳細は[LICENSE](./LICENSE)ファイルを参照してください。

### 貢献

貢献を歓迎します！バグ報告や機能追加の提案は[Issues](https://github.com/kemu3007/Finch-Simple-Dashboard/issues)から行ってください。
