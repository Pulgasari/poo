# devnotes

## Datatype Names

```md
Catalog Cluster Cohort
Ensemble
Group
Hub
Pack Pool Pure
Register Registry
Sequence Singles
Uniq Unique
Vault
```

## GitHub Syntax

> [!CAUTION]
> Advises about risks or negative outcomes of certain actions.

```md
> [!CAUTION]
> 
```

> [!IMPORTANT]
> Key information users need to know to achieve their goal.

```md
> [!IMPORTANT]
> 
```

> [!NOTE]
> Useful information that users should know, even when skimming content.

```md
> [!NOTE]
> 
```

> [!TIP]
> Helpful advice for doing things better or more easily.

```md
> [!TIP]
> 
```

> [!WARNING]
> Urgent info that needs immediate user attention to avoid problems.

```md
> [!WARNING]
> 
```

---






```
first class function
higher order function
pattern matching
list comprehension
generator expression
```

...

## Examples

###

```c
fn processPayload = filePath => {
  val text = fs::read(filePath) or return "file missing";
  val data = json::parse(text)  or return "invalid json structure";

  if (data ~= obj{ id: Number, targetUrl: String }) {
    safeUrl = data.targetUrl >> url::decode >> html::escape;
    print "Processing safe target: $safeUrl";
  }
  or return "payload fields are garbage";
};

```

###

```javascript
prop globalCounter = 0;
prop configName    = 'dev';
prop baseStats     = { hp: 100 };

prop player = {
  use baseStats;      // Statische Kopie
  ref configName;     // Live-Ansicht (Copy-on-Write)
  pnt globalCounter;  // Aktiver Pointer

  prop tick = () => {
    // 1. Lokaler Zugriff (Kein Präfix)
    print baseStats.hp; 

    // 2. Live-Read-Zugriff (Präfix @)
    print @configName; 

    // 3. Durchschreibender Zugriff (Präfix &)
    &globalCounter += 1; 
  };
};
```


