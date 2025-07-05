package main

import (
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"crypto/sha256"
	"fmt"
	"io/fs"
	"os"
	"path/filepath"
	"strings"

	"golang.org/x/crypto/pbkdf2"
)

const (
	version     = "1.0.0"
	saltLength  = 32
	keyLength   = 32
	nonceLength = 12
	iterations  = 10000
)

type Config struct {
	Directory string
	Password  string
	Encrypt   bool
	Decrypt   bool
	Generate  bool
}

func main() {
	if len(os.Args) < 2 {
		printUsage()
		os.Exit(1)
	}

	config := parseArgs()

	if config.Encrypt && config.Decrypt {
		fmt.Println("❌ Fehler: Verschlüsseln und Entschlüsseln können nicht gleichzeitig verwendet werden")
		os.Exit(1)
	}

	if !config.Encrypt && !config.Decrypt {
		fmt.Println("❌ Fehler: Entweder --encrypt oder --decrypt muss angegeben werden")
		os.Exit(1)
	}

	if config.Directory == "" {
		fmt.Println("❌ Fehler: Verzeichnis muss mit --dir angegeben werden")
		os.Exit(1)
	}

	if config.Password == "" && !config.Generate {
		fmt.Println("❌ Fehler: Passwort muss mit --password angegeben oder --generate verwendet werden")
		os.Exit(1)
	}

	if config.Generate {
		config.Password = generatePassword()
		fmt.Printf("🔑 Generiertes Passwort: %s\n", config.Password)
	}

	if config.Encrypt {
		encryptDirectory(config)
	} else if config.Decrypt {
		decryptDirectory(config)
	}
}

func printUsage() {
	fmt.Printf("🔐 Inconspicuous - Verschlüsselungstool v%s\n", version)
	fmt.Println("")
	fmt.Println("Verwendung:")
	fmt.Println("  inconspicuous --encrypt --dir <verzeichnis> [--password <passwort> | --generate]")
	fmt.Println("  inconspicuous --decrypt --dir <verzeichnis> [--password <passwort> | --generate]")
	fmt.Println("")
	fmt.Println("Optionen:")
	fmt.Println("  --encrypt     Verzeichnis verschlüsseln")
	fmt.Println("  --decrypt     Verzeichnis entschlüsseln")
	fmt.Println("  --dir         Zielverzeichnis")
	fmt.Println("  --password    Passwort für Verschlüsselung/Entschlüsselung")
	fmt.Println("  --generate    Automatisch ein sicheres Passwort generieren")
	fmt.Println("  --help        Diese Hilfe anzeigen")
	fmt.Println("")
	fmt.Println("Beispiele:")
	fmt.Println("  inconspicuous --encrypt --dir ./daten --generate")
	fmt.Println("  inconspicuous --decrypt --dir ./daten --password meinpasswort")
}

func parseArgs() Config {
	config := Config{}

	for i := 1; i < len(os.Args); i++ {
		arg := os.Args[i]

		switch arg {
		case "--encrypt":
			config.Encrypt = true
		case "--decrypt":
			config.Decrypt = true
		case "--dir":
			if i+1 < len(os.Args) {
				config.Directory = os.Args[i+1]
				i++
			}
		case "--password":
			if i+1 < len(os.Args) {
				config.Password = os.Args[i+1]
				i++
			}
		case "--generate":
			config.Generate = true
		case "--help":
			printUsage()
			os.Exit(0)
		}
	}

	return config
}

func generatePassword() string {
	const charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*"
	password := make([]byte, 16)

	for i := range password {
		randomByte := make([]byte, 1)
		rand.Read(randomByte)
		password[i] = charset[randomByte[0]%byte(len(charset))]
	}

	return string(password)
}

func encryptDirectory(config Config) {
	fmt.Printf("🔒 Starte Verschlüsselung von: %s\n", config.Directory)

	if !isDirectory(config.Directory) {
		fmt.Printf("❌ Fehler: %s ist kein gültiges Verzeichnis\n", config.Directory)
		os.Exit(1)
	}

	fileCount := 0
	successCount := 0
	errorCount := 0

	err := filepath.WalkDir(config.Directory, func(path string, d fs.DirEntry, err error) error {
		if err != nil {
			return err
		}

		if !d.IsDir() && !isEncryptedFile(path) {
			fileCount++
			fmt.Printf("🔐 Verschlüssele: %s\n", path)

			if err := encryptFile(path, config.Password); err != nil {
				fmt.Printf("❌ Fehler beim Verschlüsseln von %s: %v\n", path, err)
				errorCount++
			} else {
				successCount++
			}
		}
		return nil
	})

	if err != nil {
		fmt.Printf("❌ Fehler beim Durchsuchen des Verzeichnisses: %v\n", err)
		os.Exit(1)
	}

	fmt.Printf("\n✅ Verschlüsselung abgeschlossen!\n")
	fmt.Printf("📊 Statistiken:\n")
	fmt.Printf("   - Dateien gefunden: %d\n", fileCount)
	fmt.Printf("   - Erfolgreich verschlüsselt: %d\n", successCount)
	fmt.Printf("   - Fehler: %d\n", errorCount)
}

func decryptDirectory(config Config) {
	fmt.Printf("🔓 Starte Entschlüsselung von: %s\n", config.Directory)

	if !isDirectory(config.Directory) {
		fmt.Printf("❌ Fehler: %s ist kein gültiges Verzeichnis\n", config.Directory)
		os.Exit(1)
	}

	fileCount := 0
	successCount := 0
	errorCount := 0

	err := filepath.WalkDir(config.Directory, func(path string, d fs.DirEntry, err error) error {
		if err != nil {
			return err
		}

		if !d.IsDir() && isEncryptedFile(path) {
			fileCount++
			fmt.Printf("🔓 Entschlüssele: %s\n", path)

			if err := decryptFile(path, config.Password); err != nil {
				fmt.Printf("❌ Fehler beim Entschlüsseln von %s: %v\n", path, err)
				errorCount++
			} else {
				successCount++
			}
		}
		return nil
	})

	if err != nil {
		fmt.Printf("❌ Fehler beim Durchsuchen des Verzeichnisses: %v\n", err)
		os.Exit(1)
	}

	fmt.Printf("\n✅ Entschlüsselung abgeschlossen!\n")
	fmt.Printf("📊 Statistiken:\n")
	fmt.Printf("   - Verschlüsselte Dateien gefunden: %d\n", fileCount)
	fmt.Printf("   - Erfolgreich entschlüsselt: %d\n", successCount)
	fmt.Printf("   - Fehler: %d\n", errorCount)
}

func isDirectory(path string) bool {
	info, err := os.Stat(path)
	return err == nil && info.IsDir()
}

func isEncryptedFile(path string) bool {
	return strings.HasSuffix(path, ".encrypted")
}

func encryptFile(filePath, password string) error {
	// Datei lesen
	data, err := os.ReadFile(filePath)
	if err != nil {
		return fmt.Errorf("fehler beim Lesen der Datei: %v", err)
	}

	// Salt generieren
	salt := make([]byte, saltLength)
	if _, err := rand.Read(salt); err != nil {
		return fmt.Errorf("fehler beim Generieren des Salts: %v", err)
	}

	// Schlüssel aus Passwort ableiten
	key := pbkdf2.Key([]byte(password), salt, iterations, keyLength, sha256.New)

	// AES-GCM Block Cipher erstellen
	block, err := aes.NewCipher(key)
	if err != nil {
		return fmt.Errorf("fehler beim Erstellen des Ciphers: %v", err)
	}

	// GCM Mode erstellen
	gcm, err := cipher.NewGCM(block)
	if err != nil {
		return fmt.Errorf("fehler beim Erstellen des GCM Modes: %v", err)
	}

	// Nonce generieren
	nonce := make([]byte, gcm.NonceSize())
	if _, err := rand.Read(nonce); err != nil {
		return fmt.Errorf("fehler beim Generieren der Nonce: %v", err)
	}

	// Verschlüsseln
	ciphertext := gcm.Seal(nil, nonce, data, nil)

	// Verschlüsselte Daten mit Salt und Nonce kombinieren
	encryptedData := append(salt, nonce...)
	encryptedData = append(encryptedData, ciphertext...)

	// Verschlüsselte Datei schreiben
	encryptedPath := filePath + ".encrypted"
	if err := os.WriteFile(encryptedPath, encryptedData, 0644); err != nil {
		return fmt.Errorf("fehler beim Schreiben der verschlüsselten Datei: %v", err)
	}

	// Originaldatei löschen
	if err := os.Remove(filePath); err != nil {
		return fmt.Errorf("fehler beim Löschen der Originaldatei: %v", err)
	}

	return nil
}

func decryptFile(filePath, password string) error {
	// Verschlüsselte Datei lesen
	encryptedData, err := os.ReadFile(filePath)
	if err != nil {
		return fmt.Errorf("fehler beim Lesen der verschlüsselten Datei: %v", err)
	}

	if len(encryptedData) < saltLength+nonceLength {
		return fmt.Errorf("ungültige verschlüsselte Datei: zu kurz")
	}

	// Salt, Nonce und Ciphertext extrahieren
	salt := encryptedData[:saltLength]
	nonce := encryptedData[saltLength : saltLength+nonceLength]
	ciphertext := encryptedData[saltLength+nonceLength:]

	// Schlüssel aus Passwort ableiten
	key := pbkdf2.Key([]byte(password), salt, iterations, keyLength, sha256.New)

	// AES-GCM Block Cipher erstellen
	block, err := aes.NewCipher(key)
	if err != nil {
		return fmt.Errorf("fehler beim Erstellen des Ciphers: %v", err)
	}

	// GCM Mode erstellen
	gcm, err := cipher.NewGCM(block)
	if err != nil {
		return fmt.Errorf("fehler beim Erstellen des GCM Modes: %v", err)
	}

	// Entschlüsseln
	plaintext, err := gcm.Open(nil, nonce, ciphertext, nil)
	if err != nil {
		return fmt.Errorf("fehler beim Entschlüsseln: %v", err)
	}

	// Originaldateiname wiederherstellen
	originalPath := strings.TrimSuffix(filePath, ".encrypted")

	// Entschlüsselte Datei schreiben
	if err := os.WriteFile(originalPath, plaintext, 0644); err != nil {
		return fmt.Errorf("fehler beim Schreiben der entschlüsselten Datei: %v", err)
	}

	// Verschlüsselte Datei löschen
	if err := os.Remove(filePath); err != nil {
		return fmt.Errorf("fehler beim Löschen der verschlüsselten Datei: %v", err)
	}

	return nil
}
