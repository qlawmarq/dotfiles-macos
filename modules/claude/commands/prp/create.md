---
description: Create implementable Product Requirement Prompts (PRPs) based on user requirements
category: prp
allowed-tools: Read, Write, Glob, Grep, Bash, WebFetch, Task
argument-hint: [feature description or requirements]
disable-model-invocation: true
---

# PRP Creation

## Requirements: $ARGUMENTS

## PRP Creation

Your task is to create an implementable-level document, a Product Requirement Prompt (PRP), based on the user's requirements.

After clearly understanding the requirements, you will grasp the existing implementation, consider a concrete implementation plan using web searches and MCP, and create a specification document (PRP) that is detailed enough to begin implementation.

The next worker will perform the actual implementation based on the PRP you create. **In other words, the quality of the PRP will dictate the content of the actual implementation.** Please create a comprehensive PRP that includes all researched content and contextual information.

## Research Process

> Through the research process, gather information to make the requirements concrete and clear, reaching a level where actual implementation can begin without hesitation. Please investigate all necessary information exhaustively.

0.  **Clarification of Requirements**

    - If requirements are ambiguous, clarify them as needed.
    - Working based on speculation is strictly prohibited.
    - If necessary, proactively ask questions and make suggestions to the user to deeply understand what they are looking for.

1.  **In-depth Codebase Analysis**

    - Understand the project structure.
    - Identify all files that need to be referenced in the PRP.
    - Document all existing conventions that must be followed.
    - Check existing test patterns and verification methods for the validation approach.
    - If necessary, generate a sub-agent to search for similar features/patterns in the codebase.

1.  **Extensive External Research**

    - List external libraries that can be used to achieve the requirements.
    - Investigate library documentation.
    - For important parts of the documentation, add a .md file to `PRPs/ai_docs` and reference it in the PRP. Describe the clear reason and instructions.
    - Implementation examples (GitHub/StackOverflow/blogs).
    - Best practices and common pitfalls found during research.
    - If necessary, generate a sub-agent to search for similar features/patterns online and include URLs to documentation and examples.

## PRP Generation Process

### Step 0: Research

First, follow the "Research Process" to investigate the information necessary to meet the requirements.

### Step 1: Verify Contextual Completeness

Before writing the PRP, **you must pass the following question**:
_"Does someone who knows nothing about this codebase have everything they need to implement this successfully?"_

If the research is insufficient, continue researching.

### Step 2: Check the Template

Use `PRPs/templates/prp_base.md` as the template structure - it includes all necessary sections and formatting.

### Step 3: Convert Research Findings into a PRP

Convert research findings into the template sections:

**Goal Section**: Use the research to define specific, measurable feature goals and concrete deliverables.
**Context Section**: Fill the template's YAML structure with research findings - specific URLs, file patterns, points of caution.
**Implementation Tasks**: Create tasks in dependency order, using information-dense keywords from the codebase analysis.
**Validation Gate**: Confirm project-specific validation commands that are verified to work in this codebase.

### Step 4: Information Density Standard

Ensure all references are **specific and actionable**:

- URLs should include section anchors, not just domain names.
- File references should include specific patterns to follow.
- Task specifications should include precise naming conventions and placement.
- Validation commands must be project-specific and executable.

### Step 5: ULTRATHINK

After completing research, use the Todo tool to create a comprehensive PRP creation plan:

- Plan how to structure each template section with the research findings.
- Identify gaps that require additional research.
- Create a systematic approach to fill the template with actionable context.

## Output

Save to: `PRPs/todo/{feature-name}.md`

## PRP Quality Check

### Contextual Completeness Check

- [ ] Someone who knows nothing about this codebase has everything they need to implement this successfully.
- [ ] All YAML references are specific and accessible.
- [ ] Validation commands are project-specific and verified to work.

### Template Structure Compliance

- [ ] The Goal section has specific feature goals, deliverables, and a definition of success.
- [ ] Implementation tasks follow dependency order.
- [ ] The final validation checklist is comprehensive.

### Information Density Standard

- [ ] Everything is specific and actionable.
- [ ] URLs include section anchors for precise guidance.
- [ ] Task specifications use information-dense keywords from the codebase.

## Work Rules

**The following rules must be strictly adhered to:**

### 1. Prohibition of Working Based on Speculation

- **Never work based on speculation.**
- Use only reliable sources of information:
  - ✅ Official documentation
  - ✅ Actual code
  - ✅ Execution logs and error messages
  - ✅ Test results
  - ❌ Guesses or imagination
  - ❌ Unverified hypotheses

Gather information by utilizing `context7`, `fetch`, or web searches.

### 2. Obligation to Investigate Unknowns

- **If there is anything you do not understand, you must ask questions or investigate before starting implementation.**
- Situations where you should ask questions:
  - When specifications are unclear.
  - When the cause of an error cannot be identified.
  - When there are multiple implementation methods and you cannot determine which is appropriate.
  - When the intent of existing code cannot be understood.
  - When there is a contradiction between instructions/documentation and the requirements.
- What you should investigate:
  - When the usage of a library is unclear.
  - When the actual output/input interfaces are unclear.

## Success Metrics

**Confidence Score**: Rate the likelihood of successful implementation on a scale of 1-10.

**Validation**: The completed PRP must enable an AI agent unfamiliar with the codebase to successfully implement the feature using only the PRP's content and codebase access.
