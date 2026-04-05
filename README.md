# IS Paper Review Skill

Structured peer-review skill for Information Systems (IS) manuscripts targeting venues such as MISQ, ISR, JMIS, JAIS, and EJIS. It supports quantitative, qualitative, design science, conceptual, and mixed-methods papers.

## What It Covers

- 10 core review dimensions: significance, contribution, journal fit, theory, methodology, data quality, logic, literature, limitations, and clarity
- Methodology-specific review checklists
- A structured review template for author-facing comments and the confidential editor note
- A constructive "diamond miner" review style: rigorous, specific, and actionable

## Install

```bash
npx skills add c0mm4nd/is-review-skill
```

After installation, start a new Claude Code or Codex session.

## Usage

Trigger the skill naturally in a new session:

```text
Review this IS paper for MISQ submission
Critique this IS manuscript like an ISR reviewer
Give me a qualitative research review of this manuscript
帮我审这篇信息系统论文，目标期刊是 JAIS
```

## What Gets Installed

```text
is-paper-review/
  SKILL.md
  references/
    review-framework.md
    methodology-guides.md
    review-template.md
```

Install targets:

- Claude Code: `~/.claude/skills/is-paper-review/`
- Codex: `~/.agents/skills/is-paper-review/`

## Repository Layout

```text
.
├── is-paper-review/
│   ├── SKILL.md
│   └── references/
│       ├── methodology-guides.md
│       ├── review-framework.md
│       └── review-template.md
└── README.md
```

Key files:

- `is-paper-review/SKILL.md`: entrypoint and review workflow
- `is-paper-review/references/methodology-guides.md`: method-specific checklists
- `is-paper-review/references/review-framework.md`: detailed evaluation criteria
- `is-paper-review/references/review-template.md`: review output template

## Local Development

From a local checkout:

```bash
npx skills add .
```
