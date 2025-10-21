---
description: Review generated PRPs and provide improvement suggestions
category: prp
allowed-tools: Read, Glob, Write
argument-hint: [PRP file path]
---

# Claude Command: PRP Review

This command systematically evaluates the quality of Product Requirement Prompts (PRPs) and provides constructive feedback and improvement suggestions.

## Usage

To review a PRP file:

```
/prp-review PRPs/my-feature.md
```

Or run without arguments to be prompted for the PRP file to review:

```
/prp-review
```

## What This Command Does

1. **Load PRP File**: Read and parse the specified PRP file
2. **Evaluate Structural Completeness**: Check template structure compliance and presence of required sections
3. **Evaluate Context Completeness**: Assess sufficiency of information needed for implementation and appropriateness of reference documentation
4. **Evaluate Information Density**: Check specificity, actionability, and detail level of references
5. **Evaluate Implementability**: Review task dependencies and clarity of pattern references
6. **Evaluate Quality Standards**: Check verification gates and comprehensiveness of checklists
7. **Scoring**: Evaluate each aspect on a scale of 1-10 and calculate an overall confidence score
8. **Generate Improvement Suggestions**: Provide specific, actionable improvement recommendations and suggest generating an improved PRP if necessary

## Review Focus Areas

### 1. Structural Completeness

- **Presence of Required Sections**: Does it include Goals, Why, What, Context, Implementation Blueprint, Verification Loop, and Final Validation Checklist?
- **Template Compliance**: Does it follow the structure of `PRPs/templates/prp_base.md`?
- **Section Order**: Is it organized in a logical order?
- **YAML Front Matter**: Are name and description properly defined?

### 2. Context Completeness

- **Context Completeness Check**: "Does someone unfamiliar with this codebase have everything needed to successfully implement this?"
- **Reference Documentation**: Are necessary files, URLs, and documents clearly specified in YAML format?
- **Reference Quality**: Does each reference include `why` (reason), `pattern` (pattern), and `critical`/`gotcha` (important notes)?
- **Known Gotchas**: Are codebase and library constraints and gotchas documented?
- **Codebase Trees**: Are both current and desired trees clearly specified?

### 3. Information Density

- **URL Specificity**: Do URLs include section anchors (#section-name)?
- **File Reference Specificity**: Do file references include specific patterns to follow?
- **Task Specification Detail**: Are naming conventions, placement, and dependencies clear?
- **Verification Command Actionability**: Are commands project-specific and actually executable?
- **Concrete Examples**: Are code snippets and configuration examples included?

### 4. Implementability

- **Task Dependency Order**: Are implementation tasks ordered according to dependencies?
- **Pattern Reference Clarity**: Are patterns and existing files to follow clearly indicated?
- **Implementation Method Specificity**: Is how to implement described concretely?
- **Edge Case Consideration**: Are anticipated edge cases and exceptions considered?
- **One-Pass Success Probability**: Is there a high probability of successful implementation on the first try with just the PRP?

### 5. Quality Standards

- **Goal Clarity**: Are feature goals, deliverables, and success definitions specific and measurable?
- **Verification Gate Progression**: Are Level 1-4 verifications progressively defined?
- **Verification Comprehensiveness**: Are syntax, unit tests, integration tests, and domain-specific tests covered?
- **Final Checklist Completeness**: Are technical, functional, code quality, and documentation validation items included?
- **Anti-pattern Definition**: Are anti-patterns to avoid clearly defined?

## Review Guidelines

### Evaluation Approach

- **Constructively**: Focus on improving PRP quality rather than criticizing the PRP author
- **Specifically**: Point out exact section names or line numbers and clearly explain concerns
- **Suggest Solutions**: Provide specific improvement suggestions or information to add, not just identify problems
- **Ask Questions**: Request clarification when there are unclear or ambiguous expressions
- **Acknowledge Strengths**: Highlight well-written sections and excellent design decisions
- **Distinguish Priority**: Clearly separate must-fix issues (implementation will fail) from improvement suggestions (quality enhancement)

### Scoring Criteria

Evaluate each aspect on a scale of 1-10 and calculate an overall confidence score:

- **9-10: Excellent**
  - Ready to implement immediately
  - All necessary information is included
  - Very high probability of one-pass success

- **7-8: Good**
  - Ready to implement with minor improvements
  - Most information is included but some supplementation needed
  - High probability of one-pass success

- **5-6: Fair**
  - Several improvements needed
  - Some important information is missing
  - Implementer may need additional research

- **3-4: Needs Improvement**
  - Significant issues exist
  - Much required information is missing
  - High risk of implementation failure

- **1-2: Insufficient**
  - Major revisions needed
  - Basic structure or information is lacking
  - Cannot be implemented as-is

### Feedback Structure

Provide review feedback in the following structure:

1. **Executive Summary**
   - Overall confidence score (1-10)
   - Key strengths and concerns
   - Recommended next actions

2. **Aspect-by-Aspect Evaluation**
   - Score for each aspect (1-10)
   - Strengths
   - Areas needing improvement
   - Specific improvement suggestions

3. **Prioritized Improvement List**
   - Must Fix (issues that will cause implementation failure)
   - Recommended Improvements (suggestions for quality enhancement)
   - Optional Improvements (further quality enhancement)

4. **Next Steps**
   - Is generating an improved PRP necessary?
   - Areas requiring additional research
   - Readiness to begin implementation

## Additional Guidance

$ARGUMENTS
