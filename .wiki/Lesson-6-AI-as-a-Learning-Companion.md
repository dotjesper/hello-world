This page is a hands-on introduction to AI-assisted coding with GitHub Copilot in Visual Studio Code. Through practical exercises, you will learn how to use AI as a learning companion - writing effective prompts, generating and validating code, and building skills through intentional collaboration with AI.

For downloading and referencing repository content programmatically, see the [Lesson 5 Working With Repositories](./Lesson-5-Working-With-Repositories) page. For GitHub Copilot configuration and custom instructions, see the [Lesson 7 Copilot Configuration](./Lesson-7-Copilot-Configuration) page.

## What is vibe coding?

Vibe coding is a term for using AI tools to assist with writing code, scripts, and documentation. You describe what you want in natural language, and AI helps you get there faster. But vibe coding is not about blindly accepting generated output - it is about collaborating with AI while applying your own knowledge, experience, and judgment.

> Using AI to write code is not cheating. It is a superpower - but only if you approach it with the right mindset. The difference between a superpower and a crutch is simple: one makes you stronger, the other makes you weaker.
>
> Source: [Exploring Vibe Coding as a Superpower](https://dotjesper.com/2026/exploring-vibe-coding-as-a-superpower/) by Jesper Nielsen

## Getting started with GitHub Copilot

GitHub Copilot is the AI assistant built into Visual Studio Code. Before starting the exercises on this page, make sure you have the following prerequisites in place:

- A GitHub account with a GitHub Copilot subscription (Free, Pro, or through your organization)
- Visual Studio Code installed with the GitHub Copilot extension
- Signed in to your GitHub account in Visual Studio Code

Once set up, GitHub Copilot provides several capabilities:

- **Code completions** - Suggests code as you type, based on context and comments
- **Copilot Chat** - A conversational interface for asking questions, explaining code, and generating snippets
- **Inline Chat** - Ask questions or request changes directly in the editor without leaving your code
- **Agents and slash commands** - Specialized modes for tasks like fixing errors, generating tests, or working with the terminal

For official documentation, see [GitHub Copilot documentation](https://docs.github.com/en/copilot).

## Your first Copilot conversation

This exercise walks you through opening Copilot Chat and having your first AI-assisted conversation. The goal is to get comfortable with the interface and see how AI responds to questions about code.

1. Open Visual Studio Code and press **Ctrl+Alt+I** to open Copilot Chat (or click the Copilot icon in the sidebar)
2. Type the following prompt and press **Enter**:

   ```text
   Please help me understand the difference between a PowerShell function and a cmdlet.
   ```

3. Read the response carefully - notice how GitHub Copilot provides a structured explanation with examples
4. Follow up with a clarifying question:

   ```text
   Could you please show me a simple example of a PowerShell function that accepts
   a parameter?
   ```

5. Review the generated code - do you understand every line?

> [!TIP]
> Copilot Chat remembers the context of your conversation. You can ask follow-up questions that build on previous answers without repeating yourself.

### What to notice

This first exercise demonstrates something important about AI-assisted coding. Each response gives you something new to explore - you see patterns you have not encountered before, discover new approaches to familiar problems, and build knowledge through interaction. This is the core of using AI as a learning companion - every conversation becomes educational when you approach it with curiosity.

## Writing effective prompts

The quality of AI-generated output depends directly on the quality of your prompts. This exercise demonstrates the difference between vague and specific prompts.

A good prompt includes four key components:

- **Goal** - What specific response do you want?
- **Context** - Why do you need it and who is involved?
- **Source** - What information or examples should the AI use?
- **Expectations** - How should the AI format and tailor its response?

### Comparing vague and specific prompts

Try both of these prompts in Copilot Chat and compare the results:

**Vague prompt:**

```text
Please help me draft a PowerShell script to get computer info.
```

**Specific prompt:**

```text
Please help me draft a PowerShell function that retrieves the computer name, operating
system version, total physical memory in GB, and last boot time. Use CIM instances
instead of WMI. Format the output as a custom PSObject. Include comment-based help
with a description and example usage.
```

The specific prompt produces code that is closer to what you actually need, requires less editing, and follows better practices. The difference is dramatic - and it illustrates why prompt engineering is a real skill that improves with practice.

### Iterating on a prompt

AI-assisted coding works best as a conversation, not a single request. After receiving the initial response to the specific prompt above, try these follow-up prompts:

1. `Please help me add error handling for cases where the CIM queries fail`
2. `Can you please explain why you used Get-CimInstance instead of Get-WmiObject?`
3. `Please help me refactor this to accept a list of remote computer names as a parameter`

Each iteration refines the output and teaches you something new about the approach.

## Generating and understanding a script

This exercise walks you through the full cycle of generating code with AI, understanding it, and making it your own. This is where the learning companion mindset matters most - treat the output as scaffolding, not a finished product.

1. Open a new file in Visual Studio Code and save it as `Get-SystemUptime.ps1`
2. Open Copilot Chat and enter this prompt:

   ```text
   Please help me draft a PowerShell script that calculates how long the current
   system has been running. Display the uptime in days, hours, and minutes. Use
   Get-CimInstance to retrieve the last boot time. Add a comment-based help block
   with a description and example.
   ```

3. Review the generated script before accepting it. Read every line and identify:
   - Which cmdlets are used and why?
   - How is the time calculation performed?
   - What would happen if the CIM query fails?

4. Ask GitHub Copilot to explain the code by selecting it and typing in Copilot Chat:

   ```text
   Could you please explain this script line by line? What does each section do
   and why was this approach chosen?
   ```

5. Try modifying the script yourself - for example, add a `-ComputerName` parameter to check remote systems

> [!NOTE]
> You do not need to keep the file you created. The purpose of this exercise is the process of generating, reviewing, understanding, and modifying - not the final script itself.

## Learning a new concept through AI

One of the most powerful uses of AI-assisted coding is exploring unfamiliar concepts. This exercise replicates a real-world discovery - learning bitmasks through GitHub Copilot.

### Background

While developing a PowerShell script for Windows Autopilot device preparation, a design challenge emerged - the script needed to control multiple features with a single parameter instead of cluttering the parameter list with multiple switches. GitHub Copilot introduced the concept of bitmasks - a technique using individual bits as feature flags:

| Value | Binary | Feature |
| :---- | :----- | :------ |
| 1 | 0001 | Device Renaming |
| 2 | 0010 | OOBE Registry Settings |
| 4 | 0100 | BitLocker Validation |
| 8 | 1000 | Location Marker |

Any combination can be enabled with a single integer: `15` enables all features, `7` enables the first three, `5` enables renaming and BitLocker only.

### Try it yourself

Open Copilot Chat and work through these prompts in sequence:

1. Start with a discovery question:

   ```text
   Please help me explore a design question. I have a PowerShell script that needs
   to enable or disable multiple features. Instead of using separate switch
   parameters for each feature, is there a cleaner approach using a single parameter?
   ```

2. Ask for a concrete example:

   ```text
   Please help me draft an example of how to implement this with bitmask values
   in PowerShell, using the -band operator. Include 4 features as an example.
   ```

3. Deepen your understanding:

   ```text
   Could you please explain how the -band bitwise operator works in this context?
   Why do the feature values need to be powers of 2?
   ```

4. Explore the trade-offs:

   ```text
   Please help me understand the advantages and disadvantages of using bitmasks
   compared to using an array of feature names as a parameter.
   ```

This exercise demonstrates the learning cycle - you start with a problem, discover a technique through AI, build understanding through follow-up questions, and evaluate trade-offs. The bitmask concept was not just copied - it was understood, validated, and added as a new technique to the toolkit.

## Validating AI-generated code

Every piece of AI-generated code needs to go through your personal quality control process before you use it. This exercise walks you through validating a Copilot-generated script.

1. Ask GitHub Copilot to generate a script:

   ```text
   Please help me draft a PowerShell script that reads a CSV file of user display
   names and checks whether each account exists in Entra ID using Microsoft Graph
   PowerShell. Include error handling and output a summary of found and missing
   accounts.
   ```

2. Before running or using the generated code, work through this validation checklist:

   | Step | Question to ask yourself |
   | :--- | :----------------------- |
   | **Read and understand** | Can you explain what every line does? If not, ask GitHub Copilot to explain the parts you do not understand. |
   | **Test thoroughly** | Does it work with sample data? What happens with empty input, missing columns, or malformed CSV files? |
   | **Review for security** | Does the script handle credentials safely? Does it expose tokens or sensitive data in output? |
   | **Ensure maintainability** | Would a colleague understand this code in six months? Are variable names clear and is the logic straightforward? |
   | **Confirm compliance** | Does it follow your organization's naming conventions, coding standards, and approved modules? |

3. Ask GitHub Copilot to review its own output:

   ```text
   Could you please review this script for potential security issues, edge cases,
   and best practices? What would you improve?
   ```

4. Compare GitHub Copilot's review with your own findings - did you catch the same issues?

This validation process is where you add value that AI cannot provide. You understand your specific environment, your organization's requirements, and the broader context in which the code will operate.

## Using logs and AI to troubleshoot and optimize

Scripts that log their actions give you a powerful advantage when something goes wrong - or when you want to make things better. By building structured logging into your PowerShell scripts, you create a detailed record that AI can analyze to help you find issues, understand behavior, and optimize performance.

### Why logging matters

Without logs, troubleshooting means guessing. With logs, you have a timeline of exactly what happened, when it happened, and what the outcome was. Well-structured logs become even more valuable when you can hand them to GitHub Copilot and ask pointed questions.

A practical logging approach records each significant action with a timestamp, severity level, and descriptive message:

```powershell
# Description: A reusable logging function that writes timestamped entries to a log file
# Elevation is not required - writes to the current user's temp directory

function Write-Log {
    param (
        [Parameter(Mandatory)]
        [string]$Message,
        [ValidateSet("INFO", "WARNING", "ERROR")]
        [string]$Level = "INFO",
        [string]$LogFile = "$env:TEMP\script-log.txt"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $entry = "$timestamp [$Level] $Message"
    Add-Content -Path $LogFile -Value $entry
}
```

With this function in place, your scripts can log every meaningful step:

```powershell
Write-Log -Message "Script started - processing 42 devices"
Write-Log -Message "Querying device: PC-001"
Write-Log -Message "Device PC-001 - rename successful"
Write-Log -Message "Device PC-002 - failed to connect" -Level "ERROR"
Write-Log -Message "Processing complete - 41 succeeded, 1 failed" -Level "WARNING"
```

### Troubleshooting with AI and logs

When a script fails or behaves unexpectedly, copy the relevant log output into Copilot Chat along with your script. Try this workflow:

1. Ask GitHub Copilot to generate a script that processes a list of items and includes logging at each step:

   ```text
   Please help me draft a PowerShell script that reads a list of computer names
   from a text file, pings each one, and logs the result (success or failure) with
   timestamps to a log file. Use a Write-Log function for consistent log formatting.
   ```

2. Run the script against a few computer names (real or fictitious) to generate log output

3. Open the log file, select the content, and ask GitHub Copilot to analyze it:

   ```text
   Here is the log output from my script. Could you please help me identify any
   errors or patterns in the failures, and suggest what might be causing the issues?
   ```

4. Ask GitHub Copilot to help optimize based on what the logs reveal:

   ```text
   Based on the log output, this script takes a long time when devices are
   unreachable. Please help me draft an optimized version that fails faster on
   unreachable devices and processes multiple devices in parallel.
   ```

5. Take it further - ask for improvements to the logging itself:

   ```text
   Please help me improve the logging in this script. I want to track execution
   time for each device and add a summary at the end with total duration and
   success rate.
   ```

### What this exercise demonstrates

Logging and AI-assisted troubleshooting work together as a feedback loop. The logging captures what happened, and AI helps you understand why it happened and how to improve it:

- **Structured logs** make it easy for both you and AI to spot patterns and anomalies
- **Timestamps** reveal performance bottlenecks that would be invisible without measurement
- **Severity levels** help AI prioritize which issues to address first
- **Detailed messages** give AI the context it needs to provide specific, actionable suggestions

This is a workflow you can apply to any script - build in thorough logging from the start, and you will always have the data you need to troubleshoot and optimize with AI as your companion.

## Guidelines for AI-assisted coding

These guidelines help you build effective habits when working with AI tools.

### Practices that build skills

Effective AI-assisted coding starts with these habits:

- **Start with understanding** - Before asking AI for help, make sure you understand the problem you are trying to solve
- **Be specific in requests** - Vague prompts produce vague results, as demonstrated in Exercise 2
- **Review everything critically** - Treat AI output as a draft, not a final product
- **Learn from the output** - Each interaction is a learning opportunity
- **Validate thoroughly** - Testing and verification are non-negotiable, as practiced in Exercise 5
- **Iterate and refine** - Good solutions often emerge through multiple rounds of refinement
- **Ask the AI to explain** - Use Copilot Chat to understand why code works, not just what it does

### Pitfalls to avoid

These practices lead to problems and undermine the value of AI tools:

- **Deploying code you cannot explain** - If you do not understand it, you cannot maintain or troubleshoot it
- **Skipping testing** - AI-generated code needs the same rigorous testing as hand-written code
- **Ignoring security** - Always check for potential vulnerabilities or data exposure in generated code
- **Accepting output blindly** - The AI can be wrong, outdated, or make assumptions that do not fit your context
- **Using AI to avoid learning** - Passive use creates dependency without building skills

> [!IMPORTANT]
> A calculator does not prevent mathematicians from understanding mathematics. It frees them to focus on higher-level concepts. Similarly, AI-assisted coding can free you to focus on architecture, design, and problem-solving - but only if you actively engage with the output and build understanding along the way.

## Useful references

These resources provide further reading on the topics covered on this page:

- [5 reasons you should explore vibe coding](https://dotjesper.com/2025/5-reasons-you-should-explore-vibe-coding/) - Introduction to vibe coding and why it matters for IT professionals
- [Exploring Vibe Coding as a Superpower](https://dotjesper.com/2026/exploring-vibe-coding-as-a-superpower/) - Blog post exploring AI-assisted coding as a learning companion
- [GitHub Copilot documentation](https://docs.github.com/en/copilot) - Official documentation for getting started with GitHub Copilot
- [Prompt engineering best practices](https://platform.openai.com/docs/guides/prompt-engineering) - Techniques for crafting effective prompts

---

*Page revised: March 10, 2026*
