# IS Paper Review Skill

Structured peer-review skill for Information Systems (IS) manuscripts targeting venues such as MISQ, ISR, JMIS, JAIS, and EJIS. It supports quantitative, qualitative, design science, conceptual, and mixed-methods papers.

## What It Covers

- 10 core review dimensions: significance, contribution, journal fit, theory, methodology, data quality, logic, literature, limitations, and clarity
- Methodology-specific review checklists
- A structured review template for author-facing comments and the confidential editor note
- A constructive "diamond miner" review style: rigorous, specific, and actionable

## Quick Install

### Codex

```bash
curl -fsSL https://raw.githubusercontent.com/c0mm4nd/is-review-skill/main/install.sh | bash -s -- --codex
```

### Claude Code

```bash
curl -fsSL https://raw.githubusercontent.com/c0mm4nd/is-review-skill/main/install.sh | bash -s -- --claude
```

### Install Both

```bash
curl -fsSL https://raw.githubusercontent.com/c0mm4nd/is-review-skill/main/install.sh | bash
```

After installation, start a new Claude Code or Codex session.

## Private Repo Install

If the repository is private, install through the GitHub Contents API with a token instead of cloning:

```bash
export GITHUB_TOKEN=YOUR_GITHUB_TOKEN

curl -fsSL \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  -H "Accept: application/vnd.github.raw" \
  "https://api.github.com/repos/c0mm4nd/is-review-skill/contents/install.sh?ref=main" | \
  bash -s -- --codex --github-api --repo c0mm4nd/is-review-skill --ref main
```

`GH_TOKEN` also works. Replace `--codex` with `--claude` if needed.

## Agent-Assisted Install

If your agent can run shell commands, you can ask it to install this skill directly from GitHub without cloning.

Example prompts:

```text
Install the skill from https://github.com/c0mm4nd/is-review-skill for Codex. Do not clone the repository; use the remote installer.
```

```text
请帮我把 https://github.com/c0mm4nd/is-review-skill 安装成 Codex skill，不要 clone，直接用远程安装脚本。
```

For private repositories, give the agent an authenticated GitHub context or `GITHUB_TOKEN`.

## What Gets Installed

The installer copies only the skill package:

```text
is-paper-review/
  SKILL.md
  references/
    review-framework.md
    methodology-guides.md
    review-template.md
```

Install targets:

- Codex: `~/.agents/skills/is-paper-review/`
- Claude Code: `~/.claude/skills/is-paper-review/`

`AGENTS.md` is repository-local guidance for working inside this repo. It is not required for skill installation or execution.

## Usage

Trigger the skill naturally in a new session:

```text
Review this IS paper for MISQ submission
Critique this IS manuscript like an ISR reviewer
Give me a qualitative research review of this manuscript
帮我审这篇信息系统论文，目标期刊是 JAIS
```

## Repository Layout

```text
.
├── install.sh
├── is-paper-review/
│   ├── SKILL.md
│   └── references/
│       ├── methodology-guides.md
│       ├── review-framework.md
│       └── review-template.md
├── AGENTS.md
└── README.md
```

Key files:

- `is-paper-review/SKILL.md`: entrypoint and review workflow
- `is-paper-review/references/methodology-guides.md`: method-specific checklists
- `is-paper-review/references/review-framework.md`: detailed evaluation criteria
- `is-paper-review/references/review-template.md`: review output template
- `install.sh`: local or remote installer
- `AGENTS.md`: optional repo-maintenance instructions, not part of the installed skill

## Local Development Install

If you already have a local checkout:

```bash
./install.sh --codex
./install.sh --claude
./install.sh
```

You can also install from a fork or branch:

```bash
curl -fsSL https://raw.githubusercontent.com/c0mm4nd/is-review-skill/main/install.sh | \
  bash -s -- --codex --repo OWNER/REPO --ref BRANCH_OR_TAG
```
