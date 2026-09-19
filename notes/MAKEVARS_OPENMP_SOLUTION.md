# Makevars-Only Solution for OpenMP on macOS

## The Problem

When compiling R packages with OpenMP support on macOS (especially data.table), you may encounter this error:

```
Error: package or namespace load failed for 'data.table' in dyn.load(file, DLLpath = DLLpath, ...):
 unable to load shared object '.../data_table.so':
  dlopen(...): Symbol not found: ___kmpc_dispatch_deinit
  Referenced from: .../data_table.so
  Expected in: .../libomp.dylib
```

### Root Cause

1. Homebrew's `libomp.dylib` has its install_name set to an absolute path: `/opt/homebrew/opt/libomp/lib/libomp.dylib`
2. When R packages link against it, they inherit this absolute path
3. At runtime, R loads its own bundled OpenMP library first, which doesn't have the required symbols
4. This causes a symbol mismatch and loading fails

## The Solution

Create a local modified copy of `libomp.dylib` with `@rpath` as its install_name, then configure Makevars to use this version.

### Setup Steps (One-Time)

```bash
# 1. Create lib directory in ~/.R
mkdir -p ~/.R/lib

# 2. Copy libomp and modify its install_name
cp /opt/homebrew/opt/libomp/lib/libomp.dylib ~/.R/lib/libomp.dylib
install_name_tool -id @rpath/libomp.dylib ~/.R/lib/libomp.dylib

# 3. Verify the change
otool -D ~/.R/lib/libomp.dylib
# Should output:
# /Users/yourusername/.R/lib/libomp.dylib:
# @rpath/libomp.dylib
```

### Configure ~/.R/Makevars

```makefile
CC=clang
CXX=clang++
CFLAGS=-g -O2 -Wall -pedantic -Wconversion -Wno-sign-conversion
CXXFLAGS=-g -O2 -Wall -pedantic -Wconversion -Wno-sign-conversion
CPPFLAGS=-I/opt/homebrew/opt/libomp/include -I/opt/homebrew/opt/gettext/include -Xclang -fopenmp
LDFLAGS=-L/opt/homebrew/opt/gettext/lib
PKG_LIBS=$(HOME)/.R/lib/libomp.dylib -Wl,-rpath,/opt/homebrew/opt/libomp/lib -Wl,-rpath,$(HOME)/.R/lib
```

### Key Points

1. **`PKG_LIBS=$(HOME)/.R/lib/libomp.dylib`**: Links against our modified library with `@rpath` install_name
2. **`-Wl,-rpath,/opt/homebrew/opt/libomp/lib`**: Adds Homebrew's directory to the runtime search path
3. **`-Wl,-rpath,$(HOME)/.R/lib`**: Adds our local directory as a fallback
4. **Result**: The compiled `.so` file has `@rpath/libomp.dylib` as its dependency, and at runtime it searches both paths

### Verification

After installing a package from source (e.g., data.table):

```bash
# Check the library dependencies
otool -L /Library/Frameworks/R.framework/Versions/4.5-arm64/Resources/library/data.table/libs/data_table.so
```

You should see:
```
@rpath/libomp.dylib (compatibility version 5.0.0, current version 5.0.0)
```

NOT:
```
/opt/homebrew/opt/libomp/lib/libomp.dylib (compatibility version 5.0.0, current version 5.0.0)
```

### Test Installation

```r
# Install data.table from source
remotes::install_github("Rdatatable/data.table", force = TRUE)

# Test loading
library(data.table)
# Should load successfully without errors
```

## Why This Works

1. **Compilation**: Links against `~/.R/lib/libomp.dylib`, which has `@rpath` as its install_name
2. **Binary Recording**: The resulting `.so` records the dependency as `@rpath/libomp.dylib` (not an absolute path)
3. **Runtime Search**: The rpath settings tell the dynamic linker to search:
   - `/opt/homebrew/opt/libomp/lib/` (primary - where the actual library is)
   - `~/.R/lib/` (backup - where our modified copy is)
4. **Loading**: The dynamic linker finds the library and loads it successfully

## Maintenance

- **If Homebrew updates libomp**: Re-run the setup steps to update your local copy
- **For new machines**: Copy the entire `~/.R/` directory or re-run setup steps
- **No post-install fixes needed**: Everything is handled by Makevars automatically

## Alternative Approaches That Don't Work

1. **Using `-lomp` directly**: Links against absolute path from Homebrew's install_name
2. **Using full path in PKG_LIBS**: Records absolute path in the binary
3. **Post-install `install_name_tool`**: Requires manual intervention after every install
4. **Modifying R's bundled OpenMP**: Not portable, breaks on R updates

This solution is the only purely Makevars-based approach that works for both installation and loading.
