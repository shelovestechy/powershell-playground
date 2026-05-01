# 🛠️ PowerShell Playground

**A personal learning playground, practical lab, and growing PowerShell handbook.**

This repository documents my journey of learning PowerShell from the ground up and turning that knowledge into practical IT automation skills.

The goal is not to collect random scripts or copy-paste commands. The goal is to understand what happens under the hood: how PowerShell handles objects, how data moves through the pipeline, how scripts make decisions, and how automation can support real IT, Microsoft 365, and identity-related work.

This repository includes notes, experiments, small scripts, reusable patterns, troubleshooting examples, and practical exercises based on topics I encounter while building my technical skill set.

---

## 🎯 Current Focus

I am currently building a stronger foundation in PowerShell with a focus on:

- Understanding the PowerShell pipeline and object-based output
- Working with variables, arrays, hashtables, and custom objects
- Filtering, sorting, and transforming data
- Reading and writing CSV and JSON files
- Writing clearer, safer, and more reusable scripts
- Connecting PowerShell learning toward Microsoft 365, Entra ID, and IAM-related automation

This is an active learning repository, so the content will grow over time as my skills develop.

---

## 🧭 Roadmap: Zero to IAM Hero

This roadmap is divided into phases that move from PowerShell fundamentals toward identity, security, and automation.

### Phase 1: The Foundation — Core Concepts

**Goal:** Understand that PowerShell works with objects, not just plain text.

- [x] Basic command structure
- [x] Using `Get-Help`, `Get-Command`, and `Get-Member`
- [x] Understanding objects, properties, and methods
- [x] Basic pipeline usage
- [x] Working with variables
- [ ] Deeper pipeline practice with `Select-Object`, `Where-Object`, and `ForEach-Object`
- [ ] Arrays, hashtables, and custom objects
- [ ] Filtering and sorting data effectively
- [ ] Building small examples to explain object-based thinking clearly

### Phase 2: Logic & Scripting Basics

**Goal:** Write scripts that can make decisions, handle data, and avoid unnecessary repetition.

- [x] Basic script structure
- [x] Simple variables and output
- [x] `if`, `else`, and `elseif`
- [ ] `switch` statements
- [ ] `while`, `do-until`, and `foreach` loops
- [ ] Basic error handling with `Try`, `Catch`, and `Finally`
- [ ] Understanding `$ErrorActionPreference`
- [ ] Reading and writing CSV files
- [ ] Reading and writing JSON files
- [ ] Understanding variable scope: Global, Script, Local, and Private

### Phase 3: Functions, Reusability & Toolmaking

**Goal:** Move from small scripts toward reusable tools.

- [x] Writing basic functions
- [x] Using parameters properly
- [x] Understanding pipeline input in functions
- [ ] Using `Process` blocks
- [ ] Introduction to `[CmdletBinding()]`
- [ ] Parameter validation
- [ ] Creating reusable helper functions
- [ ] Organizing scripts into modules
- [ ] Writing code that future-me can still understand six months later

### Phase 4: Automation Patterns

**Goal:** Build scripts that are clearer, safer, and more useful in real IT environments.

- [x] Logging patterns
- [ ] Using `Write-Verbose`
- [ ] Using transcripts
- [ ] Safer script execution and testing habits
- [ ] Idempotent scripting: scripts that can run more than once without breaking things
- [ ] Measuring performance with `Measure-Command`
- [ ] Understanding when to use native PowerShell and when .NET classes are useful
- [ ] Building repeatable admin workflows

### Phase 5: IAM, Microsoft 365 & Cloud Identity

**Goal:** Apply PowerShell knowledge to identity and access management scenarios.

- [x] Understanding the role of PowerShell in Microsoft 365 and identity administration
- [x] Basic awareness of Microsoft Graph and why it replaced older Azure AD / MSOnline modules
- [x] Understanding the purpose of permissions and scopes at a high level
- [ ] Microsoft Graph PowerShell SDK basics
- [ ] Connecting to Microsoft Graph
- [ ] Understanding Graph permissions and scopes in practice
- [ ] Reading user and group data
- [ ] Entra ID user lifecycle basics
- [ ] Joiner, Mover, Leaver automation concepts
- [ ] Group membership reporting
- [ ] Role-Based Access Control reporting
- [ ] Basic security and access review reporting
- [ ] Documenting identity automation use cases clearly

---

## 🏛️ Repository Structure

```text
01-fundamentals/
