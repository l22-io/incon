#!/bin/bash

# Inconspicuous - YouTube Demo Script
# Zeigt die Funktionalität des Verschlüsselungstools

set -e

# Farben für bessere Darstellung
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Prüfe, ob INTERACTIVE gesetzt ist, sonst Standard: true
if [ -z "$INTERACTIVE" ]; then
    INTERACTIVE=true
fi

# Funktionen
print_header() {
    echo -e "${CYAN}========================================${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}========================================${NC}"
}

print_step() {
    echo -e "${YELLOW}➤ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

wait_for_user() {
    if [ "$INTERACTIVE" = "true" ]; then
        echo -e "${PURPLE}⏸️  Drücke Enter um fortzufahren...${NC}"
        read -r
    else
        sleep 2
    fi
}

# Architektur erkennen
detect_arch() {
    case "$(uname -m)" in
        x86_64)     echo "amd64";;
        aarch64)    echo "arm64";;
        arm64)      echo "arm64";;
        *)          echo "unknown";;
    esac
}

ARCH=$(detect_arch)
BINARY_NAME="inconspicuous-linux-${ARCH}"

# Prüfe ob Binary existiert
if [ ! -f "binaries/$BINARY_NAME" ]; then
    print_error "Binary $BINARY_NAME nicht gefunden!"
    print_info "Führe zuerst ./compile.sh aus"
    exit 1
fi

# Workbench Verzeichnis
WORKBENCH_DIR="Workbench"

print_header "🔐 Inconspicuous - Verschlüsselungstool Demo"
echo ""
print_info "Plattform: $(uname -s) ($(uname -m))"
print_info "Binary: $BINARY_NAME"
echo ""

wait_for_user

# Workbench bereinigen
print_step "Bereinige Workbench Verzeichnis..."
if [ -d "$WORKBENCH_DIR" ]; then
    rm -rf "$WORKBENCH_DIR"
fi
mkdir -p "$WORKBENCH_DIR"
print_success "Workbench bereinigt"

wait_for_user

# Demo-Dateien erstellen
print_step "Erstelle Demo-Dateien..."

# Hauptverzeichnis Dateien
cat > "$WORKBENCH_DIR/README.txt" << 'EOF'
# Projekt Dokumentation

Dies ist eine wichtige Projekt-Dokumentation mit sensiblen Informationen.
Hier werden alle wichtigen Details über das Projekt gespeichert.

## Wichtige Notizen:
- API-Schlüssel: sk-1234567890abcdef
- Datenbank-Passwort: supergeheim123
- Admin-Zugang: admin/admin123

Diese Datei enthält vertrauliche Informationen und sollte geschützt werden.
EOF

cat > "$WORKBENCH_DIR/config.json" << 'EOF'
{
  "database": {
    "host": "localhost",
    "port": 5432,
    "name": "production_db",
    "user": "admin",
    "password": "geheim123"
  },
  "api": {
    "endpoint": "https://api.example.com",
    "key": "sk-prod-abcdef123456",
    "secret": "prod_secret_key_789"
  },
  "security": {
    "encryption_key": "aes-256-key-here",
    "jwt_secret": "jwt_super_secret_key"
  }
}
EOF

# Unterverzeichnisse erstellen
mkdir -p "$WORKBENCH_DIR/documents"
mkdir -p "$WORKBENCH_DIR/backups"
mkdir -p "$WORKBENCH_DIR/logs"

# Documents Verzeichnis
cat > "$WORKBENCH_DIR/documents/meeting_notes.txt" << 'EOF'
# Meeting Notizen - Vertraulich

## Projektbesprechung vom 15. März 2024

### Teilnehmer:
- CEO: John Smith
- CTO: Maria Garcia
- CFO: Robert Johnson

### Besprochene Punkte:
1. Budget für Q2: 2.5 Millionen Euro
2. Neue Mitarbeiter: 15 Entwickler einstellen
3. Markteinführung: September 2024
4. Konkurrenzanalyse: Hauptkonkurrent ist TechCorp

### Vertrauliche Informationen:
- Geplante Übernahme von StartupXYZ für 50 Millionen
- Neue Patentanmeldung für AI-Algorithmus
- Geheime Partnerschaft mit Google Cloud

Diese Informationen sind streng vertraulich!
EOF

cat > "$WORKBENCH_DIR/documents/strategy.pdf" << 'EOF'
%PDF-1.4
1 0 obj
<<
/Type /Catalog
/Pages 2 0 R
>>
endobj

2 0 obj
<<
/Type /Pages
/Kids [3 0 R]
/Count 1
>>
endobj

3 0 obj
<<
/Type /Page
/Parent 2 0 R
/MediaBox [0 0 612 792]
/Contents 4 0 R
>>
endobj

4 0 obj
<<
/Length 44
>>
stream
BT
/F1 12 Tf
72 720 Td
(Strategie Dokument - Vertraulich) Tj
ET
endstream
endobj

xref
0 5
0000000000 65535 f 
0000000009 00000 n 
0000000058 00000 n 
0000000115 00000 n 
0000000204 00000 n 
trailer
<<
/Size 5
/Root 1 0 R
>>
startxref
295
%%EOF
EOF

# Backups Verzeichnis
cat > "$WORKBENCH_DIR/backups/database_dump.sql" << 'EOF'
-- Datenbank Backup - Vertraulich
-- Erstellt am: 2024-03-15 14:30:00

-- Benutzer Tabelle
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sensible Daten
INSERT INTO users (username, email, password_hash) VALUES
('admin', 'admin@company.com', '$2a$12$hashed_password_here'),
('john.doe', 'john@company.com', '$2a$12$another_hash'),
('jane.smith', 'jane@company.com', '$2a$12$third_hash');

-- Finanzdaten
CREATE TABLE financial_data (
    id SERIAL PRIMARY KEY,
    account_number VARCHAR(20) NOT NULL,
    balance DECIMAL(15,2) NOT NULL,
    transaction_date TIMESTAMP NOT NULL
);

INSERT INTO financial_data (account_number, balance, transaction_date) VALUES
('DE12345678901234567890', 1500000.00, '2024-03-15 10:00:00'),
('DE09876543210987654321', 2500000.00, '2024-03-15 11:00:00');
EOF

# Logs Verzeichnis
cat > "$WORKBENCH_DIR/logs/application.log" << 'EOF'
2024-03-15 10:00:00 [INFO] Application started
2024-03-15 10:01:00 [INFO] Database connection established
2024-03-15 10:02:00 [INFO] User admin logged in from IP 192.168.1.100
2024-03-15 10:03:00 [INFO] Sensitive operation: Payment processed for account DE12345678901234567890
2024-03-15 10:04:00 [INFO] API key used: sk-prod-abcdef123456
2024-03-15 10:05:00 [INFO] Database backup completed
2024-03-15 10:06:00 [ERROR] Failed login attempt from IP 203.0.113.45
2024-03-15 10:07:00 [WARN] Unusual activity detected from IP 198.51.100.23
2024-03-15 10:08:00 [INFO] Security audit completed
2024-03-15 10:09:00 [INFO] Application shutdown
EOF

print_success "Demo-Dateien erstellt"
echo ""

wait_for_user

# Verzeichnisstruktur anzeigen
print_step "Zeige Verzeichnisstruktur..."
echo ""
tree "$WORKBENCH_DIR" || find "$WORKBENCH_DIR" -type f | sort
echo ""

wait_for_user

# Dateien anzeigen
print_step "Zeige Inhalt einiger Dateien..."
echo ""
print_info "README.txt:"
head -5 "$WORKBENCH_DIR/README.txt"
echo ""
print_info "config.json:"
head -10 "$WORKBENCH_DIR/config.json"
echo ""

wait_for_user

# Verschlüsselung starten
print_header "🔒 VERSCHLÜSSELUNG"
print_step "Starte Verschlüsselung mit automatisch generiertem Passwort..."
echo ""

# Verschlüsselung ausführen und Passwort speichern
PASSWORD=$(./binaries/$BINARY_NAME --encrypt --dir "$WORKBENCH_DIR" --generate 2>&1 | grep "Generiertes Passwort" | sed 's/.*: //')
echo ""
print_info "Gespeichertes Passwort für Demo: $PASSWORD"
echo ""

wait_for_user

# Verzeichnisstruktur nach Verschlüsselung
print_step "Verzeichnisstruktur nach Verschlüsselung:"
echo ""
tree "$WORKBENCH_DIR" || find "$WORKBENCH_DIR" -type f | sort
echo ""

wait_for_user

# Verschlüsselte Dateien anzeigen
print_step "Zeige Inhalt einer verschlüsselten Datei..."
echo ""
print_info "README.txt.encrypted (erste 50 Bytes):"
head -c 50 "$WORKBENCH_DIR/README.txt.encrypted" | hexdump -C
echo ""

wait_for_user

# Entschlüsselung
print_header "🔓 ENTSCHLÜSSELUNG"
print_step "Starte Entschlüsselung..."
echo ""

# Passwort für Demo verwenden (in echten Szenarien würde man das Passwort speichern)
print_info "Hinweis: In der Demo verwenden wir das generierte Passwort erneut."
print_info "In der Praxis würden Sie das Passwort sicher speichern."
echo ""

wait_for_user

# Entschlüsselung ausführen (mit dem gespeicherten Passwort)
print_info "Verwende gespeichertes Passwort: $PASSWORD"
./binaries/$BINARY_NAME --decrypt --dir "$WORKBENCH_DIR" --password "$PASSWORD"

echo ""
wait_for_user

# Verzeichnisstruktur nach Entschlüsselung
print_step "Verzeichnisstruktur nach Entschlüsselung:"
echo ""
tree "$WORKBENCH_DIR" || find "$WORKBENCH_DIR" -type f | sort
echo ""

wait_for_user

# Dateien überprüfen
print_step "Überprüfe Dateien nach Entschlüsselung..."
echo ""
print_info "README.txt:"
head -5 "$WORKBENCH_DIR/README.txt"
echo ""
print_info "config.json:"
head -10 "$WORKBENCH_DIR/config.json"
echo ""

wait_for_user

# Finale Demonstration
print_header "✅ DEMO ABGESCHLOSSEN"
print_success "Verschlüsselung und Entschlüsselung erfolgreich!"
echo ""
print_info "Zusammenfassung:"
echo "  • Alle Dateien wurden erfolgreich verschlüsselt"
echo "  • Verschlüsselte Dateien haben .encrypted Endung"
echo "  • Originaldateien wurden nach Verschlüsselung gelöscht"
echo "  • Entschlüsselung hat alle Dateien wiederhergestellt"
echo "  • Verzeichnisstruktur blieb erhalten"
echo ""

print_info "Features des Tools:"
echo "  • AES-256-GCM Verschlüsselung"
echo "  • Automatische Passwort-Generierung"
echo "  • Rekursive Verzeichnisverarbeitung"
echo "  • Sichere Schlüsselableitung (PBKDF2)"
echo "  • Plattformübergreifend (Linux, Windows, macOS)"
echo ""

wait_for_user

print_header "🎯 VERWENDUNG"
echo ""
print_info "Verwendung des Tools:"
echo "  ./$BINARY_NAME --encrypt --dir <verzeichnis> --generate"
echo "  ./$BINARY_NAME --decrypt --dir <verzeichnis> --password <passwort>"
echo ""
print_info "Weitere Informationen:"
echo "  ./$BINARY_NAME --help"
echo ""

print_success "Demo erfolgreich abgeschlossen! 🎉" 