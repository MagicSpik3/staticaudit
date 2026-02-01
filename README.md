# staticaudit
A static analysis tool

analyse_project("examples/bad_repo") |> print_smells()


Designing a static analysis tool is one of those projects where the architecture matters just as much as the algorithms. If you get the components right early, everything else becomes easier to extend, test, and explain in your dissertation. Since you’re building this in R, you also get to take advantage of R’s introspection tools, parse data, and existing analysis packages.

Here’s a clean, professional‑grade breakdown of the **core components** every static analysis tool should include, along with how they fit together.

---

# 🧱 1. **Project Scanner**
This is the entry point of your tool.

### Purpose
Identify which files should be analysed.

### Responsibilities
- Walk the directory tree  
- Respect `.Rbuildignore`  
- Identify `.R`, `.Rmd`, and optionally `.Rnw`  
- Return a structured list of file paths  

### Why it matters
Static analysis is only as good as the code you feed it. A predictable scanner makes your tool reproducible.

---

# 📄 2. **Source Loader**
Reads the raw text of each file.

### Responsibilities
- Read files safely  
- Preserve line numbers  
- Handle encoding  
- Store metadata (file path, size, timestamp)  

### Why it matters
Line numbers and file paths are essential for meaningful diagnostics.

---

# 🔤 3. **Lexer / Tokeniser**
Turns raw text into tokens.

### In R
You can use:
- `utils::getParseData()`  
- `xmlparsedata::xml_parse_data()`  

### Responsibilities
- Identify symbols, operators, literals, keywords  
- Capture line/column positions  
- Preserve comments (optional but useful)  

### Why it matters
Tokenisation is the foundation for style checks, naming checks, and structural analysis.

---

# 🌳 4. **Parser / AST Builder**
Builds an Abstract Syntax Tree (AST).

### In R
- `parse()`  
- `rlang::call_tree()`  
- `xmlparsedata` for XML ASTs  

### Responsibilities
- Represent code structure  
- Capture nested calls  
- Represent control flow constructs  

### Why it matters
The AST is where you detect:
- unused variables  
- deeply nested code  
- complex expressions  
- function structure  

---

# 🧠 5. **Semantic Analysis**
Gives meaning to the AST.

### Responsibilities
- Scope resolution (global vs local)  
- Variable binding  
- Function call resolution  
- Detecting side effects  
- Light type inference (optional)  

### Tools in R
- `codetools`  
- `rlang`  

### Why it matters
This is where your tool becomes “intelligent” rather than just structural.

---

# 🔁 6. **Control Flow Analysis (CFA)**
Optional but powerful.

### Responsibilities
- Build a Control Flow Graph (CFG)  
- Identify unreachable code  
- Compute cyclomatic complexity  
- Detect risky patterns (deep nesting, long chains)  

### Why it matters
Complexity metrics are central to your “before vs after refactoring” audit.

---

# 📊 7. **Metrics Engine**
Computes quantitative measures.

### Common metrics
- Lines of code  
- Comment density  
- Cyclomatic complexity  
- Function length  
- Nesting depth  
- Number of arguments  
- Number of dependencies  
- Number of global variables  

### Why it matters
These metrics form the backbone of your audit reports.

---

# 🧪 8. **Rule Engine (Linting)**
Applies rules to AST, tokens, or metrics.

### Responsibilities
- Define rules (each rule = one check)  
- Register rules in a rule registry  
- Apply rules consistently  
- Produce diagnostics  

### Examples
- “Function too long”  
- “Avoid `<<-`”  
- “Variable names must be snake_case”  
- “Avoid deeply nested `if` statements”  

### Why it matters
Rules give your tool practical value.

---

# 📦 9. **Reporting Layer**
Turns analysis results into something humans can use.

### Output formats
- Data frames  
- JSON  
- Markdown  
- HTML  
- Visualisations  

### Contents
- Summary metrics  
- Violations  
- Complexity charts  
- Dependency graphs  

### Why it matters
This is what your examiners will see.

---

# 🔄 10. **Audit Comparator (Before vs After Refactoring)**
This is the signature feature of your project.

### Responsibilities
- Compare metrics  
- Compare rule violations  
- Compare function lists  
- Compare dependency graphs  
- Highlight improvements or regressions  

### Why it matters
It turns your tool from a linter into a **refactoring evaluation system**.

---

# 🧰 11. **Orchestration Layer**
The pipeline that ties everything together.

### Responsibilities
Define the workflow:

```
scan → load → tokenise → parse → analyse → metrics → rules → report → compare
```

### Why it matters
This is the “engine” of your tool.

---

# 🧪 12. **Test Suite (TDD)**
Since you’re doing TDD, this is essential.

### Types of tests
- Unit tests (tokeniser, parser, metrics)  
- Integration tests (AST → metrics → rules)  
- End‑to‑end tests using your dummy package (`mypkg`)  
- Regression tests  

### Why it matters
Static analysis tools are brittle without strong tests.

---

# 🎯 Summary: The 12 Essential Components

| Component | Purpose |
|----------|---------|
| Project Scanner | Find files |
| Source Loader | Read code |
| Tokeniser | Break into tokens |
| AST Builder | Build structure |
| Semantic Analysis | Understand meaning |
| Control Flow Analysis | Understand execution |
| Metrics Engine | Compute complexity |
| Rule Engine | Apply checks |
| Reporting Layer | Produce output |
| Audit Comparator | Before/after refactoring |
| Orchestration Layer | Pipeline |
| Test Suite | Reliability |

---

If you want, I can help you:

- design the architecture diagram  
- generate the initial package skeleton  
- write the first TDD tests  
- build the AST walker  
- design the rule engine  
- create the before/after audit format  

Just tell me where you want to go next.