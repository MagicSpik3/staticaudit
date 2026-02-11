# staticaudit AI Coding Guidelines

## Project Overview
staticaudit is an R package for static code analysis of R projects. It scans R files, parses them, builds a context of function calls and symbols, applies rules to detect code smells (e.g., security issues), and generates reports.

## Architecture
- **Pipeline**: `scan_project` → `load_sources` → `parse_sources` → `build_context` → `run_rules` → report
- **Context**: List containing `calls` (tibble with `name`, `line`, `file` columns)
- **Rules**: Functions taking `ctx` and returning `new_smell` objects
- **Smells**: Tibbles with columns: `file`, `line`, `id`, `message`, `severity` (factor: CRITICAL/HIGH/MEDIUM/LOW), `category`, `confidence`
- **Reporting**: S3 class `staticaudit_report` with custom `print` method using `cli` package

## Key Patterns
- Use `tibble::tibble` for data structures
- Validate inputs and return empty structures for no results (e.g., `new_smell(...)[0, ]`)
- Rules detect specific patterns in `ctx$calls$name` (e.g., `c("get", "assign")`)
- Export functions via roxygen `@export`
- Use `cli::cli_alert_info` for progress logging in main functions
- Test with `testthat`, using `test_path` for fixtures in `tests/fixtures/`

## Development Workflow
- `devtools::load_all()` to load package
- `devtools::test()` to run tests
- `devtools::document()` to update roxygen docs
- Fixtures: `tests/fixtures/simple/` for clean code, `tests/fixtures/bad/` for triggering smells

## Dependencies
- Imports: `dplyr`
- Suggests: `testthat`, `devtools`, `cli` (used in code)

## Conventions
- Severity levels: CRITICAL > HIGH > MEDIUM > LOW
- Categories: SECURITY, etc.
- Confidence: MEDIUM (default)
- File paths relative to project root
- Use `basename(file)` in reports for readability

## Examples
- Add rule: Define in `default_rules()` list, implement as function in `R/rule_*.R`
- Test rule: Use fixtures, expect specific `id` in results
- Context building: Extract from `utils::getParseData(parsed)` for SYMBOL_FUNCTION_CALL and SYMBOL tokens</content>
<parameter name="filePath">/home/jonny/R_Code/staticaudit/.github/copilot-instructions.md