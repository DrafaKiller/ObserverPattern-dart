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