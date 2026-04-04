#!/usr/bin/env bash
# Install is-paper-review as a Claude Code and/or Codex skill.
# Local usage examples:
#   ./install.sh
#   ./install.sh --codex
#   ./install.sh --claude
# Remote usage examples (no clone required):
#   curl -fsSL https://raw.githubusercontent.com/c0mm4nd/is-review-skill/main/install.sh | bash -s -- --codex
#   curl -fsSL -H "Authorization: Bearer ${GITHUB_TOKEN}" -H "Accept: application/vnd.github.raw" \
#     "https://api.github.com/repos/c0mm4nd/is-review-skill/contents/install.sh?ref=main" | \
#     bash -s -- --codex --github-api

set -euo pipefail

DEFAULT_REPO="c0mm4nd/is-review-skill"
DEFAULT_REF="main"

GITHUB_REPO="${GITHUB_REPO:-${DEFAULT_REPO}}"
GITHUB_REF="${GITHUB_REF:-${DEFAULT_REF}}"
REMOTE_BASE="${REMOTE_BASE:-}"
FETCH_MODE="${FETCH_MODE:-auto}"
SOURCE_MODE="auto"

SOURCE_HINT="${BASH_SOURCE[0]:-${0:-}}"
SCRIPT_DIR=""
if [[ -n "${SOURCE_HINT}" && "${SOURCE_HINT}" != "bash" && "${SOURCE_HINT}" != "-bash" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${SOURCE_HINT}")" && pwd)"
fi

LOCAL_SOURCE_DIR=""
if [[ -n "${SCRIPT_DIR}" ]]; then
  LOCAL_SOURCE_DIR="${SCRIPT_DIR}/is-paper-review"
fi

INSTALL_CLAUDE=0
INSTALL_CODEX=0
SKILL_FILES=(
  "SKILL.md"
  "references/review-framework.md"
  "references/methodology-guides.md"
  "references/review-template.md"
)

usage() {
  cat <<'EOF'
Install is-paper-review as an agent skill.

Usage:
  ./install.sh [--claude] [--codex] [--all] [--repo OWNER/REPO] [--ref REF]
  ./install.sh [--claude] [--codex] [--all] [--remote-base URL]

Options:
  --claude             Install to ~/.claude/skills/is-paper-review
  --codex              Install to ~/.agents/skills/is-paper-review
  --all                Install to both locations (default when no option is given)
  --repo OWNER/REPO    GitHub repository to fetch from when installing remotely
  --ref REF            Git ref to fetch from when installing remotely
  --remote-base URL    Override the raw file base URL used for remote installs
  --raw                Force raw URL fetching for remote installs
  --github-api         Force GitHub Contents API fetching for remote installs
  --force-local        Require a local checkout beside install.sh
  --force-remote       Ignore local files and fetch remotely
  -h, --help           Show this help text

Examples:
  ./install.sh --codex
  curl -fsSL https://raw.githubusercontent.com/c0mm4nd/is-review-skill/main/install.sh | bash -s -- --codex
  curl -fsSL -H "Authorization: Bearer ${GITHUB_TOKEN}" -H "Accept: application/vnd.github.raw" \
    "https://api.github.com/repos/c0mm4nd/is-review-skill/contents/install.sh?ref=main" | \
    bash -s -- --codex --github-api
EOF
}

require_value() {
  local option_name="$1"
  local option_value="${2:-}"

  if [[ -z "${option_value}" ]]; then
    echo "Missing value for ${option_name}" >&2
    usage >&2
    exit 1
  fi
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
    --repo)
      require_value "$1" "${2:-}"
      GITHUB_REPO="$2"
      shift
      ;;
    --repo=*)
      GITHUB_REPO="${1#*=}"
      ;;
    --ref)
      require_value "$1" "${2:-}"
      GITHUB_REF="$2"
      shift
      ;;
    --ref=*)
      GITHUB_REF="${1#*=}"
      ;;
    --remote-base)
      require_value "$1" "${2:-}"
      REMOTE_BASE="$2"
      shift
      ;;
    --remote-base=*)
      REMOTE_BASE="${1#*=}"
      ;;
    --raw)
      FETCH_MODE="raw"
      ;;
    --github-api)
      FETCH_MODE="github-api"
      ;;
    --force-local)
      SOURCE_MODE="local"
      ;;
    --force-remote)
      SOURCE_MODE="remote"
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

if [[ "${FETCH_MODE}" == "auto" ]]; then
  if [[ -n "${REMOTE_BASE}" ]]; then
    FETCH_MODE="raw"
  elif [[ -n "${GITHUB_TOKEN:-}" || -n "${GH_TOKEN:-}" ]]; then
    FETCH_MODE="github-api"
  else
    FETCH_MODE="raw"
  fi
fi

if [[ -z "${REMOTE_BASE}" ]]; then
  REMOTE_BASE="https://raw.githubusercontent.com/${GITHUB_REPO}/${GITHUB_REF}"
fi
REMOTE_BASE="${REMOTE_BASE%/}"

CURL_HEADERS=()
if [[ -n "${GITHUB_TOKEN:-}" ]]; then
  CURL_HEADERS+=(-H "Authorization: Bearer ${GITHUB_TOKEN}")
elif [[ -n "${GH_TOKEN:-}" ]]; then
  CURL_HEADERS+=(-H "Authorization: Bearer ${GH_TOKEN}")
fi

run_curl() {
  if [[ ${#CURL_HEADERS[@]} -gt 0 ]]; then
    curl "${CURL_HEADERS[@]}" "$@"
  else
    curl "$@"
  fi
}

copy_from_local() {
  local destination="$1"
  local relative_path=""

  if [[ -z "${LOCAL_SOURCE_DIR}" || ! -f "${LOCAL_SOURCE_DIR}/SKILL.md" ]]; then
    echo "Local install requested, but no local skill source was found beside install.sh." >&2
    exit 1
  fi

  for relative_path in "${SKILL_FILES[@]}"; do
    mkdir -p "${destination}/$(dirname "${relative_path}")"
    cp "${LOCAL_SOURCE_DIR}/${relative_path}" "${destination}/${relative_path}"
  done
}

fetch_remote_raw() {
  local remote_path="$1"
  local output_path="$2"
  local remote_url="${REMOTE_BASE}/${remote_path}"

  command -v curl >/dev/null 2>&1 || {
    echo "curl is required when installing remotely." >&2
    exit 1
  }

  if ! run_curl -fsSL "${remote_url}" -o "${output_path}"; then
    echo "Remote install failed while fetching ${remote_path} from ${remote_url}." >&2
    echo "Check --repo/--ref/--remote-base and repository visibility." >&2
    exit 1
  fi
}

fetch_remote_github_api() {
  local remote_path="$1"
  local output_path="$2"
  local api_url="https://api.github.com/repos/${GITHUB_REPO}/contents/${remote_path}?ref=${GITHUB_REF}"

  command -v curl >/dev/null 2>&1 || {
    echo "curl is required when installing remotely." >&2
    exit 1
  }

  if ! run_curl -H "Accept: application/vnd.github.raw" -fsSL "${api_url}" -o "${output_path}"; then
    echo "Remote install failed while fetching ${remote_path} from ${api_url}." >&2
    echo "Check --repo/--ref and confirm GITHUB_TOKEN or GH_TOKEN can read the repository." >&2
    exit 1
  fi
}

copy_from_remote() {
  local destination="$1"
  local relative_path=""

  if [[ "${FETCH_MODE}" == "github-api" && ${#CURL_HEADERS[@]} -eq 0 ]]; then
    echo "GitHub API mode requires GITHUB_TOKEN or GH_TOKEN." >&2
    exit 1
  fi

  for relative_path in "${SKILL_FILES[@]}"; do
    mkdir -p "${destination}/$(dirname "${relative_path}")"
    if [[ "${FETCH_MODE}" == "github-api" ]]; then
      fetch_remote_github_api "is-paper-review/${relative_path}" "${destination}/${relative_path}"
    else
      fetch_remote_raw "is-paper-review/${relative_path}" "${destination}/${relative_path}"
    fi
  done
}

install_target() {
  local base_dir="$1"
  local label="$2"
  local destination="${base_dir}/is-paper-review"

  echo "Installing ${label} skill to ${destination}"

  case "${SOURCE_MODE}" in
    local)
      copy_from_local "${destination}"
      ;;
    remote)
      copy_from_remote "${destination}"
      ;;
    auto)
      if [[ -n "${LOCAL_SOURCE_DIR}" && -f "${LOCAL_SOURCE_DIR}/SKILL.md" ]]; then
        copy_from_local "${destination}"
      else
        copy_from_remote "${destination}"
      fi
      ;;
    *)
      echo "Unsupported source mode: ${SOURCE_MODE}" >&2
      exit 1
      ;;
  esac

  echo "Installed ${label} skill to ${destination}"
}

if [[ "${INSTALL_CLAUDE}" -eq 1 ]]; then
  install_target "${HOME}/.claude/skills" "Claude Code"
fi

if [[ "${INSTALL_CODEX}" -eq 1 ]]; then
  install_target "${HOME}/.agents/skills" "Codex"
fi

echo "Finished. Start a new Claude Code/Codex session to pick up the installed skill."
