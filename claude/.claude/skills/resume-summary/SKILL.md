---
name: resume-summary
description: Writes one resume-ready sentence that summarizes the work done in the current session. Use when the user types /resume-summary.
argument-hint: "[focus or target role]"
disable-model-invocation: true
---

# Resume summary

Optional focus or target role: `$ARGUMENTS`

## 1. Find what was done

Use the current conversation as the main source. Identify the problem, what was built or changed, the technologies that mattered, and the result.

If the conversation does not show the full work, for example after a compaction or a resume, check `git diff` and `git log` on the current branch. Run nothing else, and change no files.

If the session has several separate pieces of work, choose the one a hiring manager would value most. Use the focus or target role to choose, if the user gave one.

## 2. Write the sentence

Write a resume bullet that starts with a strong past-tense verb and has no subject, such as "Built", "Reduced", or "Migrated". State what changed and why it mattered. Name a technology only if it adds to the claim. Aim for 15 to 30 words, because a longer bullet wraps poorly on a resume.

Claim only what the session supports, because the user must be able to defend each word in an interview:

- Use a number only if the session measured it or the code shows it. Do not estimate a metric.
- State an outcome only if it happened. Code that was written but not shipped was "built" or "implemented", not "launched" or "adopted by users".
- Do not inflate scope. A config change is not an "architecture", and a solo task does not show "leading a team".
- Describe the work without mentioning Claude or AI assistance, unless the AI tooling is itself the work.
- Do not name internal project names, customers, or secrets, because a resume is public.

Avoid filler such as "leveraged", "spearheaded", "robust", and "various".

**Example:**
Session: found an N+1 query on the orders endpoint, added eager loading, and a benchmark showed response time fall from 900ms to 120ms.
Output: `Cut orders API response time from 900ms to 120ms by eliminating N+1 queries with eager loading in Rails.`

**Example:**
Session: wrote a CLI that syncs dotfiles between machines, with no usage data.
Output: `Built a Python CLI that syncs configuration files across machines using Git-backed versioning.`

## 3. Output

Print only the sentence as plain text, with no heading, quotes, or commentary, so that the user can copy it directly.

If the session has no substantial work to summarize, such as only questions and answers, say so in one line instead of writing a sentence. If a real result is probably available but was not measured, add one line after the sentence that names the number to add.
