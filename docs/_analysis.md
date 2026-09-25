# Ist-Analyse (Stand 2026-09)

Bestandsaufnahme von Poo nach der Pause. `_deprecated/` ist bewusst ausgeklammert.

Ziel dieses Dokuments ist nicht Bewertung einzelner Ideen, sondern eine ehrliche Karte: was existiert, was widerspricht sich, was fehlt – als Grundlage für [`_roadmap.md`](_roadmap.md).

---

## 1. Kurzfassung

- **Die Docs sind der eigentliche Spec** – und zwar ein Ideen-Sammelbecken aus mehreren Phasen. Viele Konzepte existieren in 2–3 inkompatiblen Varianten (Switch, Loop-Binding, Pipes, Ranges, Boundary-Keywords, Sealing).
- **Symbole sind massiv überladen**: `#` hat 5 Bedeutungen, `@` hat 5, `as` hat 4, `or` hat 3, `:` hat 4. Das ist die Hauptursache für Parser- und Highlighting-Komplexität.
- **Die Kern-Semantik ist ungeklärt**: Wert- vs. Referenzsemantik, Mutabilität von Strings/Collections, `null`/`undefined`/`nil`, Scope-Regeln. Ohne diese Entscheidungen kann weder Codegen noch Runtime konsistent werden.
- **Scope-Creep**: ~25 Datentypen, 3 Funktionsarten, 2 Targets, 3 Implementierungssprachen (JS, Haskell, Odin). Nichts davon ist Ende-zu-Ende lauffähig.
- **Implementierung**: Der JS-Compiler (auf Basis des externen Cosmonaut) kann Deklarationen, einfache Calls, eine einzelne Binär-Operation und Collection-Literale. Die Runtime lässt sich nicht importieren (fehlende Datei, Syntaxfehler). Haskell- und Odin-Code kompilieren nicht. Es gibt keine Tests.
- **Die starken Ideen sind klar erkennbar** und decken sich mit deinen Zielen: Collection-Pipes mit Punkt-Shorthand (`|? .active |> .name`) und strukturelles Matchen/Coercen (`~=`, `as`, `or return`). Die sind aber am dünnsten spezifiziert.

---

## 2. Bestand

| Bereich | Pfad | Zustand |
| :--- | :--- | :--- |
| Docs / Spec | `docs/*.md`, `docs/specs/`, `docs/types/` | umfangreich, widersprüchlich, teils leer |
| Grammatik (aktiv) | `js-packages/compiler/poo.lsd` | kleiner Sprachkern, s. 4.1 |
| Grammatik (Entwurf) | `js-packages/compiler/poo2.lsd` | Odin-`CODE`-Blöcke, `???`-Platzhalter, doppelte Regeln |
| JS-Compiler | `js-packages/compiler/` | hängt an `@cosmonaut/*` (extern, nicht im Repo, nicht auf npm/jsr) |
| JS-Runtime | `js-packages/runtime/` | nicht importierbar, s. 4.2 |
| Highlighting | `js-packages/hljs/` | brauchbar, leitet Wortlisten aus `poo.lsd` ab |
| Service Worker | `js-packages/worker/` | wird nirgends registriert; wäre so auch nicht lauffähig, s. 4.3 |
| Playground | `playground/` | zeigt Poo-Input und JS-Output, führt nichts aus |
| Haskell-Parser | `haskell/` | kompiliert nicht, s. 4.4 |
| Odin-Runtime | `runtimes/odin/` | kompiliert nicht, s. 4.5 |
| Tests / CI | – | nicht vorhanden |

---

## 3. Widersprüche und offene Punkte in den Docs

### 3.1 Deklarationen, Mutabilität, Konstanten

| Thema | Variante A | Variante B | Anmerkung |
| :--- | :--- | :--- | :--- |
| Deklarations-Keyword | `val` ist „the sole declaration keyword“ (`values.md`) | `fn`, `obj`, `enum`, `prop` (`typecasting.md`) deklarieren ebenfalls | `prop` taucht nur noch in Resten auf |
| Bedeutung von `val` | `val` ist **mutable** | Name suggeriert immutable (Scala/Kotlin) | falsche Erwartung bei jedem, der `val` kennt |
| Sealing | `x #= v` = zuweisen **und** versiegeln | `animals #= true` = nur versiegeln (weist `true` zu?) | `operators.md` vs. `declarations.md` |
| Sealing-Fehler | Compile-time Error (`declarations.md`) | Runtime Error (`operators.md`) | – |
| Sealing in Tabelle | `values.md`: Sealing „Allowed“ als Spalte | – | Tabelle mischt Operation und Zustand |
| Konstante | `val #NAME = …` (compile-time) | – | `#` im Identifier kollidiert mit `#[`, `#(`, `#{`, `#/` |
| Grammatik | `poo2.lsd`: `#=` ⇒ `isConst: false`, `=` ⇒ `isConst: true` | – | genau vertauscht |

Deine beiden Fragen (Sealing-Operator abschaffen, `val` abschaffen) hängen direkt hiermit zusammen – siehe Abschnitt 6.

### 3.2 Objekte und Scope-Grenzen

- `obj` ist gleichzeitig **Typ-Deklaration** (`obj Cat = {…}`), **Instanz-Binding** (`obj inst1 = new person`) und **Konstruktor-Funktion** (`obj person = (name, age) => {…}`). Drei Objektmodelle nebeneinander.
- `new` ist einmal „Klon des aktuellen Zustands“ (Prototyp-Kopie), einmal Konstruktor mit Named Args.
- `boundary-control.md` widerspricht sich selbst: Die Tabelle nennt `use` / `ref` / `pnt`, die Abschnitte heißen `use` / `cpy` / `ref`; `cpy` wird als „dynamic view“ beschrieben, das Beispiel darunter nutzt aber `ref`; `ref` wird als „direct pointer“ beschrieben (in der Tabelle ist das `pnt`). `pnt` fehlt in `keywords.md` und `poo.lsd`.
- `use` ist einmal Snapshot-Import einer Variable, einmal Mixin/Vererbung (`use Person;`).
- Das Grundprinzip „äußere Scopes sind in Objekten standardmäßig geschlossen“ steht nur hier und ist nirgends mit Funktionen/Lambdas abgeglichen (dürfen Lambdas in Pipes äußere Variablen lesen?).

### 3.3 Funktionen

- Drei Deklarationsformen: `fn f = (a, b) => …`, `fn f => …` (ohne `=`), `fn f(a, b) { … }`; dazu `val f = () => …` in anderen Docs.
- **Optionale Kommas + optionale Klammern** sind grammatikalisch gefährlich: `f a b` (ein Call mit 2 Args? `f(a)(b)`?), `f -1` (Subtraktion oder Call?), `f [1]` (Index oder Call mit Array?), `f a - 1`. Bei `fn^` ist `multiply 3 4` Currying, bei `fn` wäre `call(100 "hello")` ein 2-Arg-Call. Das braucht eine klare Regel, sonst ist der Parser nicht deterministisch.
- `fn^` verspricht statisch geprüfte Purity, Constant Folding, Loop Fusion, Parallelisierung. Für eine dynamische Sprache mit JS-Target ist das ein eigenes Großprojekt.
- `fn*` (Generatoren) ist konsistent beschrieben, aber `Generator.md` fehlt.

### 3.4 Kontrollfluss

| Thema | Variante A | Variante B |
| :--- | :--- | :--- |
| `switch` | `switch { cond do …; or do …; }` (`control-flow.md`, Haskell-Parser) | `switch (x) { case P: …; default: … }` C-Stil (`pattern-matching.md`) |
| Loop-Binding | `loop (animals as @animal)` | `loop animals as animal do …`, `loop 1...5 as @i`, `loop (0..limit as n)` |
| `skip` vs. `continue` | beide nahezu identisch beschrieben | – |
| Fehlerbehandlung | `catch`, `fail`, `kill` sind Keywords | nirgends spezifiziert |

- `or` ist gleichzeitig `else`/`else if`, Fallback-Operator (`read(p) or return "…"`), und Verkettung in `do … or break`. `and` analog. Zusätzlich existieren `&&` / `||`. In `do.md` steht außerdem, dass `or` ohne Klammern *vor* `and` bindet – umgekehrt zu praktisch jeder Sprache.
- `control-flow.md` enthält zwei Fassungen desselben Dokuments hintereinander.
- `do … on nerd and print hp of nerd` (`do.md`) führt kontextabhängige Keywords `on`/`of` ein – schwer zu parsen, schwer zu highlighten.

### 3.5 Operatoren

| Thema | Quellen und Varianten |
| :--- | :--- |
| Reduce | `\|*` (`operators.md`), `\| ` (Readme), fehlt in `poo.lsd` |
| Filter-Not | `\|!` verlinkt, aber nicht beschrieben; fehlt in `poo.lsd` |
| Pluck | `\|. "name"` (String-Key) vs. Readme-Beispiel `\|> .children` (Punkt-Shorthand) – `\|.` wird durch den Shorthand überflüssig |
| Safe-Pipes | `?>>` / `!>>` (`operators.md`) vs. `??>` / `?!>` (Readme, Keyword-Liste) |
| `>>>` | „Deep/Async Pipe“ (`operators.md`) vs. Readme-Beispiel `#[] >>> … @ += …` (Akkumulator/Tap-Semantik) |
| Deep Match | `~==` und `~~=` als zwei Schreibweisen |
| Ranges | `1..5` inklusiv (`operators.md`) vs. `1...5` inklusiv / `..<` exklusiv (`_devnotes.md`); `..` ist zugleich „Rest ignorieren“, `...` zugleich Rest/Spread |
| Coalescing | `??` (in `poo.lsd`), `?!` (falsy, nur in `typecasting.md`), `??=` (nur `poo.lsd`) |
| Ternary | `a ? b : c` in Beispielen benutzt, nirgends spezifiziert |
| Gleichheit | `==` strukturell; `_devnotes.md`: „`==` auf Strings case-insensitive“ |
| Präzedenz | `poo.lsd`: `\|\|`, `&&`, `??` auf derselben Stufe wie `==`; `\|?`/`\|>`/`>=<` mit Präzedenz `idk` |

Hinweis zu `|>`: In F#, Elixir, OCaml und im TC39-Proposal bedeutet `|>` *Forward-Pipe*, in Poo ist es *Map* (Forward-Pipe ist `>>`). Innerhalb von Poo ist die `|`-Familie konsistent – das ist vertretbar, sollte aber eine bewusste Entscheidung sein.

### 3.6 Symbol-Überladung

| Symbol | Bedeutungen |
| :--- | :--- |
| `#` | Konstante (`val #X`), Sealing (`#=`), strikte Collections (`#[` `#(` `#{`), RegExp-Literal (`#/…/`), in `Array.md`/`Map.md` sogar als Kommentarzeichen |
| `@` | `ref`-Variable (`@x`), Loop-Binding (`as @animal`), impliziter Pipe-Platzhalter (`string.prefix(@, …)`), Akkumulator (`@ += …`), Interpolation (`'@name'` in `objects.md`) |
| `as` | Cast (`x as number`), Loop-Binding, Destructuring-Alias, Cast-Handler im Objekt (`as string = () => …`) |
| `:` | Named Args, Map/Record-Keys, Symbol-Literal (`:active`), Ternary; dazu `::` für Packages |
| `$` | Interpolation (`"$name"`, `${…}`), Label (`$id` in alter Grammatik), gültiges Identifier-Zeichen (`poo.lsd`) |
| `'…'` | String **oder** Char (Länge 1 wird automatisch `Char`) |

### 3.7 Datentypen

- **Überschneidungen**: `Array` / `List` / `Tuple`, `Map` / `Record` / `obj`-Body / `Pattern`, `Pool` / `Set` (Docs sagen `Pool`, `poo.lsd` und Odin sagen `Set`), `Number` / `Int` / `Float` / `Int8…Uint64` / `Float32/64`.
- **Selbstwidersprüche**:
  - `Record`: „Keys cannot be added or removed“, hat aber In-place-`filter` und `diff`.
  - `Tuple`: „structural modifications disabled“, hat aber In-place-`filter`. Laut `types.md` sind Werte änderbar, die JS-Runtime friert das Tuple komplett ein.
  - `Stack`/`Queue`: `types.md` nutzt `push`, die Typ-Docs nutzen `add`.
  - `Pool`: `Pool([1, 2, 2])` (`types.md`) vs. `Pool(1, 2, 2)` (`Pool.md`).
- **Namenskonvention**: `to_` bedeutet einmal Konvertierung (`to_string`, `to_hex`), einmal nicht-mutierende Variante (`to_filter`, `to_morph`). Zusätzlich „alle Methoden in snake_case *und* PascalCase“ (gemeint ist vermutlich camelCase) – verdoppelt die API. Die JS-Runtime nutzt bereits camelCase mit abweichenden Namen (`toSlug` vs. `to_slug_case`).
- **In-place als Default**: `filter`, `morph`, sogar `String.trim` mutieren. Für JS-Entwickler ist `nums.filter(…)` die nicht-mutierende Operation – das ist eine Stolperfalle, und es setzt mutable Strings voraus (nirgends entschieden).
- **Literal-Kollisionen**: Date-Literal `1917-10-25` ist syntaktisch identisch mit `1917 - 10 - 25`. Duration-Literale (`60s`, `1000ms`) sind machbar, aber noch nicht im Lexer.
- **Nullwerte**: Docs sprechen von `nil`, `poo.lsd` kennt `null` und `undefined`.
- **Typannotationen** (`val id: ID = …`) tauchen einmal in `Union` auf, sonst nirgends.
- `bytesize()` auf jedem Typ ist im JS-Target nicht sinnvoll bestimmbar.
- Fehlende Docs, auf die verlinkt wird: `Date`, `Duration`, `Generator`, `Pattern`, `Set`, `Store`, `Union`, `literals.md`, `pkg/url.md`. Alle `pkg/*.md` sind Stubs.

### 3.8 Typecasting und Pattern Matching (deine Kernziele)

- `typecasting.md`: „Context-Aware Return Types“ ist leer; „strict/relaxed directory mode“ ist nicht definiert; Beispiele nutzen `number`/`string` klein, anderswo `Number`/`String`.
- Das Beispiel `processPayload` in `_devnotes.md` (`or return`, `~= obj{ id: Number, … }`, `>>`-Kette) ist die beste Demonstration, *warum* Poo existiert – aber seine Bausteine sind nirgends zusammenhängend spezifiziert.
- `Pattern` (`#{ name: String }`) und `Record` (`#{ name: "x" }`) teilen sich die Syntax. Das kann eine Stärke sein (Typen sind Werte), muss aber explizit so definiert werden.

### 3.9 Module / Packages

`pkg`, `use`, `fs::read`, `pkg cosmonaut::parser::blocks`, `import pkg::odin("core:fmt")` (Odin-Notizen) – kein einheitliches Modul-Konzept. `static` ist Keyword ohne Beschreibung.

---

## 4. Implementierungsstand im Detail

### 4.1 JS-Compiler (`js-packages/compiler`)

Architektur ist sauber gedacht: `poo.lsd` als Single Source of Truth, Codegen liest die Operator-Tabelle daraus, hljs ebenso.

Was die Grammatik abdeckt: `val`-Deklaration, `obj`-Deklaration, `fn` (zwei Formen), Expression-Statement, **eine** Binär-Operation (`Primary OP Primary`), Calls auf einen Identifier (Klammer- oder Bare-Arg), `[…]` `#[…]` `#(…)` `#{…}`.

Was fehlt: `if`/`or`, `loop`, `switch`, `return`, Lambdas als Ausdrücke, Member-Zugriff (`a.b`), Methodenaufrufe, Indexing, Klammerausdrücke, verkettete Operatoren (`a + b + c`), unäres Minus, String-Interpolation, Kommentare mit `/* */`, Symbole, Ranges, alle Pipes als Semantik.

Konkrete Codegen-Probleme:
- `obj` erzeugt `poo.makeObject(…)`, das in der Runtime nicht existiert.
- Generierter Code importiert `'poo/runtime'`; die Import-Map kennt nur `@poo/compiler` und `@poo/hljs`.
- `val` → `let`: doppelte `val x` im selben Scope (in den Docs üblich) werden zum JS-SyntaxError.
- `pets += 'fish'` aus `playground/example.poo` wird 1:1 durchgereicht. Auf einem `List`-Objekt ergibt das in JS String-Konkatenation: `pets` wird zu `"cat,dogfish"`.

Nicht lokal ausführbar: `@cosmonaut/compiler`, `@cosmonaut/lsd`, `@cosmonaut/layouter` liegen weder im Repo noch auf npm/jsr. Der Compiler läuft nur über die Import-Map von `code.pulgasari.dev`.

### 4.2 JS-Runtime (`js-packages/runtime`)

Mit Node 22 geprüft:
- `index.js` importiert `./types/record.js` – existiert nicht. Das ganze Paket ist dadurch nicht importierbar.
- `index.js` erwartet benannte Exporte (`List`, `isList`, `Tuple`, `isTuple`), die Module exportieren nur `default`.
- `union.js` enthält zwei `export default class Union` → SyntaxError.
- `list.js`: Methode `clone()` und Getter `get clone` haben denselben Namen; der Getter gewinnt und ruft sich selbst auf → Endlosrekursion. Damit sind alle `to*`-Methoden (`toSorted`, `toReversed`, …) kaputt. `toUnshifted` ruft das nicht existierende `unshifted`, `toShifted` gibt das Element statt der Liste zurück.
- `tuple.js`: `isTuple` ist nicht `static` und nutzt `stz`/`sth` (Tippfehler).
- `helpers.js`: `new Tuple(elements)` / `new List(elements)` übergeben das Array als *ein* Element (Konstruktoren sind variadisch).
- `_prototype.js` erweitert `String.prototype` global – kollidiert potenziell mit anderem JS-Code auf derselben Seite.
- `Type.js` enthält die solideste Logik (normalisierte Typnamen, `isType`) – guter Kandidat als Basis für `~=`.

### 4.3 Service Worker (`js-packages/worker`)

- Wird nirgends registriert (die Playground-`sw.js` ist die von aufbau).
- Import-Maps gelten für Dokumente, nicht für Worker – die Bare-Specifier `@cosmonaut/*` lösen dort nicht auf.
- `lsd.js` nutzt Top-Level-`await`; das ist in Service-Worker-Modulen nicht erlaubt.

### 4.4 Haskell (`haskell/`)

Kompiliert nicht: nicht existierende Namen (`TIdent`, `pOr`, `pExpr`, `parseApp`, `parseIdent`), doppelter Konstruktor `Unary`, `\case` ohne `LambdaCase`, `parseProgram` doppelt definiert, `- plain "or ..."` als Kommentar, keine `Stream`-Instanz für `[Token]`. `BraceL`/`BracketL` sind in `Token.hs` vertauscht kommentiert. `package.yaml` referenziert ein fehlendes `README.md`. Der Parser folgt der `switch { … or do … }`-Variante.

### 4.5 Odin (`runtimes/odin/`)

Kompiliert nicht: `Array` ist in `package types` zweimal definiert (`_value.odin`, `array.odin`); `_internal.odin` definiert ein eigenes, inkompatibles `Value` in `package runtime`; `_pkg.odin` importiert sechs nicht existierende Packages. Es gibt keinen Codegen Richtung Odin (nur Skizzen in `poo2.lsd`). Das Dokument `_devnotes/package_integration.md` ist eine gute Architektur-Notiz (Transpiler statt Interpreter), aber noch Zukunftsmusik.

### 4.6 Repo-Hygiene

- `readme.md` (Root) und `docs/readme.md` duplizieren sich weitgehend.
- `_devnotes.md` mischt TODOs, Namens-Brainstorming, GitHub-Markdown-Spickzettel, fremden JS-Code und alte Grammatik-Fetzen.
- Kein `package.json` im Root, keine Tests, keine CI.

---

## 5. Abgleich mit deinen Zielen

| Ziel | Wo es in Poo steckt | Zustand |
| :--- | :--- | :--- |
| Lesbare Collection-Transformationen statt `filter`/`map`-Ketten | `\|?` `\|>` `\|*`, Punkt-Shorthand `.prop`, `{ .k: .v }`, `@` | stärkste Idee; Shorthand nur im Readme-Beispiel, nicht spezifiziert |
| Kein manuelles Typecheck-/Coercion-Boilerplate | `~=`, `~==`, `as`, `as?`, `or return`, Patterns, Unions | Kernversprechen; Spec lückenhaft und über 4 Dokumente verteilt |
| Mächtige, klare Datentypen | ~25 Typen | zu breit, überlappend; Klarheit leidet unter Menge |
| Läuft im Web (JS + Lib), nativ via Odin | Compiler, Runtime, Worker, Odin | kein Target läuft Ende-zu-Ende |

Beobachtung: Die beiden Features, die Poo von JS unterscheiden würden, sind gleichzeitig die am schwächsten spezifizierten. Dagegen sind Nebenschauplätze (Color, Blob, Fingerprint, Tree, Store, 30+ String-Case-Methoden, `fn^`-Purity) ausführlich dokumentiert.

---

## 6. Deine zwei Grundfragen

### 6.1 Sealing-Operator `#=` abschaffen

**Empfehlung: ja.** `#=` ist semantisch doppeldeutig (zuweisen+versiegeln vs. nur versiegeln), kollidiert mit `#`-Literalen im Lexer und ist für Highlighting ein Sonderfall. Ein Keyword löst alle drei Probleme:

```poo
seal config = { host: "localhost", port: 8080 };  // declare + seal

animals = #['bird', 'cat'];
seal animals;                                      // seal later
```

Folgeschritt: auch die Compile-time-Konstante `val #NAME` streichen. Ob ein versiegelter Wert zur Compile-Zeit auswertbar ist (Literal, reine Ausdrücke), kann der Compiler selbst erkennen und falten – dafür braucht es keine eigene Syntax. Dann bleibt `#` exklusiv für „strikte Literale“ (`#[` `#(` `#{` `#/`), was eine klare, lernbare Regel ist.

### 6.2 `val` abschaffen

**Empfehlung: ja, unter drei Bedingungen.** PHP funktioniert ohne Deklaration, weil Funktionen dort einen geschlossenen Scope haben und Closures explizit per `use` importieren – und genau dieses Modell hat Poo mit `use`/`ref` für Objekte schon angelegt. Die klassischen Probleme ohne Keyword lassen sich damit sauber lösen:

1. **Scope-Regel**: Eine Zuweisung an einen unbekannten Namen deklariert ihn im aktuellen *Funktions-/Objekt*-Scope (nicht Block-Scope). Keine Shadowing-Frage mehr, weil es kein Shadowing gibt.
2. **Lambdas lesen automatisch**: Arrow-Funktionen dürfen äußere Namen lesen (wie PHPs `fn() =>`), sonst werden Pipes wie `|? (x => x > limit)` selbst zu Boilerplate. Schreiben nach außen nur explizit (`ref`).
3. **Tippfehler-Schutz über den Compiler**: Lesen eines nie zugewiesenen Namens ist ein Compile-Fehler (statisch auflösbar, weil Scopes geschlossen sind). Zuweisen an einen Namen, der nie gelesen wird, ist eine Warnung. Das fängt `coutn = 1` ebenso ab wie ein Keyword.

Gewinn: weniger Rauschen, `val` verliert seine irreführende Bedeutung, und es gibt keine Debatte `val`/`var`/`let`. Kosten: der Compiler braucht eine echte Scope-Analyse – die braucht er für `seal`, `use`/`ref` und den JS-Codegen (`let`-Platzierung) aber ohnehin.

`fn` würde als Keyword bleiben, weil es mehr trägt als eine Deklaration (Hoisting, `fn*`, ggf. `fn^`).
