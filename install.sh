#!/usr/bin/env bash
# Install is-paper-review as a Claude Code and/or Codex skill.
# Local usage examples:
#   ./install.sh
#   ./install.sh --codex
#   ./install.sh --claude
# Remote usage only works when the raw GitHub URL is reachable.

set -euo pipefail

REMOTE_BASE="${REMOTE_BASE:-https://raw.githubusercontent.com/c0mm4nd/is-review-skill/main}"
SOURCE_HINT="${BASH_SOURCE[0]:-${0:-}}"
SCRIPT_DIR=""
if [[ -n "${SOURCE_HINT}" && "${SOURCE_HINT}" != "bash" && "${SOURCE_HINT}" != "-bash" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${SOURCE_HINT}")" && pwd)"
fi
LOCAL_SOURCE_DIR="${SCRIPT_DIR}/is-paper-review"

INSTALL_CLAUDE=0
INSTALL_CODEX=0

usage() {
  cat <<'EOF'
Install is-paper-review as an agent skill.

Usage:
  ./install.sh [--claude] [--codex] [--all]

Options:
  --claude  Install to ~/.claude/skills/is-paper-review
  --codex   Install to ~/.agents/skills/is-paper-review
  --all     Install to both locations (default when no option is given)
  -h, --help  Show this help text
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --claude)
      INSTALL_CLAUDE=1
      ;;
    --codex)
      INSTALL_CODEX=1
      ;;
    --all)
      INSTALL_CLAUDE=1
      INSTALL_CODEX=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
  shift
done

if [[ "${INSTALL_CLAUDE}" -eq 0 && "${INSTALL_CODEX}" -eq 0 ]]; then
  INSTALL_CLAUDE=1
  INSTALL_CODEX=1
fi

copy_from_local() {
  local destination="$1"

  mkdir -p "${destination}/references"
  cp "${LOCAL_SOURCE_DIR}/SKILL.md" "${destination}/SKILL.md"
  cp "${LOCAL_SOURCE_DIR}/references/review-framework.md" "${destination}/references/review-framework.md"
  cp "${LOCAL_SOURCE_DIR}/references/methodology-guides.md" "${destination}/references/methodology-guides.md"
  cp "${LOCAL_SOURCE_DIR}/references/review-template.md" "${destination}/references/review-template.md"
}

copy_from_remote() {
  local destination="$1"

  command -v curl >/dev/null 2>&1 || {
    echo "curl is required when installing from the remote repository." >&2
    exit 1
  }

  fetch_remote() {
    local remote_path="$1"
    local output_path="$2"

    if ! curl -fsSL "${REMOTE_BASE}/${remote_path}" -o "${output_path}"; then
      echo "Remote install failed while fetching ${remote_path}." >&2
      echo "If this repository is private, clone it locally and run ./install.sh from the checkout." >&2
      exit 1
    fi
  }

  mkdir -p "${destination}/references"
  fetch_remote "is-paper-review/SKILL.md" "${destination}/SKILL.md"
  fetch_remote "is-paper-review/references/review-framework.md" "${destination}/references/review-framework.md"
  fetch_remote "is-paper-review/references/methodology-guides.md" "${destination}/references/methodology-guides.md"
  fetch_remote "is-paper-review/references/review-template.md" "${destination}/references/review-template.md"
}

install_target() {
  local base_dir="$1"
  local label="$2"
  local destination="${base_dir}/is-paper-review"

  echo "Installing ${label} skill to ${destination}"

  if [[ -f "${LOCAL_SOURCE_DIR}/SKILL.md" ]]; then
    copy_from_local "${destination}"
  else
    copy_from_remote "${destination}"
  fi

  echo "Installed ${label} skill to ${destination}"
}

if [[ "${INSTALL_CLAUDE}" -eq 1 ]]; then
  install_target "${HOME}/.claude/skills" "Claude Code"
fi

if [[ "${INSTALL_CODEX}" -eq 1 ]]; then
  install_target "${HOME}/.agents/skills" "Codex"
fi

echo "Finished. Start a new Claude Code/Codex session to pick up the installed skill."
