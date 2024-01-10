#### gradle configuration add jcentre() in (settings.gradle)
```repositories {
        jcenter() // Repository for Ktlint dependencies

        google()
        mavenCentral()
    }
```

#### add ktlint plugin with updated version
```
plugins {
    id 'com.android.application'
    id 'org.jetbrains.kotlin.android'

## ktlint plugin
  id("org.jlleitschuh.gradle.ktlint") version "12.1.0"
}
```

#### set java open-jdk to 17
```
android {
.....
compileOptions {
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }
.....
}
```

### add script below the dependencies to coppy the bash file in .git/hooks/ folder
```
dependencies {
    ....
}

tasks.register('installGitHook', Copy) {
    def suffix = "ubuntu"  // Set the suffix for Ubuntu
    if (Os.isFamily(Os.FAMILY_WINDOWS)) {
        suffix = "windows"
    } else if (Os.isFamily(Os.FAMILY_MAC)) {
        suffix = "macos"
    }

   // Copy pre-commit script
    from new File(rootProject.rootDir, "scripts/pre-commit-$suffix")
    into { new File(rootProject.rootDir, '.git/hooks') }
    rename("pre-commit-$suffix", 'pre-commit')
 
   // Resolve the absolute paths for pre-push script
    def scriptsDir = new File(rootProject.rootDir, "scripts")
    def prePushScript = new File(scriptsDir, "pre-push-$suffix")
    def gitHooksDir = new File(rootProject.rootDir, '.git/hooks')

  // Copy pre-push script
    from prePushScript
    into gitHooksDir
    rename("pre-push-$suffix", 'pre-push')
    fileMode 0775
}

// Configure the dependency after projects have been evaluated
gradle.projectsEvaluated {
    tasks.getByPath(':app:preBuild').dependsOn installGitHook
}
```

#### create .editorconfig file in project's rook directory
```
# Top-level EditorConfig file
root = true

[*]
indent_style = space
indent_size = 4
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true
```

#### create a folder "scripts" in root directory of project and save the text files in that folder
#### pre-push-ubuntu/ pre-push-macos (this file will run automatically to check the code voilations)
```
#!/bin/bash

# Retrieve changed Kotlin files from the recent commit
CHANGED_FILES=$(git diff --name-only HEAD~1 -- '*.kt')
echo "Changed files are: $CHANGED_FILES"

# Exit early if no Kotlin files changed
if [ -z "$CHANGED_FILES" ]; then
    echo "No Kotlin files changed."
    exit 0
fi

# Ensure Gradle execution from the root project
cd "$(git rev-parse --show-toplevel)"

# Iterate through changed files and check them individually
for file in $CHANGED_FILES
do
    echo "Checking Ktlint for file: $file"
    ./gradlew ktlintCheck

    # Check the exit status of the Ktlint check
    if [ $? -ne 0 ]; then
        echo "Ktlint check failed on file: $file"
        exit 1
    fi
done

echo "Ktlint check passed on all changed files."
exit 0
```

#### pre-push-window for window
it could be one of these two lines as not tested for window
```
#!/bin/bash
##  < #!C:/Program\ Files/Git/usr/bin/sh.exe >  ##
```
```
#!/bin/bash
##  < #!C:/Program\ Files/Git/usr/bin/sh.exe >  ##


# Retrieve changed Kotlin files from the recent commit
CHANGED_FILES=$(git diff --name-only HEAD~1 -- '*.kt')
echo "Changed files are: $CHANGED_FILES"

# Exit early if no Kotlin files changed
if [ -z "$CHANGED_FILES" ]; then
    echo "No Kotlin files changed."
    exit 0
fi

# Ensure Gradle execution from the root project
cd "$(git rev-parse --show-toplevel)"

# Iterate through changed files and check them individually
for file in $CHANGED_FILES
do
    echo "Checking Ktlint for file: $file"
    ./gradlew.bat ktlintCheck --project-dir=$(dirname "$file")

    # Check the exit status of the Ktlint check
    if [ $? -ne 0 ]; then
        echo "Ktlint check failed on file: $file"
        exit 1
    fi
done

echo "Ktlint check passed on all changed files."
exit 0
```
