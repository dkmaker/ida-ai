---
allowed-tools: Bash(git:*), Bash(ls:*), Bash(find:*)
argument-hint: [<context/instructions>]
description: Create a git commit with conventional commit message
model: claude-sonnet-4-5-20250929
---

# Git Commit with Conventional Commit Messages

## Context

**Current git status:**
!`git status`

**Current git diff (staged and unstaged changes):**
!`git diff HEAD`

**Current branch:**
!`git branch --show-current`

**Recent commits (for style reference):**
!`git log --oneline -10`

**Untracked files:**
!`git ls-files --others --exclude-standard`

**User provided context:** $ARGUMENTS

## Your Task

Create a git commit following these steps:

### Step 1: Sensitive File Detection

**CRITICAL:** Before adding any files, check for sensitive files that should NOT be committed:

**Never commit these file types:**
- `.env`, `.env.*` files (environment variables)
- `credentials.json`, `secrets.json`, `config.json` (configuration with secrets)
- `*.key`, `*.pem`, `*.p12`, `*.pfx` (private keys, certificates)
- `*.password`, `*_password.txt` (password files)
- `id_rsa`, `id_ed25519` (SSH private keys)
- `.aws/credentials`, `.gcp/credentials` (cloud credentials)
- `token`, `*_token`, `*.token` (API tokens)
- Database dumps with production data
- Any file with "secret", "credential", or "password" in the name

If you find any sensitive files in the untracked or modified files, **WARN THE USER** and do not commit them unless they explicitly confirm.

### Step 2: Add Files

Add relevant untracked and modified files to staging area:

```bash
# Add all relevant files, excluding sensitive ones
git add .
```

**If sensitive files were detected:**
- Skip them with `git reset -- <sensitive-file>`
- Warn the user about each skipped file
- Suggest adding them to `.gitignore` if not already there

### Step 3: Generate Conventional Commit Message

Create a commit message following the **Conventional Commits** specification:

**Format:**
```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

**Types (choose most appropriate):**
- `feat:` - A new feature
- `fix:` - A bug fix
- `docs:` - Documentation only changes
- `style:` - Changes that don't affect code meaning (formatting, whitespace)
- `refactor:` - Code change that neither fixes a bug nor adds a feature
- `perf:` - Performance improvement
- `test:` - Adding or correcting tests
- `build:` - Changes to build system or dependencies
- `ci:` - Changes to CI configuration
- `chore:` - Other changes that don't modify src or test files
- `revert:` - Reverts a previous commit

**Scope (optional):**
- Component, module, or area affected (e.g., `auth`, `api`, `ui`, `parser`)

**Description:**
- Concise summary in imperative mood ("add" not "added" or "adds")
- Start with lowercase
- No period at the end
- Max 72 characters

**Body (optional but recommended):**
- Explain the "why" not the "what"
- Wrap at 72 characters
- Separate from subject with blank line

**Footer (optional):**
- Breaking changes: `BREAKING CHANGE: description`
- Issue references: `Closes #123`, `Fixes #456`

### Step 4: Analyze Changes and Create Commit

Based on the git diff and status above:

1. **Identify the change type:**
   - What was the primary purpose? (new feature, bug fix, refactor, etc.)
   - Use the user's context from `$ARGUMENTS` to inform the commit type and message

2. **Draft the commit message:**
   - Choose appropriate type and scope
   - Write clear, concise description
   - Include body if changes are complex or need explanation
   - Reference issues if mentioned in user context

3. **Create the commit:**
   ```bash
   git commit -m "$(cat <<'EOF'
   <your conventional commit message here>
   EOF
   )"
   ```

4. **Verify the commit:**
   ```bash
   git log -1 --pretty=format:"%h - %s%n%n%b"
   git status
   ```

## Important Rules

1. **DO NOT commit if:**
   - Working directory is clean (no changes to commit)
   - Only sensitive files are staged
   - User explicitly asks to abort

2. **ALWAYS:**
   - Check for sensitive files first
   - Warn user about any sensitive files found
   - Generate meaningful commit messages based on actual changes
   - Follow conventional commit format strictly
   - Use imperative mood in commit subject
   - Keep subject line under 72 characters

3. **User Context Priority:**
   - If user provides context in `$ARGUMENTS`, incorporate it into the commit message
   - User might specify:
     - Issue numbers to reference
     - Specific scope to use
     - Breaking change information
     - Custom message parts

4. **DO NOT:**
   - Make empty commits (unless user explicitly requests with `--allow-empty`)
   - Commit files that are clearly sensitive
   - Use vague messages like "updates" or "changes"
   - Exceed 72 characters in subject line

## Examples

### Example 1: Feature Addition
```
feat(auth): add OAuth2 authentication support

Implement OAuth2 flow for third-party authentication.
Supports Google, GitHub, and Microsoft providers.

Closes #234
```

### Example 2: Bug Fix
```
fix(parser): handle null values in JSON parsing

Previously crashed when encountering null in nested objects.
Now gracefully handles nulls and logs warnings.

Fixes #456
```

### Example 3: Documentation
```
docs: update installation guide with Docker setup

Add step-by-step Docker installation instructions.
Include troubleshooting section for common issues.
```

### Example 4: Breaking Change
```
feat(api)!: change user endpoint response format

BREAKING CHANGE: User API now returns camelCase instead of snake_case.
Clients must update their parsers accordingly.

Migration guide: docs/migrations/v2.md
```

### Example 5: Refactoring
```
refactor(db): extract query builder into separate module

Improve code organization and testability.
No functional changes.
```

## Success Criteria

After running this command:
- ✅ Sensitive files are not committed (or user was warned and confirmed)
- ✅ Relevant untracked files are staged
- ✅ Commit message follows conventional commits format
- ✅ Commit message accurately describes the changes
- ✅ Commit message incorporates user-provided context if given
- ✅ Git status shows clean working tree or remaining unstaged changes
- ✅ Latest commit log is displayed for verification
