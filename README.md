**⚠️ Beispiel-Repository**: Dieses Repository dient als Beispiel für das YouTube-Video "Wie Hacker die Sicherheitsmaßnahmen von LLMs umgehen". Der Code ist zu Demonstrationszwecken erstellt und zeigt potenzielle Sicherheitsrisiken auf.

**📁 Prompts**: Die verwendeten Prompts für die Demonstration sind im `Prompts/` Ordner zu finden.

# 🔐 Inconspicuous - Verschlüsselungstool

Ein effizientes, plattformübergreifendes Verschlüsselungstool für die Kommandozeile, das alle Dateien in einem Verzeichnis und dessen Unterverzeichnissen verschlüsselt oder entschlüsselt.

## ✨ Features

- **Plattformübergreifend**: Läuft auf Linux, Windows und macOS
- **Effizient**: Kleine Binary-Größe und schnelle Verarbeitung
- **Sicher**: AES-256-GCM Verschlüsselung mit PBKDF2 Key Derivation
- **Einfach**: Direkte Arbeit mit Dateien ohne Umbenennung oder Kopien
- **Flexibel**: Automatische Passwort-Generierung oder manuelle Eingabe
- **Rekursiv**: Verarbeitet alle Unterverzeichnisse automatisch

## 🚀 Schnellstart

### 1. Setup (Entwicklung)

```bash
# Setup-Skript ausführbar machen
chmod +x setup.sh

# Entwicklungsumgebung einrichten
./setup.sh
```

### 2. Kompilieren

```bash
# Alle Plattformen kompilieren
./compile.sh
```

### 3. Verwenden

```bash
# Verzeichnis verschlüsseln (mit generiertem Passwort)
./binaries/inconspicuous-linux-amd64 --encrypt --dir ./meine_daten --generate

# Verzeichnis entschlüsseln (mit bekanntem Passwort)
./binaries/inconspicuous-linux-amd64 --decrypt --dir ./meine_daten --password meinpasswort
```

## 📋 Unterstützte Plattformen

| Plattform | Architektur | Binary Name |
|-----------|-------------|-------------|
| Linux | ARM64 | `inconspicuous-linux-arm64` |
| Linux | x86-64 | `inconspicuous-linux-amd64` |
| Windows | x86-64 | `inconspicuous-windows-amd64.exe` |
| macOS | ARM64 | `inconspicuous-mac-arm64` |

## 🔧 Installation

### Automatische Installation

Das Setup-Skript installiert automatisch alle benötigten Komponenten:

```bash
./setup.sh
```

### Manuelle Installation

1. **Go installieren** (Version 1.21 oder höher):
   - Linux: `sudo apt-get install golang-go` oder [go.dev/dl](https://go.dev/dl/)
   - macOS: `brew install go`
   - Windows: [go.dev/dl](https://go.dev/dl/)

2. **Projekt klonen**:
   ```bash
   git clone <repository-url>
   cd inconspicuous
   ```

3. **Dependencies installieren**:
   ```bash
   go mod tidy
   ```

## 📖 Verwendung

### Grundlegende Syntax

```bash
inconspicuous --encrypt --dir <verzeichnis> [--password <passwort> | --generate]
inconspicuous --decrypt --dir <verzeichnis> [--password <passwort> | --generate]
```

### Optionen

| Option | Beschreibung |
|--------|-------------|
| `--encrypt` | Verzeichnis verschlüsseln |
| `--decrypt` | Verzeichnis entschlüsseln |
| `--dir` | Zielverzeichnis |
| `--password` | Passwort für Verschlüsselung/Entschlüsselung |
| `--generate` | Automatisch ein sicheres Passwort generieren |
| `--help` | Hilfe anzeigen |

### Beispiele

#### Verzeichnis verschlüsseln

```bash
# Mit generiertem Passwort
./inconspicuous-linux-amd64 --encrypt --dir ./daten --generate

# Mit eigenem Passwort
./inconspicuous-linux-amd64 --encrypt --dir ./daten --password meinpasswort
```

#### Verzeichnis entschlüsseln

```bash
# Mit bekanntem Passwort
./inconspicuous-linux-amd64 --decrypt --dir ./daten --password meinpasswort
```

#### Hilfe anzeigen

```bash
./inconspicuous-linux-amd64 --help
```

## 🔒 Sicherheit

### Verschlüsselungsalgorithmus

- **Algorithmus**: AES-256-GCM
- **Key Derivation**: PBKDF2 mit SHA-256
- **Salt**: 32 Bytes (zufällig generiert)
- **Nonce**: 12 Bytes (zufällig generiert)
- **Iterationen**: 10.000

### Sicherheitsmerkmale

- **Authenticated Encryption**: GCM-Modus bietet sowohl Verschlüsselung als auch Authentifizierung
- **Salt**: Jede Datei verwendet einen einzigartigen Salt
- **Nonce**: Jede Verschlüsselung verwendet eine einzigartige Nonce
- **Key Derivation**: Sichere Passwort-zu-Schlüssel-Konvertierung mit PBKDF2

### Dateiendung

Verschlüsselte Dateien erhalten die Endung `.encrypted`. Die ursprünglichen Dateien werden nach erfolgreicher Verschlüsselung gelöscht.

## 🛠️ Entwicklung

### Projektstruktur

```
inconspicuous/
├── main.go              # Hauptprogramm
├── go.mod               # Go Module Definition
├── go.sum               # Go Module Checksums
├── compile.sh           # Cross-Platform Compilation Script
├── setup.sh             # Development Setup Script
├── demo.sh              # Demo Script für YouTube
├── README.md            # Diese Datei
└── binaries/            # Kompilierte Binaries
    ├── inconspicuous-linux-arm64
    ├── inconspicuous-linux-amd64
    ├── inconspicuous-windows-amd64.exe
    └── inconspicuous-mac-arm64
```

### Kompilieren für eine spezifische Plattform

```bash
# Linux ARM64
GOOS=linux GOARCH=arm64 go build -o inconspicuous-linux-arm64 main.go

# Linux x86-64
GOOS=linux GOARCH=amd64 go build -o inconspicuous-linux-amd64 main.go

# Windows x86-64
GOOS=windows GOARCH=amd64 go build -o inconspicuous-windows-amd64.exe main.go

# macOS ARM64
GOOS=darwin GOARCH=arm64 go build -o inconspicuous-mac-arm64 main.go
```

### Tests

```bash
# Programm testen
go run main.go --help

# Lokale Kompilierung testen
go build -o inconspicuous main.go
./inconspicuous --help
```

## 📊 Performance

### Binary-Größen (optimiert)

- **Linux ARM64**: ~2.5 MB
- **Linux x86-64**: ~2.5 MB
- **Windows x86-64**: ~2.5 MB
- **macOS ARM64**: ~2.5 MB

### Optimierungen

- **Stripped Binaries**: Debug-Informationen entfernt
- **Static Linking**: Keine externen Abhängigkeiten
- **Optimized Compilation**: Go Compiler-Optimierungen aktiviert

## 🐛 Troubleshooting

### Häufige Probleme

#### "Go ist nicht installiert"
```bash
./setup.sh
```

#### "Permission denied"
```bash
chmod +x inconspicuous-linux-amd64
```

#### "Datei nicht gefunden"
- Prüfe, ob das Verzeichnis existiert
- Verwende absolute Pfade bei Bedarf

#### "Fehler beim Entschlüsseln"
- Prüfe, ob das Passwort korrekt ist
- Stelle sicher, dass die Dateien tatsächlich verschlüsselt sind

### Debug-Modus

Für detailliertere Fehlermeldungen:

```bash
go run main.go --encrypt --dir ./test --generate
```

## 📄 Lizenz

Dieses Projekt steht unter der MIT-Lizenz. Siehe [LICENSE](LICENSE) für Details.

## 🤝 Beitragen

1. Fork das Repository
2. Erstelle einen Feature Branch (`git checkout -b feature/amazing-feature`)
3. Committe deine Änderungen (`git commit -m 'Add amazing feature'`)
4. Push zum Branch (`git push origin feature/amazing-feature`)
5. Öffne einen Pull Request

## 📞 Support

Bei Fragen oder Problemen:

1. Prüfe die [Issues](../../issues) auf GitHub
2. Erstelle ein neues Issue mit detaillierter Beschreibung
3. Füge Systeminformationen und Fehlermeldungen hinzu

## 🔄 Changelog

### Version 1.0.0
- Initiale Version
- AES-256-GCM Verschlüsselung
- Cross-Platform Support
- Automatische Passwort-Generierung
- Rekursive Verzeichnisverarbeitung 