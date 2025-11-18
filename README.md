# IDA - Claude Code Skills Example Repository

This is a test repository that demonstrates how to create and use **Skills** in Claude Code, specifically showcasing a documentation research skill powered by Perplexity AI.

## What Are Skills in Claude Code?

Skills are reusable, autonomous capabilities that extend Claude Code's functionality. They allow you to:

- Create specialized workflows that activate automatically based on user requests
- Package scripts, prompts, and logic into shareable components
- Build context-aware tools that maintain state across sessions
- Integrate external APIs and services into your development workflow

## What This Repository Demonstrates

This repository showcases a complete **Documentation Research Skill** that:

1. ✅ Automatically searches for coding documentation using Perplexity AI
2. ✅ Persists findings in a structured, AI-optimized markdown format
3. ✅ Maintains an index to avoid duplicate research
4. ✅ Follows consistent patterns for documentation storage
5. ✅ Integrates seamlessly with Claude Code's task management

## Project Structure

```
ida/
├── README.md                          # This file
├── CLAUDE.md                          # Project memory and research index
├── prompt.md                          # Session prompts used to build this
│
├── .claude/
│   └── skills/
│       └── research-docs/             # The research skill
│           ├── SKILL.md              # Skill definition and instructions
│           ├── TEMPLATE.md           # Documentation template
│           └── scripts/
│               └── perplexity-research.sh  # Documentation-optimized API wrapper
│
├── research/                          # Research output directory
│   ├── CLAUDE.md                     # Research index with best practices
│   └── espressif-ide-windows.md      # Example: ESP32 IDE installation guide
│
├── docs/                              # Claude Code documentation
│   ├── hooks-guide.md
│   ├── hooks.md
│   ├── memory.md
│   ├── skills.md
│   ├── slash-commands.md
│   ├── sub-agents.md
│   └── perplexity/
│       ├── search-post.md
│       ├── models.md
│       └── search-quickstart.md
│
└── perplexity.sh                      # General-purpose Perplexity CLI
```

## The Research Skill Workflow

### How It Works

1. **User asks a documentation question**
   ```
   "Research how to install Espressif IDE on Windows"
   ```

2. **Skill activates automatically**
   - Checks `CLAUDE.md` to see if topic was researched before
   - If new, executes Perplexity search with documentation-focused parameters
   - Structures findings using AI-optimized template
   - Saves to `research/<topic>.md`
   - Updates index in `CLAUDE.md`

3. **Persisted for future use**
   - Next time similar question is asked, Claude reads existing research
   - Avoids duplicate API calls
   - Maintains consistent knowledge base

### Example Usage

```bash
# The skill activates when user asks research-related questions:
"Research Python asyncio best practices"
"Look up React hooks documentation"
"Find TypeScript generics documentation"
"What are the Docker security best practices?"
```

## Key Components

### 1. Skill Definition (`.claude/skills/research-docs/SKILL.md`)

The skill manifest that defines:
- When to activate (triggers)
- Core workflow principles
- Step-by-step instructions
- Quality standards
- Troubleshooting guides

### 2. Research Script (`scripts/perplexity-research.sh`)

A bash wrapper for Perplexity Search API that:
- Uses documentation-focused system prompt
- Filters for authoritative domains (Stack Overflow, GitHub, official docs)
- Returns structured, AI-optimized output
- Supports flexible parameters (recency, domain filtering, result count)

**Example:**
```bash
.claude/skills/research-docs/scripts/perplexity-research.sh \
  -d "docs.python.org,realpython.com" \
  -r month \
  "python asyncio patterns"
```

### 3. Memory System (`CLAUDE.md`)

Central index that tracks:
- All researched topics
- Research dates and status
- When to use each research
- Key points summary
- Quick reference for Claude

### 4. Documentation Template (`TEMPLATE.md`)

Ensures all research follows consistent structure:
- Overview and key concepts
- Best practices (do's and don'ts)
- Common patterns with code examples
- Pitfalls and solutions
- Version information
- Related resources

## Setup Requirements

### Prerequisites

1. **Perplexity API Key**
   ```bash
   export PERPLEXITY_API_KEY="your-api-key-here"
   ```

2. **Claude Code**
   - Install from: https://github.com/anthropics/claude-code

### Installation

1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd ida
   ```

2. Ensure Perplexity API key is set:
   ```bash
   echo $PERPLEXITY_API_KEY
   ```

3. Make scripts executable:
   ```bash
   chmod +x perplexity.sh
   chmod +x .claude/skills/research-docs/scripts/perplexity-research.sh
   ```

4. Start Claude Code in this directory:
   ```bash
   claude-code
   ```

## Usage Examples

### Using the Research Skill

The skill activates automatically when you ask research questions:

```
User: "Research how to install Espressif IDE on Windows"

Claude: [Skill activates]
1. Checks CLAUDE.md - no existing research found
2. Executes Perplexity search
3. Structures findings into research/espressif-ide-windows.md
4. Updates CLAUDE.md index
5. Presents summary to user
```

### Using the CLI Tools

**General Perplexity Search:**
```bash
./perplexity.sh "What are the best practices for React hooks?"
```

**Documentation-Focused Search:**
```bash
.claude/skills/research-docs/scripts/perplexity-research.sh \
  -d "reactjs.org,github.com" \
  -r year \
  "React hooks patterns"
```

## Example Output

See `research/espressif-ide-windows.md` for a complete example of:
- Comprehensive installation guide
- Platform-specific notes
- Common pitfalls and solutions
- Best practices
- Troubleshooting steps
- Related resources

## Benefits of This Approach

### For Development
- ✅ **No Duplicate Work**: Check if topic researched before searching
- ✅ **Consistent Format**: All documentation follows same structure
- ✅ **AI-Optimized**: Structured for easy LLM parsing and retrieval
- ✅ **Version Control**: All research tracked in git

### For Teams
- ✅ **Shared Knowledge**: Research persisted and accessible to all
- ✅ **Quality Standards**: Template ensures comprehensive coverage
- ✅ **Maintenance**: Track research dates for updates
- ✅ **Discoverability**: Index makes finding research easy

### For AI Assistants
- ✅ **Context Awareness**: Claude knows what's been researched
- ✅ **Structured Data**: Easy to parse and reference
- ✅ **Relationship Tracking**: Related topics linked
- ✅ **Status Indicators**: Active/deprecated/updated flags

## Customization

### Modify Search Domains

Edit `scripts/perplexity-research.sh` to change default domains:
```bash
DEFAULT_DOMAINS="stackoverflow.com,github.com,docs.python.org,..."
```

### Adjust Documentation Template

Edit `TEMPLATE.md` to customize research output structure.

### Change Storage Location

Modify skill instructions to use different paths for research files.

## Session History

See `prompt.md` for the complete session prompts used to build this repository.

## Resources

### Claude Code Documentation
- [Skills Guide](docs/skills.md)
- [Memory System](docs/memory.md)
- [Hooks](docs/hooks.md)
- [Slash Commands](docs/slash-commands.md)

### Perplexity API
- [Search API Documentation](docs/perplexity/search-post.md)
- [Models](docs/perplexity/models.md)
- [Quick Start](docs/perplexity/search-quickstart.md)

### Official Links
- [Claude Code GitHub](https://github.com/anthropics/claude-code)
- [Perplexity API](https://docs.perplexity.ai/)

## License

This is a test/example repository for educational purposes.

---

**Created:** 2025-11-18
**Purpose:** Demonstrate Claude Code Skills with practical documentation research example
**Maintainer:** Test Repository
