Die Ordnerstruktur ist �bersichtlich gegliedert.
In diesem Ordner (?:\Quelldateien\Programm\) befindet sich die Projektdatei 
"MauDauMau.bdsgroup" mit der sich das gesammte Projekt in Turbo Delphi einladen l�sst.

Das Projekt besteht aus Verschiedenen Einzelteilen.
Die kompilierten Einzelteile landen allesammt im bin-Ordner (?:\Quelldateien\Programm\bin\)
Jeder andere Ordner representiert ein Teil des Projektes.

Im "executable" Ordner befinden sich die Dateien zur Erzeugung der "MauDauMau.exe".
Im "dll" Ordner befinden sich die Dateien zur Erzeugung der "MauDauMau.dll".
Im "chmfix" Ordner befinden sich die Dateien zur Erzeugung der "chmfix.exe".
Im "autostart" Ordner befinden sich die Dateien zur Erzeugung der "Autostart.exe".
Im "install" Ordner befinden sich die Dateien zur Erzeugung der "Install.exe".
Im "uninstall" Ordner befinden sich die Dateien zur Erzeugung der "Uninstall.exe".
Im "Hilfe" Ordner befinden sich die Dateien zur Erzeugung der "MauDauMau.chm".

Zus�tzlich zu den kompilierten Programmteilen im bin Ordner befinden sich noch zus�tzliche 
Dateien in dem Ordner um beim �ffnen derer nicht gleich einen Fehler zu verursachen.
"cards.dll" f�r die "MauDauMau.exe" (falls die cards.dll nicht dem Betriebssystem beiliegt)
"language.rcl" f�r die "MauDauMau.exe" (beinhaltet alle Strings in den verschiedenen Sprachen)
"license.txt" f�r die "Install.exe" (wird auf die erste Form ins Memo eingeladen)
