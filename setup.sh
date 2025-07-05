#!/bin/bash

# Inconspicuous - Development Setup Script
# Installiert alle benötigten Komponenten für die Entwicklung

set -e

echo "🔧 Inconspicuous - Development Setup"
echo "===================================="

# Funktion zur Erkennung des Betriebssystems
detect_os() {
    case "$(uname -s)" in
        Linux*)     echo "linux";;
        Darwin*)    echo "macos";;
        CYGWIN*)    echo "windows";;
        MINGW*)     echo "windows";;
        MSYS*)      echo "windows";;
        *)          echo "unknown";;
    esac
}

# Funktion zur Erkennung der Architektur
detect_arch() {
    case "$(uname -m)" in
        x86_64)     echo "amd64";;
        aarch64)    echo "arm64";;
        arm64)      echo "arm64";;
        *)          echo "unknown";;
    esac
}

OS=$(detect_os)
ARCH=$(detect_arch)

echo "🖥️  Erkanntes System: $OS ($ARCH)"

# Go Installation prüfen
check_go() {
    if command -v go &> /dev/null; then
        GO_VERSION=$(go version | awk '{print $3}')
        echo "✅ Go ist installiert: $GO_VERSION"
        return 0
    else
        echo "❌ Go ist nicht installiert"
        return 1
    fi
}

# Go installieren (Linux)
install_go_linux() {
    echo "📦 Installiere Go für Linux..."
    
    # Prüfe ob wget verfügbar ist
    if ! command -v wget &> /dev/null; then
        echo "📥 Installiere wget..."
        sudo apt-get update
        sudo apt-get install -y wget
    fi
    
    # Go herunterladen und installieren
    GO_VERSION="1.21.5"
    GO_ARCH="amd64"
    if [ "$ARCH" = "arm64" ]; then
        GO_ARCH="arm64"
    fi
    
    echo "📥 Lade Go $GO_VERSION ($GO_ARCH) herunter..."
    wget -q "https://go.dev/dl/go${GO_VERSION}.linux-${GO_ARCH}.tar.gz" -O /tmp/go.tar.gz
    
    echo "🔧 Installiere Go..."
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf /tmp/go.tar.gz
    
    # PATH für aktuelle Session setzen
    export PATH=$PATH:/usr/local/go/bin
    
    # PATH permanent setzen
    if ! grep -q "/usr/local/go/bin" ~/.bashrc; then
        echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
    fi
    
    if ! grep -q "/usr/local/go/bin" ~/.zshrc; then
        echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.zshrc
    fi
    
    echo "✅ Go Installation abgeschlossen"
}

# Go installieren (macOS)
install_go_macos() {
    echo "📦 Installiere Go für macOS..."
    
    if command -v brew &> /dev/null; then
        echo "🍺 Verwende Homebrew..."
        brew install go
    else
        echo "📥 Installiere Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        brew install go
    fi
    
    echo "✅ Go Installation abgeschlossen"
}

# Go installieren (Windows)
install_go_windows() {
    echo "📦 Installiere Go für Windows..."
    echo "⚠️  Bitte installiere Go manuell von: https://go.dev/dl/"
    echo "   Nach der Installation, starte diese Konsole neu und führe das Setup erneut aus."
    exit 1
}

# Hauptinstallation
echo ""
echo "🔍 Prüfe Go Installation..."

if check_go; then
    echo "✅ Go ist bereits installiert"
else
    echo "📦 Go Installation erforderlich..."
    
    case $OS in
        "linux")
            install_go_linux
            ;;
        "macos")
            install_go_macos
            ;;
        "windows")
            install_go_windows
            ;;
        *)
            echo "❌ Nicht unterstütztes Betriebssystem: $OS"
            exit 1
            ;;
    esac
    
    # Go Installation erneut prüfen
    if ! check_go; then
        echo "❌ Go Installation fehlgeschlagen"
        echo "💡 Bitte starte deine Konsole neu und führe das Setup erneut aus"
        exit 1
    fi
fi

# Go Module initialisieren
echo ""
echo "📦 Initialisiere Go Module..."
if [ -f "go.mod" ]; then
    echo "✅ go.mod bereits vorhanden"
else
    go mod init inconspicuous
fi

go mod tidy

# Compile Script ausführbar machen
echo ""
echo "🔧 Mache Compile Script ausführbar..."
chmod +x compile.sh

echo ""
echo "✅ Setup abgeschlossen!"
echo ""
echo "🚀 Du kannst jetzt das Projekt kompilieren mit:"
echo "   ./compile.sh"
echo ""
echo "📚 Weitere Informationen findest du in der README.md" 