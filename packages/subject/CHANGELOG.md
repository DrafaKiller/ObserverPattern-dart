## 2.0.0

BREAKING CHANGE:
> The way the generated classes and mixins are used has changed.
> 
> The `Observable${className}` mixin will have the `.on()` and `.onBefore()` methods, while the
> `${className}Subject` class will have the necessary overrides to make the mixin work.
> 
> The generator was refactored to make it easier to add new features and fix bugs.

Added:
- `sync` option to `SubjectWith` to change its synchronous behavior

Changed:
- The generated classes and mixins are now used differently, the generated mixin is the interface, the generated class is the overriding wrapper
- Renamed `observable` property in the generated `Subject` class to `subject`

Fixed:
- Subject properties were not being generated correctly, they were unable to be used

## 1.1.1

Fixed:
- `.onBefore()` wasn't called before, because of asyncronous `StreamController` initialization

## 1.1.0

Added:
- `SubjectWith` annotation to generate `Subject` classes with custom properties, such as subject and mixin names

## 1.0.6

Fixed:
- Made `subject:build` and `subject:watch` commands use `--delete-conflicting-outputs` to avoid conflicts with `build_runner`

## 1.0.5

Fixed:
- Inverted `isGeneratorInstalled()` check, when using `subject:build` and `subject:watch` commands

## 1.0.4

Fixed:
- `onError` callback not returning the correct value, when using `subject:build` and `subject:watch` commands

## 1.0.3

Fixed:
- Not nullable generic, when using `subject:build` and `subject:watch` commands

## 1.0.2

Changed:
- Improved `subject:build` and `subject:watch` commands

Fixed:
- Get dependencies after installing the `subject_gen` package, when using `subject:build` and `subject:watch` commands
- Correct awaiting, when using `subject:build` and `subject:watch` commands

## 1.0.1

Fixed:
- Documentation image URL and `CHANGELOG.md`

## 1.0.0

BREAKING CHANGES:
> The package was split into two packages, `subject` and `subject_gen`, to keep dependencies to a minimum.
> 
> In the process of refactoring, a lot of the code was rewritten, the API was changed to be more consistent and fix some issues.

Added:
- Split into `subject_gen` package to generate `Subject` classes, and keep dependencies to a minimum
- Build commands, `dart run subject:build` and `dart run subject:watch`, to install and run the code generator

Changed:
- Return type of `.on` and `.onBefore` is now `SubjectSubscription` instead of `SubjectObserver`

## 0.1.4

Added:
- Package logo and screenshots

Fixed:
- `Observer.stream` arguments were not being passed to the `StreamObserver` constructor

## 0.1.3

Changed:
- Improved documentation

## 0.1.2

Changed:
- Documentation to help with setting up the Code Generator
- Minor documentation improvements

## 0.1.1

Fixed:
- Builder name changed from `observer:subject` to `subject:build`

## 0.1.0

Added:
- Annotation `@dontObserve` to exclude elements from being observed when using `@subject`

## 0.0.2

Changed:
- Improved documentation

## 0.0.1

Initial release: Subject