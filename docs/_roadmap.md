# Fahrplan: Fundament geraderücken

Basiert auf [`_analysis.md`](_analysis.md). Ziel ist nicht „mehr Features“, sondern ein **kleiner, widerspruchsfreier Kern, der Ende-zu-Ende im Browser läuft**. Alles andere wird geparkt, nicht gelöscht.

Leitfrage für jede Entscheidung: *Macht es Collection-Transformationen lesbarer oder Coercion/Typechecks kürzer?* Wenn nein, gehört es nicht in den Kern.

---

## Phase 0 – Aufräumen

Klein, mechanisch, sofort machbar.

- [ ] `haskell/` nach `_deprecated/` (dritte Implementierungssprache ohne lauffähigen Stand; der JS-Compiler ist der Haupttrack).
- [ ] `runtimes/odin/` als **geparkt** markieren (bleibt liegen, bis der JS-Kern läuft).
- [ ] `js-packages/compiler/poo2.lsd` nach `_deprecated/` (Entwurf mit Odin-Codegen und `???`).
- [ ] Root-`readme.md` auf Pitch + Links reduzieren; `docs/readme.md` ist die Docs-Startseite.
- [ ] `_devnotes.md` entrümpeln: TODOs in diesen Fahrplan bzw. ein `_backlog.md`, Markdown-Spickzettel und fremden Code raus.
- [ ] Jedes Dokument bekommt oben eine Status-Zeile: `core` · `draft` · `parked`.

## Phase 1 – Grundsatzentscheidungen

Jede Entscheidung als kurzes Dokument in `docs/decisions/` (Kontext, Entscheidung, Konsequenzen). Reihenfolge ist wichtig: D1–D4 blockieren alles andere.

| # | Entscheidung | Empfehlung |
| :--- | :--- | :--- |
| D1 | Deklarationen & Konstanten | `val` streichen (Zuweisung deklariert im Funktions-/Objekt-Scope), `seal` als Keyword statt `#=`, `val #NAME` streichen (Compiler faltet versiegelte Literale selbst). Details: Analyse 6. |
| D2 | Wert- vs. Referenzsemantik, Mutabilität | Primitive (inkl. String) sind immutable Werte; Collections sind Referenzen. **Methoden mutieren nie**, Mutation nur über Zuweisungsoperatoren (`+=`, `-=`, und neu `\|?=`, `\|>=`). Das streicht die komplette `to_*`-Doppel-API und passt zum JS-Mentalmodell. |
| D3 | Nullwert | Genau einer: `null`. `undefined` und `nil` verschwinden aus der Sprache (Runtime normalisiert JS-`undefined`). |
| D4 | Symbol-Budget | `#` nur für strikte Literale (`#[` `#(` `#{` `#/`). `@` nur als „aktuelles Element“ in Pipes. `as` nur für Casts und Bindings (`loop xs as x`, Destructuring-Alias). `$` nur für Interpolation. `'…'` ist immer String (kein Auto-`Char`). |
| D5 | Aufruf-Syntax | Kommas sind Pflicht. Klammerloser Call nur mit genau einem einfachen Argument (Literal/Identifier) – so, wie `poo.lsd` es schon hat. Optionale Kommas in Parameterlisten streichen. `fn^`/Currying parken. |
| D6 | Kontrollfluss | Eine `switch`-Form: `switch x { pattern do …; or do …; }` – Subjekt optional, Cases matchen per `~=`, `switch` ohne Subjekt prüft auf truthy. Ein Loop-Binding: `loop xs as x`. `skip` streichen (= `continue`). `or` = else/Fallback, Boolean-Logik nur über `&&`/`\|\|`; `and` als Keyword parken. |
| D7 | Pipe-Operatoren | Kernset: `\|>` map, `\|?` filter, `\|!` reject, `\|*` reduce, `>>` apply, `?>>` nullish-safe apply. Punkt-Shorthand `.prop` und `{ .k: .v }` als Lambda-Kurzform in Pipes spezifizieren. `\|.`, `>>>`, `!>>` streichen/parken. `\|>` = Map bewusst festhalten. |
| D8 | Shapes (Typen als Werte) | `Type`, `Pattern`, `Union` und Record-Schemas zu **einem** Konzept vereinen: `x ~= Shape` prüft, `x as Shape` coerced (wirft), `x as? Shape` coerced (liefert `null`). Eine Coercion-Tabelle (String↔Number, String↔Bool, …) festlegen. „strict/relaxed mode“ streichen. |
| D9 | Kern-Typen | `Bool`, `Number`, `String`, `null`, `Array`, `List`, `Tuple`, `Map`, `Record`, `Range`, `RegExp`. Alles andere (`Color`, `Blob`, `Tree`, `Store`, `Fingerprint`, `Queue`, `Stack`, `Pool`, `Enum`, `Date`, `Duration`, Int-/Float-Breiten) → `parked`. Methoden-Namen einheitlich `snake_case`, JS-Runtime mappt intern. |
| D10 | Targets & Toolchain | JS zuerst, Odin erst nach Phase 3. Cosmonaut muss reproduzierbar verfügbar sein (npm/jsr-Publish oder vendored), damit der Compiler in Node und in Tests läuft. |

## Phase 2 – Kern-Spec

- [ ] Ein einziges Dokument `docs/core.md`: Lexik, Deklarationen, Ausdrücke mit **vollständiger Präzedenztabelle**, Kontrollfluss, Pipes, Shapes, Kern-Typen.
- [ ] Die bestehenden Docs auf `core.md` ausrichten oder als `draft`/`parked` markieren. Keine zweite Wahrheit.
- [ ] `poo.lsd` an `core.md` angleichen (Operator-Tabelle ohne `idk`, Keyword-Liste, Literal-Liste).
- [ ] Die zwei Readme-Beispiele (`whileLoop`, `StyleResolver`) und `processPayload` aus den Devnotes in gültiger Kern-Syntax neu schreiben – sie sind der Akzeptanztest der Spec.

## Phase 3 – Vertikaler Durchstich im Browser

Ziel: Die drei Beispiele aus Phase 2 kompilieren *und laufen*.

- [ ] Runtime reparieren und auf den Kern zuschneiden (`record.js`, Exporte, `union.js`, `List.clone`, variadische Konstruktoren); kein globales `String.prototype`-Patching.
- [ ] Grammatik: Präzedenz-Climbing, Member-Zugriff, Methodenaufrufe, Index, Klammern, unäres Minus, Lambdas, `if`/`or`, `loop`, `switch`, `return`, Interpolation.
- [ ] Codegen: Scope-Analyse (für D1), Pipes als Runtime-Calls, `~=`/`as` gegen die Shape-Runtime, Operator-Lowering für Collections (`+=` auf `List` etc.).
- [ ] Tests mit `node:test`: Snapshot `.poo` → `.js` und Ausführung mit erwarteter Ausgabe.
- [ ] Playground führt den generierten Code aus und zeigt die Ausgabe.
- [ ] Service Worker erst danach: gebündelter Compiler ohne Bare-Specifier und ohne Top-Level-`await`.

## Phase 4 – Danach (bewusst später)

Objektmodell (`obj`, `new`, `use`/`ref`) · Generatoren (`fn*`) · Module/Packages (`pkg`, `::`) · Fehlerbehandlung (`catch`/`fail`) · weitere Typen aus der Park-Liste · Odin-Target.

---

## Nächster konkreter Schritt

D1–D4 entscheiden (die vier Entscheidungen, an denen alles andere hängt). Danach lässt sich `docs/core.md` in einem Zug schreiben.
