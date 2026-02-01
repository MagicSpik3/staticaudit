# 🔍 staticaudit

**A Static Analysis & Refactoring Evaluation Tool for R**

`staticaudit` is designed to peek behind the "Map" of your R code to analyze the messy, continuous, human "Territory" underneath. It provides a structured pipeline to scan, parse, and audit R projects for security risks, complexity, and code smells.

## 🚀 Quick Start

```r
# Load the tool
devtools::load_all()

# Run an audit on a project directory
report <- analyse_project("path/to/your/repo")

# View the results (uses S3 custom print method)
report

```

## 🏗 Current Architecture

The tool is built on a modular pipeline, ensuring that each step from file discovery to reporting is testable and discrete.

1. **Project Scanner**: Recursively identifies `.R` files.
2. **Source Loader**: Reads raw text while preserving source references.
3. **Context Builder**: Peeks into the R parser (`utils::getParseData`) to extract symbols and function calls.
4. **Rule Engine**: Applies logic to the context. Rules are independent and extensible.
5. **S3 Reporting Layer**: Uses a custom `staticaudit_report` class to provide clean, color-coded CLI output via the `cli` package.

---

## ✅ Implemented Features

* [x] **Project Scanning**: Recursive `.R` file detection.
* [x] **AST Context Extraction**: Extracts function calls and symbols across multiple files.
* [x] **S3 Class System**: `staticaudit_report` objects with custom printing.
* [x] **Security Audit Rule**: Detects dynamic execution (`get`, `assign`) which can lead to injection vulnerabilities or unmaintainable code.
* [x] **Integrated Test Suite**: TDD-backed development using `testthat` with project fixtures.

---

## 📅 TO DO... (The Roadmap)

### 📊 Metrics Engine

* [ ] **Cyclomatic Complexity**: Implement a CFG (Control Flow Graph) walker to compute McCabe complexity.
* [ ] **Function Length**: Identify "God Functions" that exceed 50 lines.
* [ ] **Nesting Depth**: Alert on deeply nested `if` and `for` loops.

### 🧠 Semantic Analysis

* [ ] **Dead Code Detection**: Identify functions defined in `R/` that are never called within the project.
* [ ] **Global Assignment Check**: Flag the use of the `<<-` operator.
* [ ] **Dependency Mapping**: Visualize how functions call each other across file boundaries.

### 🔄 Refactoring Evaluation (The "Signature" Feature)

* [ ] **Audit Comparator**: A "Before vs. After" mode that compares two states of a git repo and highlights the reduction in smells and complexity.
* [ ] **Export to JSON/Markdown**: For integration into CI/CD pipelines and dissertation appendices.

---

## 🧪 Testing

The project uses `testthat` with localized fixtures to ensure the "Map" always reflects the "Territory."

```r
devtools::test()

```

---

## 🛠 Contributing

This tool is built for engineers and philosophers alike. If you are peeking behind the code and find a pattern worth auditing, feel free to contribute a new rule to `R/default_rules.R`.

---
