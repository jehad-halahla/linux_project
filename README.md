# Linux Command Documentation Generator

## Project Overview

This project, developed by Jehad Halahla as part of the Electrical & Computer Engineering Department at the Faculty of Engineering & Technology, provides a script named "the_man.sh" that facilitates the generation, search, recommendation, and verification of command documentation in a Linux environment.

### Project Details

- **Project ID:** 1
- **Student ID:** 1201467
- **Instructor:** Dr. Amr Slimi
- **T.A:** Tareq Zidan
- **Section:** 1
- **Date:** 3/1/2024

## Introduction

The main script, "the_man.sh," utilizes the functionality of "verify.sh" to verify the documentation of any command, highlighting differences using the `diff` command. Additionally, the project includes a script named "test_all.sh" to batch-generate information such as command description, version information, related commands, and execution examples.

The project focuses on 22 commands, but it can easily expand to accommodate more. The documentation generation is semi-automatic and compatible with commands that have direct output.

## Usage

The script supports several run options, covering various aspects of the project.

### Part 1: Generation

1. **Batch Generate:**
   ```bash
   ./the_man.sh batch-generate
2. **Selective Generate:**
   ```bash
   ./the_man.sh generate [COMMAND]
### Part 2: Search Feature
3. **search:**
   ```bash
   ./the_man.sh search
4. **Recommendation:**
   ```bash
   ./the_man.sh recommend
5. **verification:**
   ```bash
   ./the_man.sh verify [COMMAND]
   ## Usage of Search History

The script utilizes the `history.txt` file located in the `/tmp` directory to store the search history. This file is instrumental in providing recommended commands based on previous user searches.

## Included Scripts and Requirements

The project incorporates the following scripts:

### 1. `verify.sh`

The `verify.sh` script is utilized within the main script (`the_man.sh`) to verify the documentation of any command, highlighting differences using the `diff` command.

### 2. `test_all.sh`

The `test_all.sh` script is employed in the main script to batch-generate information such as command description, version information, related commands, and execution examples.

### Project Requirements

- The project requires a `command.txt` file to be present in the same directory as the scripts.
- No additional installations of tools or dependencies are necessary for the project to run successfully.

```bash
# Example: Running the project
./the_man.sh batch-generate

# Example: Viewing search history
cat /tmp/history.txt

