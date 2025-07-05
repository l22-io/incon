#!/bin/bash

# Inconspicuous - Cross-Platform Compilation Script
# Kompiliert das Verschlüsselungstool für Linux, Windows und Mac

set -e

echo "🔨 Inconspicuous - Cross-Platform Compilation"
echo "=============================================="

# Binaries Verzeichnis erstellen
mkdir -p binaries

# Go Module initialisieren und Dependencies herunterladen
echo "📦 Initialisiere Go Module..."
go mod tidy

# Compile Flags für optimierte Binaries
LDFLAGS="-s -w"

echo ""
echo "🚀 Starte Cross-Compilation..."

# Linux ARM64
echo "📱 Kompiliere für Linux ARM64..."
GOOS=linux GOARCH=arm64 go build -ldflags="$LDFLAGS" -o binaries/inconspicuous-linux-arm64 main.go

# Linux x86-64
echo "🐧 Kompiliere für Linux x86-64..."
GOOS=linux GOARCH=amd64 go build -ldflags="$LDFLAGS" -o binaries/inconspicuous-linux-amd64 main.go

# Windows x86-64
echo "🪟 Kompiliere für Windows x86-64..."
GOOS=windows GOARCH=amd64 go build -ldflags="$LDFLAGS" -o binaries/inconspicuous-windows-amd64.exe main.go

# Mac ARM64
echo "🍎 Kompiliere für Mac ARM64..."
GOOS=darwin GOARCH=arm64 go build -ldflags="$LDFLAGS" -o binaries/inconspicuous-mac-arm64 main.go

echo ""
echo "✅ Kompilierung abgeschlossen!"
echo ""
echo "📁 Erstellte Binaries:"
ls -la binaries/

echo ""
echo "📊 Binary Größen:"
for binary in binaries/*; do
    if [ -f "$binary" ]; then
        size=$(du -h "$binary" | cut -f1)
        echo "   $(basename "$binary"): $size"
    fi
done

echo ""
echo "🎯 Binaries sind bereit in: ./binaries/"
echo "💡 Verwende die passende Binary für deine Plattform:"
echo "   - Linux ARM64: ./binaries/inconspicuous-linux-arm64"
echo "   - Linux x86-64: ./binaries/inconspicuous-linux-amd64"
echo "   - Windows x86-64: ./binaries/inconspicuous-windows-amd64.exe"
echo "   - Mac ARM64: ./binaries/inconspicuous-mac-arm64" 