# Make Interface Project

The **Make Interface Project** is a fully automated build system designed to streamline development. It simplifies running make commands, compiling code, managing UML diagrams, and debugging processes. By leveraging an interactive make prompt and a customizable `Makefile`, this project ensures that your development environment is easily maintainable and scalable.

## Table of Contents

1. [Project Overview](#project-overview)
2. [Installation](#installation)
3. [Usage](#usage)
   - [Running the Make Prompt](#running-the-make-prompt)
   - [Automatic Build Process](#automatic-build-process)
   - [Debugging](#debugging)
   - [UML Diagram Management](#uml-diagram-management)
   - [Other Utilities](#other-utilities)
4. [Makefile Structure](#makefile-structure)
   - [Variables](#variables)
   - [Targets](#targets)
5. [Contributing](#contributing)
6. [License](#license)

## Project Overview

The **Make Interface Project** includes an interactive prompt for selecting `make` targets and automates the downloading of necessary scripts, such as `make_prompt`. It also supports build processes, progress tracking, and a range of debugging tools for memory leaks, thread issues, and sanitization.

## Installation

To get started, clone the repository to your local machine:

```bash
git clone https://github.com/jeromeDev94/make_interface.git
cd make_interface
```

Next, trigger the `build.sh` script via the Makefile. The build script generates a customizable `Makefile` and other configuration files.

```bash
make build
```

This step downloads the `make_interface` repository and sets up the interface for running prompts and managing builds.

## Usage

### Running the Make Prompt

The **Make Prompt** provides an interactive way to run any `make` target. Once the project is initialized, you can start the prompt by running:

```bash
make run-prompt
```

This triggers the downloading script if it has not been executed previously. The prompt will allow you to execute any make target, manage build processes, or customize command-line arguments interactively.

### Automatic Build Process

The `Makefile` has a default `all` target to compile your project. Running `make all` triggers the entire compilation process, with a progress bar displayed for each step:

```bash
make all
```

The progress bar reflects the number of object files being processed and offers visual feedback on the compilation status.

### Debugging

The **Make Interface Project** includes several built-in debugging tools:

- **Sanitizer**: For thread sanitization:

  ```bash
  make san
  ```

- **Valgrind**: For detecting memory leaks:

  ```bash
  make valgrind
  ```

- **Helgrind**: For debugging thread concurrency issues:

  ```bash
  make helgrind
  ```

- **Debug Flag**: You can toggle the `DEBUG` flag within the project headers by running:

  ```bash
  make debug
  ```

### UML Diagram Management

This project provides interactive management of UML diagrams. You can browse and edit UML files in the `.uml` directory using:

```bash
make uml
```

It opens a file picker and then automatically launches Vim to edit the selected UML file.

### Other Utilities

- **Clean Build**: To remove compiled objects and executables:

  ```bash
  make clean
  make fclean
  ```

- **Norminette Check**: To ensure your code complies with 42 school norms:

  ```bash
  make norm
  ```

- **TODO Management**: For tracking project progress and tasks:

  ```bash
  make todo
  ```

- **Calendar Management**: You can also manage a project-specific calendar using:

  ```bash
  make calendar
  ```

## Makefile Structure

The `Makefile` is a central component of this project and is designed to be highly customizable.

### Variables

- **NAME**: Project name.
- **CC**: Compiler to be used.
- **CFLAGS**: Compilation flags.
- **LIBS**: Linked libraries.
- **INCLUDES**: Include directories for header files.
- **DIRLIBS**: Directory for linked libraries.

### Targets

The project supports various useful targets. You can explore the available targets using:

```bash
make help
```

Some of the primary targets include:

- **all**: Compiles the project.
- **run-prompt**: Launches the interactive make prompt.
- **san**: Enables thread sanitizer and compiles the project.
- **valgrind**: Runs Valgrind to check for memory leaks.
- **helgrind**: Runs Helgrind to detect thread synchronization issues.
- **debug**: Toggles the `DEBUG` flag in headers.
- **uml**: Opens an interactive menu to select and edit UML diagrams.
- **calendar**: Opens the project calendar in Vim.
- **todo**: Opens the project TODO list in Vim.
- **clean**: Cleans up object files.
- **fclean**: Cleans up object files and executables.
- **norm**: Runs norminette on the project.
- **build**: Runs the build script to set up the Makefile and environment.
- **update**: Updates the list of `.c` source files in the Makefile.

## Contributing

We welcome contributions from the community! To contribute:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Submit a pull request with a clear description of your changes.

## License

This project is licensed under the MIT License.
