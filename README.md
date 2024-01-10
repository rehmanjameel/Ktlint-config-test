## gradle configuration add jcentre() in (settings.gradle)
```repositories {
        jcenter() // Repository for Ktlint dependencies

        google()
        mavenCentral()
    }
```

## add ktlint plugin with updated version
```
plugins {
    id 'com.android.application'
    id 'org.jetbrains.kotlin.android'

## ktlint plugin
  id("org.jlleitschuh.gradle.ktlint") version "12.1.0"
}
```

## set java open-jdk to 17
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

## add script below the dependencies to coppy the bash file in .git/hooks/ folder
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
