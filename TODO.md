# TODO - Binary Playground

Versione attuale: 0.9. Quando l'interfaccia utente sarà completa il progetto passerà alla 1.0 e sarà virtualmente completo: dopo resteranno solo eventuali correzioni di bug.

## In corso

- [ui] Completare l'interfaccia utente: i comandi per selezionare e modificare i bit dell'accumulatore (A) e della memoria (M). File: `user_interface.asm`.

## Da fare

- [versione] Portare `VERSIONE` a 1.0 nel sorgente principale quando l'interfaccia utente è completa.
- [idea] Pagina 2, «TESTS & COMPARISONS»: i risultati di CMP e BIT mostrano oggi il contenuto dell'accumulatore; mostrare invece il risultato dell'operazione implicita che le due istruzioni eseguono: la sottrazione A - M per CMP, l'AND tra A e M per BIT.
- [stile] Ripristinare `, once` sulle righe `!source` del sorgente principale e togliere il commento `PROVA TEMPORANEA` quando sarà risolto il bug di C64Studio (LIB-01).
- [da verificare] `jmp (_TESTS_VECTOR)` in `PRINT_TESTS`: il salto indiretto del 6502 sbaglia se l'indirizzo del vettore finisce a `$xxFF`. Ricontrollare dopo ogni modifica che sposta le variabili.

## Fatto

- 2026-11-16 Aggiunti `user_interface.asm` e questo file; codice riadeguato alla guida di stile (mappa di memoria, intestazioni, documentazione dei contratti); dipendenze di `data_tables.asm` dichiarate nella DESCRIZIONE (P416, P417).
- 2026-11-15 Codice adeguato alla guida di stile (revisione completa).
