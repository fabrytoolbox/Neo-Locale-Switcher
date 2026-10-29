# 🕶️ Neo - Locale Switcher

Cambia al volo layout della tastiera e impostazioni regionali su Windows, con una GUI in stile Matrix.

## ✨ Feature

- ✅ **Cambio Tastiera**: Passa da layout IT a US (e viceversa) con un click.
- ✅ **Cambio Regione**: Modifica il formato di data, ora e valuta (Italia / UK).
- ✅ **Auto-Elevazione Admin**: Richiede i privilegi necessari per applicare le modifiche a tutto il sistema.
- ✅ **Log su file**: Traccia tutte le operazioni in `NeoLocale_*.log`.
- ✅ **Stile Matrix**: Interfaccia scura con testo verde lime, per veri "Neo".

## 📋 Requisiti

- **Windows 10 / 11**
- **PowerShell 7+** (scarica da https://aka.ms/powershell)
- **Privilegi di amministratore** (necessari per i comandi di sistema)

## 🚀 Quick start

```powershell
git clone https://github.com/fabrytoolbox/Neo-Locale-Switcher.git
cd Neo-Locale-Switcher
Unblock-File .\Neo-Locale-Switcher.ps1
.\Neo-Locale-Switcher.ps1

Oppure doppio click su avvia.bat.

🎯 Casi d'uso
Sviluppatori: Passa rapidamente da tastiera IT a US per scrivere codice senza impazzire con i simboli.

Utenti internazionali: Cambia il formato della data e della valuta per allinearlo alle tue abitudini.

Test di sistema: Verifica come le applicazioni si comportano con impostazioni regionali diverse.

🐛 Problemi comuni
"Errore: Failed to set Keyboard"
Assicurati di aver accettato il prompt UAC (l'auto-elevazione dovrebbe apparire all'avvio). Se il problema persiste, controlla il file di log.

"Il layout non cambia"
A volte Windows richiede un riavvio o un logoff per applicare completamente le modifiche. Se il cambio non è immediato, prova a effettuare il logoff e accedere di nuovo.

📜 Licenza
MIT (vedi LICENSE).

🙏 Crediti
Fabry Toolbox

Ispirato al film Matrix (1999)
