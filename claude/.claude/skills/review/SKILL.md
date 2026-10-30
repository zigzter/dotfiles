---
name: review
description: Runs /code-review with the same arguments, then writes the confirmed findings to a remediation markdown file in /tmp for another agent to fix, and prints its path. Use when the user types /review.
argument-hint: "[low|medium|high|xhigh|max] [target] [--max-findings <n>]"
disable-model-invocation: true
---

# Review with a remediation file

Arguments: `$ARGUMENTS`

## 1. Run the review

Invoke the `code-review` skill with the Skill tool and pass `$ARGUMENTS` through unchanged. Follow its instructions fully, including how it reports findings. This skill adds a step after the review. It does not change how the review works.

Keep the verified findings that the review reports. You need them for step 2.

If the review finds nothing, say so and stop. Do not write a file.

## 2. Write the remediation file

Another agent, in a different session, reads this file and fixes the findings. That agent has none of your context, so the file must stand on its own. Give absolute paths, enough detail to find each problem, and the reason it is wrong.

Get the context:

```bash
git rev-parse --show-toplevel
git branch --show-current
```

Write the file to `/tmp/claude-review/<repo-name>-<branch>-<YYYYMMDD-HHMMSS>.md`. Replace `/` in the branch name with `-`. Create the directory if it does not exist.

Use this template:

```markdown
# Review findings: <repo-name> @ <branch>

- Repo: <absolute repo path>
- Branch: <branch>
- Review target: <what was reviewed, e.g. "working tree diff vs main" or "PR #42">
- Generated: <ISO timestamp>

## How to work through this file

1. Check each finding against the code before you fix it. The review can be wrong. If a finding is not a real problem, mark it skipped and give the reason.
2. Fix the confirmed findings in order. Keep each fix small and limited to the finding.
3. Run the project's tests and linters for the files you changed.
4. **When all findings are fixed or skipped, run `/simplify` on the changed code.**
5. Report which findings you fixed and which you skipped.

## Findings

### 1. [ ] <short summary>

- Location: `<repo-relative path>:<line>`
- Category: <category>
- Verdict: <CONFIRMED | PLAUSIBLE, if the review set one>
- Problem: <one-sentence statement of the defect>
- Failure scenario: <concrete inputs or state, and the wrong result>

### 2. [ ] ...

## Final step

- [ ] Run `/simplify` on the changed code.
```

Keep the findings in the order the review ranked them, most severe first.

## 3. Print the path

End your reply with the absolute path to the file on its own line, so the user can copy it:

```
Remediation file: /tmp/claude-review/<file>.md
```

If `$ARGUMENTS` contains `--fix`, the review has already applied the fixes. Still write the file, but mark each finding `[x]` and add "(applied by /code-review --fix)" after its summary. The agent then only checks the fixes and runs `/simplify`.
