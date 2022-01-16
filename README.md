# Mobile iOS Applikationen 21HS 5iCa

## Projektarbeit 2

### Bearbeitet von

* Ramona Marti
* Remo von Arx

### Abgabe

* 20.01.2022 23:59

### Aufgaben-Checkliste
- 1
- 2
- 3
    * Custom-Background Image wenn kein Background-Image hinterlegt ist
    * 2 Opacities für Hintergrundfarbe und -bild seperat einstellbar
    * Image opacity in Art Wall Übersicht angewendet 
- 4
- 5
    * 2 weitere Tests für add Emoji und 2 Tests für remove Emoji 
- 6

(Eingerückte Punkte wurden zusätzlich implementiert.)

### Testing & Fastlane

Wenn die UI Tests nicht durchlaufen, liegt es daran, dass die Pop-Up Tastatur des Simulatorgerätes nicht auftaucht. Um dieses Problem zu beheben muss der verwendete Simulator (wahrscheinlich iPhone 12 mini & iPad (9th generation)) gestartet werden und die Einstellung angepasst werden. Danach kann der Test wiederholt werden. \
Einstellungen wie folgt: 
- Falls Check da: Entferne den Check neben 'Connect Hardware Keyboard'
- Falls Check nicht da: Füge Check neben 'Connect Hardware Keyboard' hinzu -> starte App manuell bis zum Edit-Modus -> klicke ins Feld zum Umbenennen -> Klicke auf I/O > Keyboard > Toggle Software Keyboard -> Keyboard sollte auftauchen

![img.png](settingsKeyboard.png)

Sollte der Test immer noch fehlschlagen, liegt es daran, dass der doubleTab auf das Textfield nicht ausgeführt wurde (Simulator abhängig). Es kann helfen den Test nochmals auszuführen.\

Damit die Tests auf den Geräten sichtbar ausgeführt werden, muss die Simulator-App im Hintergrund vor dem ``fastlane fast`` Start bereit geöffnet sein. Dadurch ist auch ersichtlich, ob die Tastatur auf den Geräten aufpopt wie sie sollte.
