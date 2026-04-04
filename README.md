# IS Paper Review Skill

An authoritative, structured peer-review skill for Information Systems (IS) research papers, grounded in the IS review literature spanning 1995–2023. Compatible with both **Claude Code** and **OpenAI Codex** as an installable skill.

## What This Skill Does

- Conducts expert peer reviews of IS manuscripts targeting top venues (MISQ, ISR, JMIS, JAIS, EJIS, etc.)
- Evaluates papers across **10 core IS review dimensions** with detailed, actionable feedback
- Provides **methodology-specific checklists** for quantitative, qualitative, design science, and conceptual papers
- Generates a **structured review** ready to submit to a journal or share with authors
- Follows the "diamond miner" philosophy: seeking the value in work while maintaining scholarly rigor

## Installation

`git clone` is not required. `install.sh` supports direct remote installation and will fetch the skill files itself.

### Option A — Direct Install From GitHub

**Public repository, Codex**

```bash
curl -fsSL https://raw.githubusercontent.com/c0mm4nd/is-review-skill/main/install.sh | bash -s -- --codex
```

**Public repository, Claude Code**

```bash
curl -fsSL https://raw.githubusercontent.com/c0mm4nd/is-review-skill/main/install.sh | bash -s -- --claude
```

**Install both**

```bash
curl -fsSL https://raw.githubusercontent.com/c0mm4nd/is-review-skill/main/install.sh | bash
```

This installs the skill to:

- `~/.agents/skills/is-paper-review/` for Codex
- `~/.claude/skills/is-paper-review/` for Claude Code

To install from a fork or branch without cloning:

```bash
curl -fsSL https://raw.githubusercontent.com/c0mm4nd/is-review-skill/main/install.sh | \
  bash -s -- --codex --repo OWNER/REPO --ref BRANCH_OR_TAG
```

### Option B — Direct Install From a Private GitHub Repository

If the repository is private, use a GitHub token and fetch through the GitHub Contents API instead of cloning:

```bash
export GITHUB_TOKEN=YOUR_GITHUB_TOKEN

curl -fsSL \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  -H "Accept: application/vnd.github.raw" \
  "https://api.github.com/repos/c0mm4nd/is-review-skill/contents/install.sh?ref=main" | \
  bash -s -- --codex --github-api --repo c0mm4nd/is-review-skill --ref main
```

Swap `--codex` for `--claude` if needed. The installer also accepts `GH_TOKEN`.

### Option C — Agent-Assisted Install

If your agent environment can execute shell commands or install skills from GitHub repo paths, you can ask it to install this repo directly without cloning.

**Prompt examples**

```text
Install the skill from https://github.com/c0mm4nd/is-review-skill for Codex. Do not clone the repository locally; use the repo's remote installer.
```

```text
请帮我把 https://github.com/c0mm4nd/is-review-skill 安装成 Codex skill，不要先 clone，到 ~/.agents/skills/is-paper-review。
```

For private repositories, give the agent an authenticated GitHub context or a `GITHUB_TOKEN`, then have it use the GitHub API install path above.

### Option D — Local Install While Developing

If you are already inside a checkout and want to install the local working copy:

```bash
./install.sh --codex
./install.sh --claude
./install.sh
```

### After Installation

Start a new Claude Code or Codex session. Trigger the skill naturally:

```text
Review this IS paper for MISQ submission
Give me a qualitative research review of this manuscript
Critique this IS manuscript like an ISR reviewer
帮我审这篇信息系统论文，目标期刊是 JAIS
```

## Repository Structure

```
.
├── AGENTS.md                             # Repo-local instructions for working inside this repository
├── install.sh                            # Installs the skill into Claude Code and/or Codex skill dirs
├── is-paper-review/
│   ├── SKILL.md                          # Installable skill entrypoint for Claude Code and Codex
│   └── references/
│       ├── review-framework.md           # Detailed criteria for all 10 dimensions
│       ├── methodology-guides.md         # Method-specific checklists
│       └── review-template.md            # Structured review output template
└── README.md
```

| File | Claude Code | Codex |
|---|---|---|
| `is-paper-review/SKILL.md` | Core trigger + workflow | Core trigger + workflow |
| `install.sh` | Local or remote install into `~/.claude/skills/` | Local or remote install into `~/.agents/skills/` |
| `AGENTS.md` | Repo-local only | Repo-local only |
| `references/review-framework.md` | Loaded on demand | Read on demand |
| `references/methodology-guides.md` | Loaded on demand | Read on demand |
| `references/review-template.md` | Loaded on demand | Read on demand |

## The 10 Core Review Dimensions

1. **Phenomenon & Significance** — Problem importance and IS relevance
2. **Originality & Contribution** — Novel advancement beyond prior work
3. **Journal Fit** — Alignment with venue scope and audience
4. **Theoretical Foundation** — Rigor and appropriateness of theory
5. **Methodology** — Research design quality and justification
6. **Data Quality & Validity** — Trustworthiness of evidence and claims
7. **Logical Correctness** — Soundness of inferences and reasoning
8. **Literature Coverage** — Engagement with seminal and current work
9. **Limitations & Future Work** — Honest acknowledgment of boundaries
10. **Presentation & Clarity** — Organization, precision, and readability

## Sample Review Structure

The skill generates a structured review with:

- **Summary** — Brief paper overview (signals fair reading)
- **Overall Assessment** — Holistic judgment with recommendation
- **Key Strengths** — Genuine positives to preserve
- **Major Issues** — Numbered, with: what / why it matters / how to fix
- **Minor Issues** — Numbered improvements
- **Methodology Notes** — Paradigm-specific assessment
- **Literature Notes** — Key missing citations
- **Confidential Editor Note** — Recommendation + rationale
