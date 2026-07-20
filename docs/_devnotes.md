---

> [!NOTE]
> Useful information that users should know, even when skimming content.

> [!TIP]
> Helpful advice for doing things better or more easily.

> [!IMPORTANT]
> Key information users need to know to achieve their goal.

> [!WARNING]
> Urgent info that needs immediate user attention to avoid problems.

> [!CAUTION]
> Advises about risks or negative outcomes of certain actions.


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

```
first class function
higher order function
pattern matching
list comprehension
generator expression
```


