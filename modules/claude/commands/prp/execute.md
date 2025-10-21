---
description: Execute implementation based on Product Requirement Prompt (PRP)
category: prp
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Task
argument-hint: [PRP file path]
disable-model-invocation: true
---

# PRP Execution

## Product Requirement Prompt (PRP) File: $ARGUMENTS

## Mission: Successful implementation that meets the requirements described in the Product Requirement Prompt (PRP)

Your task is to implement a solution that meets the requirements described in the Product Requirement Prompt (PRP).

- **Context Completeness**: Obtain all necessary information before starting work - do not work based on speculation.
- **Phased Verification**: 4 levels of gates to catch errors early.
- **Pattern Consistency**: Follow existing codebase approaches.

**Your Goal**: To implement working code that meets the requirements described in the Product Requirement Prompt (PRP).

## Execution Process

1.  **Understand the Implementation Requirements (PRP)**

    - Read the specified PRP file completely.
    - Absorb all context, patterns, and requirements, and gather insights from the codebase.
    - Use the provided document references and file patterns to understand the exact project structure and requirements before creating any todos/tasks.
    - Trust the PRP's context and guidance - it is designed for one-pass success.
    - Conduct additional codebase exploration and research as needed.
    - If requirements are unclear, clarify them through investigation or by asking the user - admit what you don't know and clarify the requirements = Never work based on speculation.

2.  **ULTRATHINK & PLAN**

    - Create a comprehensive implementation plan following the task order in the PRP.
    - Follow the patterns referenced in the PRP.
    - Use the specific file paths, class names, and method signatures from the PRP context.

3.  **Execute Implementation**

    - Follow the implementation task sequence from the PRP, adding details as necessary, especially when using sub-agents.
    - Use the patterns and examples referenced in the PRP.
    - Create files in the locations specified in the desired codebase tree.
    - Apply naming conventions from the task specification and CLAUDE.md.

4.  **Phased Verification**

    **Execute the level-based verification system from the PRP:**

    - **Level 1**: Run syntax and style validation commands from the PRP.
    - **Level 2**: Run unit test validation from the PRP.
    - **Level 3**: Run integration test commands from the PRP.
    - **Level 4**: Run the specified validation from the PRP.

    **Each level must pass before proceeding to the next.**

5.  **Completion Verification**
    - Execute the final verification checklist from the PRP.
    - Confirm that all success criteria in the "What" section are met.
    - Ensure all anti-patterns have been avoided.
    - The implementation is ready and working.

**Failure Protocol**: If verification fails, use the patterns and notes in the PRP to fix the issue and re-run verification until it passes.

## Rules

**The following rules must be strictly followed:**

### 1. No Working on Speculation

- **Never work based on speculation.**

- Use only reliable sources of information:
  - ✅ Official documentation
  - ✅ Actual code
  - ✅ Execution logs and error messages
  - ✅ Test results
  - ❌ Guesses or imagination
  - ❌ Unverified hypotheses

Gather information by utilizing `context7`, `fetch`, or web searches.

### 2. Obligation to Resolve Ambiguities

- **If there is anything you don't understand, you must ask questions or investigate before starting implementation.**
- Situations where you should ask questions:
  - When specifications are unclear.
  - When the cause of an error cannot be identified.
  - When there are multiple implementation methods and you cannot determine which is appropriate.
  - When you cannot understand the intent of existing code.
  - When there is a contradiction between the documentation and the code.
- What you should investigate:
  - When the usage of a library is unknown.
  - When the actual output/input interfaces are unknown.

### 3. Pre-Implementation Confirmation

- Before writing code, confirm the following:
  - You have actually read and understood the relevant code.
  - You have investigated existing implementation patterns.
  - You have grasped the actual interface information for libraries, etc.
  - You have identified the scope of impact.
