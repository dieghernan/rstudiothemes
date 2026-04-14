---
name: proofread-comments
description: Review the roxygen2 and R comments of the source of this R package
---

## Purpose

This skill enables the agent to act as an expert reviewer of **roxygen2
comments** and **regular R comments** in R package source files.\
The agent improves clarity, grammar, consistency, and style while ensuring that
**no executable code is ever modified**.

This skill is designed to work together with the `review-comments` agent.

--------------------------------------------------------------------------------

## What the Skill Does

When invoked, the agent:

1.  Reviews all roxygen2 (`#'`) and regular R comments (`#`) in the provided
    text.
2.  Identifies issues related to:
    -   clarity
    -   grammar and punctuation
    -   consistency across files
    -   roxygen2 tag correctness
    -   adherence to style rules
3.  Suggests improved versions of the comments.
4.  Classifies each issue as **Critical**, **Major**, or **Minor**.
5.  Produces rewritten comments that follow the formatting rules below.
6.  Waits for explicit confirmation before applying any changes to files.

--------------------------------------------------------------------------------

## What the Skill Must Not Do

The agent must **never**:

-   modify executable R code
-   change function signatures
-   alter indentation outside comments
-   introduce or remove roxygen2 tags unless explicitly instructed
-   rewrite examples in a way that changes behavior
-   exceed 80 characters per line
-   apply changes without user approval

--------------------------------------------------------------------------------

## Review Criteria

### 1. Clarity

-   Comments must be easy to understand.
-   Avoid vague or ambiguous phrasing.
-   Ensure descriptions match the actual behavior of the function.

### 2. Grammar and Style

-   Correct grammar, spelling, and punctuation.
-   Avoid the Oxford comma.
-   Prefer commas over semicolons.
-   Maintain a concise, professional tone.

### 3. Consistency

-   Terminology must be consistent across files.
-   Parameter descriptions must match function arguments.
-   Similar concepts should be described similarly.

### 4. roxygen2-Specific Requirements

-   `@param` entries must correspond to actual function parameters.
-   `@return` must accurately describe the output.
-   `@examples` must be syntactically correct (but not executed or altered
    semantically).
-   Tags must follow roxygen2 conventions.

### 5. Formatting Rules

-   Maximum **80 characters per line**.
-   Preserve indentation and comment structure.
-   Wrap lines only when necessary or when rewriting.

--------------------------------------------------------------------------------

## Issue Severity Levels

Each finding must be labeled as:

-   **Critical** — misleading, incorrect, inconsistent, or missing documentation
-   **Major** — unclear, poorly written, or confusing text
-   **Minor** — stylistic or optional improvements

--------------------------------------------------------------------------------

## Expected Output

When using this skill, the agent must output:

1.  A **summary** of findings.
2.  A **detailed list of issues**, grouped by file and severity.
3.  **Proposed improved comments**, ready to apply.
4.  A final question asking whether to apply the changes.

--------------------------------------------------------------------------------

## Examples

### Good roxygen2 comment

``` r
#' Normalize a numeric vector
#'
#' @param x Numeric vector to normalize.
#' @return A numeric vector scaled to the [0, 1] range.
#' @examples
#' normalize(c(1, 2, 3))
```

### Poor roxygen2 comment

``` r
#' Normalize stuff
#' @param x The data
#' @return Something normalized
```

### Good regular comment

``` r
# Compute the scaling factor for normalization
```

### Poor regular comment

``` r
# do stuff here
```

## Behavior Summary

When this skill is active, the agent:

-   Reviews comments only
-   Suggests improvements
-   Classifies issues
-   Respects strict formatting rules
-   Never modifies code
-   Applies changes only after explicit approval

This ensures safe, consistent, high‑quality documentation improvements across
the project.
