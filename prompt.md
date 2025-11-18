# Session Prompts

This file contains the prompts used during the development session for setting up the IDA project with documentation research capabilities.

---

## Prompt 1: Download Documentation Files

**Objective:** Download and organize documentation files

**Prompt:**
```
Download all the doc files in @docs.md with curl and store them
in the defined folder
```

**Context:** Initial setup phase to gather necessary documentation files for the project.

---

## Prompt 2: Create Perplexity CLI Frontend

**Objective:** Create a bash-based CLI tool for Perplexity API

**Prompt:**
```
You have the API key available as an env variable for Perplexity.
Make a bash command that can take parameters and ask the API.
I need it as a "frontend" - just make it in bash.

Requirements:
- Make sure that the response is AI optimized
- The parameters should be simple and intuitive
- Create a perplexity.sh command
- Use curl to do the requests
```

**Output:** `perplexity.sh` - A general-purpose Perplexity API frontend

---

## Prompt 3: Create Documentation Research Skill

**Objective:** Build a Claude Code skill for researching and persisting coding documentation

**Prompt:**
```
Perfect - I want to make a research skill for Claude Code @docs/skills.md
that can handle research.

I want to move the bash script and modify it so it helps the skill doing
research. Make a skill to research coding documentation.

Requirements:

1. Search Strategy:
   - It should search via Perplexity first
   - Adapt the CLI to this so it's optimized for documentation research
   - The system prompt should contain specifics for research documentation

2. Persistence:
   - When you find documentation, always persist the documentation into
     a folder called research/<topic>.md
   - Update the CLAUDE.md file with a brief about what the file is and
     when to apply

3. Research Index:
   - The skill should always initially read CLAUDE.md to see if we have
     researched this topic before

4. Task Management:
   - Make sure to use a pattern so the research uses todo tracking

5. Output Format:
   - Make sure to make a detailed output format so the documentation is
     always AI optimized and follows same patterns
   - It should be focused on documentation in general development
```

**Output:** `.claude/skills/research-docs/` - Complete research skill with scripts

---

## Prompt 4: CLAUDE.md Index File Format

**Objective:** Define the structure and format for the CLAUDE.md index file

**Prompt:**
```
The CLAUDE.md file is intended as an INDEX so it should be that.

Make sure that the format is defined in the skill. It should be MARKDOWN,
AI optimized.

Read @docs/memory.md to understand how it should be created and maintained.
```

**Context:** Ensuring the CLAUDE.md file serves as a proper index for all research topics with consistent formatting.

---

## Project Architecture

### Files Created
- `perplexity.sh` - General-purpose Perplexity API CLI
- `.claude/skills/research-docs/` - Research skill directory
  - `SKILL.md` - Skill definition and instructions
  - `TEMPLATE.md` - Documentation template
  - `scripts/perplexity-research.sh` - Documentation-optimized research script
- `CLAUDE.md` - Project memory and research index
- `research/` - Directory for all research documentation

### Key Concepts
- **AI-Optimized Output**: Structured, scannable markdown with clear sections
- **Research Persistence**: All findings saved and indexed for future reference
- **Documentation Focus**: Specialized for coding documentation and best practices
- **Memory System**: CLAUDE.md serves as the central index for all research

---

**Session Date:** 2025-11-18
**Project:** IDA - Integrated Documentation Assistant
