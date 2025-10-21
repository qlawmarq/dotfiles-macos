# Product Requirement Prompt (PRP) Framework

## What is a PRP?

**Product Requirement Prompt (PRP)** is a structured prompt that supplies an AI coding agent with everything needed to deliver working software.

A traditional PRD clarifies what the product must do and why customers need it, but deliberately avoids how it will be built.

A PRP keeps the goal and justification sections of a PRD yet adds three AI-critical layers:

### 1. Context

- Precise file paths and content
- Library versions and context
- Code snippet examples
- Library documentation via `ai_docs/` directory

### 2. Implementation Details

- How to use API endpoints, test runners, agent patterns
- Type hints, dependencies, architectural patterns

### 3. Validation Gates

- Deterministic checks like pytest, ruff, static type checks
- Shift-left quality controls catch defects early

## Directory Structure

```
PRPs/
├── templates/          # PRP templates
│   ├── prp_base.md    # Comprehensive implementation template
│   └── prp_task.md    # Task-specific template
├── ai_docs/           # Project-specific documentation
├── completed/         # Completed PRPs
└── *.md               # Active PRPs
```

## Usage

### 1. Create a PRP

Use Claude Code command:

```
/prp-create [feature description]
```

Or manually from template:

```bash
cp PRPs/templates/prp_base.md PRPs/my-feature.md
# Edit PRPs/my-feature.md
```

### 2. Execute a PRP

```
/prp-execute PRPs/my-feature.md
```

## PRP Best Practices

1. **Context is King**: Include ALL necessary documentation, examples, and caveats
2. **Validation Loops**: Provide executable tests/lints the AI can run and fix
3. **Information Dense**: Use keywords and patterns from the codebase
4. **Progressive Success**: Start simple, validate, then enhance

## Using ai_docs/ Directory

For complex libraries or integration patterns, create condensed documentation in `ai_docs/`:

```bash
# Example: FastAPI integration patterns
cat > PRPs/ai_docs/fastapi_patterns.md << 'EOF'
# FastAPI Integration Patterns

## Async Endpoints
[Code examples and best practices]

## Dependency Injection
[Code examples and best practices]
EOF
```

## Reference Links

### Claude Code Official Documentation

- [Claude Code Overview](https://docs.claude.com/en/docs/claude-code/overview)
- [Custom Slash Commands](https://docs.claude.com/en/docs/claude-code/slash-commands)
- [Sub-agents](https://docs.claude.com/en/docs/claude-code/sub-agents)
- [Hooks](https://docs.claude.com/en/docs/claude-code/hooks-guide)

## Summary

**PRP = PRD + curated codebase intelligence + agent/runbook**

A PRP is the minimum viable packet an AI needs to plausibly ship production-ready code on the first pass.
