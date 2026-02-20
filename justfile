set shell := ["bash", "-eu", "-o", "pipefail", "-c"]
set working-directory := "vmctl"

# Adjust if your base branch is main
BASE := "main"

default:
    just --list

############################################
# Branch helpers
############################################

# Show current branch
branch:
    (cd .. && git rev-parse --abbrev-ref HEAD)

# List local branches
branches:
    (cd .. && git branch --sort=-committerdate)

# Switch to base branch and sync with origin
base:
    (cd .. && git switch {{BASE}} && git pull --ff-only)

# Common long-lived branches
main:
    (cd .. && git switch main)

dev:
    (cd .. && git switch dev)

stable:
    (cd .. && git switch stable)

# Switch back to previous branch
back:
    (cd .. && git switch -)

# Switch to a branch by name
# Usage: just switch feat/123-thing
switch name:
    (cd .. && git switch "{{name}}")

############################################
# Branch creation
############################################

# Create a correctly named branch off BASE
# Usage: just feat 123 "page allocator"
feat issue desc:
    (cd .. && git switch {{BASE}} && git pull --ff-only)
    slug=$(echo "{{desc}}" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g'); \
    branch="feat/{{issue}}-$slug"; \
    echo "Creating branch: $branch"; \
    (cd .. && git switch -c "$branch" && git push -u origin "$branch")

############################################
# Rust workflow (runs inside vmctl/)
############################################

# One command to keep you honest
check:
    cargo fmt --all
    cargo clippy --all-targets -- -D warnings
    cargo test

############################################
# Guards + git helpers
############################################

# Guard: enforce branch naming (feat/* only, minimal)
guard:
    b=$(cd .. && git rev-parse --abbrev-ref HEAD); \
    [[ "$b" =~ ^feat/[0-9]+-[a-z0-9-]+$ ]] || (echo "Bad branch: $b (expected feat/<issue>-<slug>)" && exit 1)

# The “only way you commit”
# Usage: just commit "feat(vm): add start"
commit msg: guard check
    (cd .. && git add -A && git commit -m "{{msg}}")

push:
    (cd .. && git push)

# Pull current branch (fast-forward only)
pull:
    (cd .. && git pull --ff-only)

# Quick status
status:
    (cd .. && git status -sb)


############################################
# More branch creators (quick types)
############################################

# Usage: just fix 42 "handle nil config"
fix issue desc:
	(cd .. && git switch {{BASE}} && git pull --ff-only)
	slug=$(echo "{{desc}}" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g'); \
	branch="fix/{{issue}}-$slug"; \
	echo "Creating branch: $branch"; \
	(cd .. && git switch -c "$branch" && git push -u origin "$branch")

# Usage: just docs 12 "update readme"
docs issue desc:
	(cd .. && git switch {{BASE}} && git pull --ff-only)
	slug=$(echo "{{desc}}" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g'); \
	branch="docs/{{issue}}-$slug"; \
	echo "Creating branch: $branch"; \
	(cd .. && git switch -c "$branch" && git push -u origin "$branch")

# Usage: just refactor 88 "simplify parser"
refactor issue desc:
	(cd .. && git switch {{BASE}} && git pull --ff-only)
	slug=$(echo "{{desc}}" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g'); \
	branch="refactor/{{issue}}-$slug"; \
	echo "Creating branch: $branch"; \
	(cd .. && git switch -c "$branch" && git push -u origin "$branch")

# Usage: just chore 5 "bump deps"
chore issue desc:
	(cd .. && git switch {{BASE}} && git pull --ff-only)
	slug=$(echo "{{desc}}" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g'); \
	branch="chore/{{issue}}-$slug"; \
	echo "Creating branch: $branch"; \
	(cd .. && git switch -c "$branch" && git push -u origin "$branch")

# Usage: just test 9 "add cli tests"
test-branch issue desc:
	(cd .. && git switch {{BASE}} && git pull --ff-only)
	slug=$(echo "{{desc}}" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g'); \
	branch="test/{{issue}}-$slug"; \
	echo "Creating branch: $branch"; \
	(cd .. && git switch -c "$branch" && git push -u origin "$branch")

# Usage: just ci 21 "add workflow"
ci issue desc:
	(cd .. && git switch {{BASE}} && git pull --ff-only)
	slug=$(echo "{{desc}}" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g'); \
	branch="ci/{{issue}}-$slug"; \
	echo "Creating branch: $branch"; \
	(cd .. && git switch -c "$branch" && git push -u origin "$branch")

# Usage: just perf 13 "speed up scan"
perf issue desc:
	(cd .. && git switch {{BASE}} && git pull --ff-only)
	slug=$(echo "{{desc}}" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g'); \
	branch="perf/{{issue}}-$slug"; \
	echo "Creating branch: $branch"; \
	(cd .. && git switch -c "$branch" && git push -u origin "$branch")

# Usage: just build 3 "use musl"
build issue desc:
	(cd .. && git switch {{BASE}} && git pull --ff-only)
	slug=$(echo "{{desc}}" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g'); \
	branch="build/{{issue}}-$slug"; \
	echo "Creating branch: $branch"; \
	(cd .. && git switch -c "$branch" && git push -u origin "$branch")
