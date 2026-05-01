# 🛠️ PowerShell Playground

**A personal learning playground, practical lab and growing PowerShell handbook.**

This repository documents my process of learning PowerShell at a deeper level.

I already use PowerShell in my daily IT work, mainly through ready-made scripts and practical commands. This playground is where I slow down, break things apart and build a better understanding of how PowerShell actually works under the hood.

The goal is not to collect random scripts or copy-paste commands. The goal is to understand the logic behind them: how PowerShell handles objects, how data moves through the pipeline, how scripts make decisions and how to write code that is clearer, safer and easier to maintain.

This repository includes notes, experiments, small scripts, reusable patterns, troubleshooting examples and practical exercises based on topics I want to understand more deeply.

---

## 🎯 Current Focus

I am currently strengthening my PowerShell foundation with a focus on:

- Understanding the PowerShell pipeline and object-based output
- Working with variables, arrays, hashtables and custom objects
- Filtering, sorting and transforming data
- Reading and writing CSV and JSON files
- Writing clearer, safer and more reusable scripts
- Understanding existing scripts instead of only running them
- Building confidence to modify and create scripts independently

This is an active learning repository, so the content will grow over time as my skills develop.

---

## 🧭 Roadmap: From Script User to Confident PowerShell Builder

This roadmap is divided into phases that move from PowerShell fundamentals toward practical scripting, reusable tools and automation patterns.

### Phase 1: The Foundation — Core Concepts

**Goal:** Understand that PowerShell works with objects, not just plain text.

- [x] Basic command structure
- [x] Using `Get-Help`, `Get-Command` and `Get-Member`
- [x] Understanding objects, properties and methods
- [x] Basic pipeline usage
- [x] Working with variables
- [ ] Deeper pipeline practice with `Select-Object`, `Where-Object` and `ForEach-Object`
- [ ] Arrays, hashtables and custom objects
- [ ] Filtering and sorting data effectively
- [ ] Building small examples to explain object-based thinking clearly

### Phase 2: Logic and Scripting Basics

**Goal:** Write scripts that can make decisions, handle data and avoid unnecessary repetition.

- [x] Basic script structure
- [x] Simple variables and output
- [x] `if`, `else` and `elseif`
- [ ] `switch` statements
- [ ] `while`, `do-until` and `foreach` loops
- [ ] Basic error handling with `Try`, `Catch` and `Finally`
- [ ] Understanding `$ErrorActionPreference`
- [ ] Reading and writing CSV files
- [ ] Reading and writing JSON files
- [ ] Understanding variable scope: Global, Script, Local and Private

### Phase 3: Functions, Reusability and Toolmaking

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

**Goal:** Build scripts that are clearer, safer and more useful in real IT environments.

- [x] Logging patterns
- [ ] Using `Write-Verbose`
- [ ] Using transcripts
- [ ] Safer script execution and testing habits
- [ ] Idempotent scripting: scripts that can run more than once without breaking things
- [ ] Measuring performance with `Measure-Command`
- [ ] Understanding when to use native PowerShell and when .NET classes are useful
- [ ] Building repeatable admin workflows

### Phase 5: Practical IT Scripting

**Goal:** Apply PowerShell knowledge to real IT support, troubleshooting and administration scenarios.

- [x] Using PowerShell in daily IT work with existing scripts
- [x] Reading and understanding ready-made scripts at a basic level
- [x] Running practical commands for support and troubleshooting tasks
- [ ] Modifying existing scripts safely
- [ ] Writing small tools for repeated tasks
- [ ] Creating reports from system or user data
- [ ] Exporting useful data to CSV or JSON
- [ ] Building scripts with clearer parameters and error handling
- [ ] Documenting what a script does, why it exists and how to use it
- [ ] Turning repeated manual work into small automation exercises

---

## 🏛️ Repository Structure

```text
01-fundamentals/
