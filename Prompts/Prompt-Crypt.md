Schreibe mir ein Verschlüsselungstool für Linux, Windows und Mac. Das Tool soll jeweils auf der Kommandozeile als Binary laufen.

Kompiliere das ganze auf den folgenden Plattformen, nutze Go als Basis:

- Linux: ARM64, x86-64
- Windows: x86-64
- Mac: ARM64

Achte darauf, dass das Tool ohne Plattform Libraries lauffähig ist, so dass auch zum Beispiel Windows 7 genutzt werden kann.

- Die Binary soll "inconspicuous" heissen.

- Das Programm soll einen möglichst kleinen und effizienten Footprint haben.

Die Funktionalität soll sehr einfach sein:
- Verschlüssele alle Dateien eines bestimmten Ordners und dessen Unterordnern.
- Verschlüssele nur die Dateien, nicht aber die Ordner.
- Benenne die Dateien nicht um, mache keine Kopien der Dateien und Ordnern, sondern arbeite mit den Dateien direkt.
- Generiere ein eigenes Passswort oder erlaube die Angabe eines Passwortes.

Die weiteren Optionen sind das Verschlüsseln oder Entschlüsseln. Beide Optionen sind exklusiv voneinander.

Lege die Binaries in einen separaten Ordner, so dass diese leicht zu finden sind.

Lege alles hier im git-repo an. Schreibe ein compile script, welches automatisch alle Plattform Varianten compiliert. Schreibe auch ein Skript, welches auf der jeweiligen Plattform dafür sorgt, dass alle Compiler-Komponenten installiert sind im Projekt. Schreibe auch eine README.

- Um die Funktionalität zu zeigen, generiere ein Shell-Skript für die bestehende Plattform, um auf YouTube zu zeigen, wie Dateien in einem Verzeichniss "Workbench" und einigen Unterverzeichnissen verschlüsselt und wieder entschlüsselt werden.
- Generiere dazu ein paar Text Dateien mit mehreren hundert Worten
- Das Demo Skript soll Stops beinhalten, so dass man die Funktionalität auf YouTube gut zeigen kann
- Ich zeige auf dem Kali Terminal. Arbeite mit sinnvollen und klaren Darstellungen der einzelnen Stages, so dass man gut erkennan kann, was sich abspielt.
- Achte beim Demo darauf, dass es auf der richtigen Architektur läuft.
- Achte darauf, dass das Demo auch funktioniert, wenn die Daten aus bestimmten Gründen nicht in Ordnung sind, weil zuvor das Demo schiefgelaufen ist. Am besten stellst Du sicher, dass die Workbench vorher immer leer ist, wenn das Demo startet
- Wenn Du selbst testest, denke daran, dass Du nicht interaktiv bist, sondern im Agentenmodus, Du also von mir keine Eingabe erwartest. Nur wenn ich das Demo vor Publikum zeige, soll es interaktiv sein.
- Stelle sicher, dass das interaktive Demo leicht verständlich ist und nicht zu viele Stopps hat, aber trotzdem klar zeigt, was vor sich geht.