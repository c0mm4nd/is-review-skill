# IS Paper Review Skill

An authoritative, structured peer-review skill for Information Systems (IS) research papers, grounded in the IS review literature spanning 1995–2023. Compatible with both **Claude Code** and **OpenAI Codex** as an installable skill.

## What This Skill Does

- Conducts expert peer reviews of IS manuscripts targeting top venues (MISQ, ISR, JMIS, JAIS, EJIS, etc.)
- Evaluates papers across **10 core IS review dimensions** with detailed, actionable feedback
- Provides **methodology-specific checklists** for quantitative, qualitative, design science, and conceptual papers
- Generates a **structured review** ready to submit to a journal or share with authors
- Follows the "diamond miner" philosophy: seeking the value in work while maintaining scholarly rigor

## Installation

The repository is currently private, so the reliable install path is: clone it locally, then run `install.sh` from the checkout.

### Option A — Claude Code

**Prerequisites:** [Claude Code](https://claude.ai/code) installed

```bash
git clone git@github.com:c0mm4nd/is-review-skill.git
cd is-review-skill
./install.sh --claude
```

This installs the skill to `~/.claude/skills/is-paper-review/`. Restart Claude Code — the skill is auto-discovered.

**Usage:** Trigger naturally in any Claude Code session:

```
"Review this IS paper for MISQ submission"
"Give me a qualitative research review of this manuscript"
"What are the weaknesses of this paper from a reviewer's perspective?"
"Evaluate the theory section against top IS journal standards"
```

---

### Option B — OpenAI Codex

**Prerequisites:** Codex installed

```bash
git clone git@github.com:c0mm4nd/is-review-skill.git
cd is-review-skill
./install.sh --codex
```

This installs the skill to `~/.agents/skills/is-paper-review/`. Start a new Codex session and trigger it naturally:

```
"Review this IS paper for MISQ submission"
"Critique this IS manuscript like an ISR reviewer"
"帮我审这篇信息系统论文，目标期刊是 JAIS"
```

### Option C — Install Both

```bash
git clone git@github.com:c0mm4nd/is-review-skill.git
cd is-review-skill
./install.sh
```

With no flags, `install.sh` installs to both `~/.claude/skills/` and `~/.agents/skills/`.

### Optional — Remote Install After the Repo Is Public

Once the repository is publicly reachable through GitHub raw URLs, these shortcuts also work:

```bash
curl -fsSL https://raw.githubusercontent.com/c0mm4nd/is-review-skill/main/install.sh | bash -s -- --codex
curl -fsSL https://raw.githubusercontent.com/c0mm4nd/is-review-skill/main/install.sh | bash -s -- --claude
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
| `install.sh` | Installs into `~/.claude/skills/` | Installs into `~/.agents/skills/` |
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
