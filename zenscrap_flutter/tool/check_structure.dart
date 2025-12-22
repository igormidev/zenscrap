// ignore_for_file: avoid_print

import 'dart:io';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:path/path.dart' as path;

/// Custom structure validation for ZenScrap Flutter UI folder.
///
/// Rules:
/// 1. Single Widget Per File - Each file has only one public widget class
/// 2. Folder Suffix Convention - Files follow naming conventions
/// 3. Test Mirror Structure - Tests mirror lib/src/ui/ structure
/// 4. No Widget Functions - No public functions returning Widget
///
/// Usage:
///   dart run tool/check_structure.dart
///   dart run tool/check_structure.dart --fix  (future feature)
void main(List<String> arguments) async {
  final checker = StructureChecker();
  final exitCode = await checker.run();
  exit(exitCode);
}

/// ANSI color codes for terminal output
class ConsoleColors {
  static const String reset = '\x1B[0m';
  static const String red = '\x1B[31m';
  static const String green = '\x1B[32m';
  static const String yellow = '\x1B[33m';
  static const String blue = '\x1B[34m';
  static const String cyan = '\x1B[36m';
  static const String bold = '\x1B[1m';
}

/// Represents a validation issue
class StructureIssue {
  final String filePath;
  final int? lineNumber;
  final String message;
  final IssueSeverity severity;

  const StructureIssue({
    required this.filePath,
    this.lineNumber,
    required this.message,
    this.severity = IssueSeverity.error,
  });

  @override
  String toString() {
    final color =
        severity == IssueSeverity.error ? ConsoleColors.red : ConsoleColors.yellow;
    final prefix = severity == IssueSeverity.error ? 'ERROR' : 'WARNING';
    final location = lineNumber != null ? ':$lineNumber' : '';
    return '$color[$prefix]${ConsoleColors.reset} $filePath$location\n  $message';
  }
}

enum IssueSeverity { error, warning }

/// Folder naming conventions
class FolderConvention {
  final String folderName;
  final String fileSuffix;
  final String? classSuffix;
  final bool enforced;

  const FolderConvention({
    required this.folderName,
    required this.fileSuffix,
    this.classSuffix,
    this.enforced = true,
  });
}

/// Main structure checker class
class StructureChecker {
  final List<StructureIssue> _issues = [];

  /// Folder conventions to enforce
  static const List<FolderConvention> conventions = [
    FolderConvention(
      folderName: 'views',
      fileSuffix: '_view.dart',
      classSuffix: 'View',
    ),
    FolderConvention(
      folderName: 'view', // Support singular too
      fileSuffix: '_view.dart',
      classSuffix: 'View',
    ),
    FolderConvention(
      folderName: 'pages',
      fileSuffix: '_page.dart',
      classSuffix: 'Page',
    ),
    FolderConvention(
      folderName: 'page',
      fileSuffix: '_page.dart',
      classSuffix: 'Page',
    ),
    FolderConvention(
      folderName: 'dialogs',
      fileSuffix: '_dialog.dart',
      classSuffix: 'Dialog',
    ),
    FolderConvention(
      folderName: 'dialog',
      fileSuffix: '_dialog.dart',
      classSuffix: 'Dialog',
    ),
    FolderConvention(
      folderName: 'sections',
      fileSuffix: '_section.dart',
      classSuffix: 'Section',
    ),
    FolderConvention(
      folderName: 'section',
      fileSuffix: '_section.dart',
      classSuffix: 'Section',
    ),
    FolderConvention(
      folderName: 'templates',
      fileSuffix: '_template.dart',
      classSuffix: 'Template',
    ),
    FolderConvention(
      folderName: 'template',
      fileSuffix: '_template.dart',
      classSuffix: 'Template',
    ),
    FolderConvention(
      folderName: 'layouts',
      fileSuffix: '_layout.dart',
      classSuffix: 'Layout',
    ),
    FolderConvention(
      folderName: 'layout',
      fileSuffix: '_layout.dart',
      classSuffix: 'Layout',
    ),
    FolderConvention(
      folderName: 'widgets',
      fileSuffix: '_widget.dart',
      classSuffix: null, // Flexible naming for widgets
      enforced: false,
    ),
  ];

  /// Files to exclude from checking
  static const List<String> excludePatterns = [
    '.g.dart',
    '.freezed.dart',
    '.gr.dart',
    '_test.dart',
  ];

  /// Widget base class names (including Riverpod variants)
  static const List<String> widgetBaseClasses = [
    'StatelessWidget',
    'StatefulWidget',
    'ConsumerWidget',
    'ConsumerStatefulWidget',
    'HookWidget',
    'HookConsumerWidget',
  ];

  Future<int> run() async {
    print('${ConsoleColors.cyan}${ConsoleColors.bold}'
        'Running ZenScrap Structure Checker...'
        '${ConsoleColors.reset}\n');

    final libDir = Directory('lib/src/ui');
    final testDir = Directory('test/ui');

    if (!await libDir.exists()) {
      print('${ConsoleColors.yellow}Warning: lib/src/ui directory not found${ConsoleColors.reset}');
      return 0;
    }

    // Run all checks
    await _checkSingleWidgetPerFile(libDir);
    await _checkFolderSuffixConvention(libDir);
    await _checkNoWidgetFunctions(libDir);
    await _checkTestMirrorStructure(libDir, testDir);

    // Print results
    _printResults();

    // Return exit code
    final errorCount = _issues.where((i) => i.severity == IssueSeverity.error).length;
    return errorCount > 0 ? 1 : 0;
  }

  /// Rule 1: Single Widget Per File
  /// Each file should have only one public widget class (private widgets allowed)
  Future<void> _checkSingleWidgetPerFile(Directory dir) async {
    await for (final entity in dir.list(recursive: true)) {
      if (entity is! File) continue;
      if (!entity.path.endsWith('.dart')) continue;
      if (_isExcluded(entity.path)) continue;

      try {
        final content = await entity.readAsString();
        final result = parseString(
          content: content,
          featureSet: FeatureSet.latestLanguageVersion(),
        );

        final visitor = _WidgetClassVisitor();
        result.unit.visitChildren(visitor);

        final publicWidgets = visitor.publicWidgetClasses;

        if (publicWidgets.length > 1) {
          _issues.add(StructureIssue(
            filePath: _relativePath(entity.path),
            message: 'Multiple public widget classes found: ${publicWidgets.join(", ")}. '
                'Each file should have only one public widget class.',
          ));
        }
      } catch (e) {
        // Skip files that can't be parsed
      }
    }
  }

  /// Rule 2: Folder Suffix Convention
  /// Files in views/ should end with _view.dart, classes should end with View, etc.
  Future<void> _checkFolderSuffixConvention(Directory dir) async {
    await for (final entity in dir.list(recursive: true)) {
      if (entity is! File) continue;
      if (!entity.path.endsWith('.dart')) continue;
      if (_isExcluded(entity.path)) continue;

      final filePath = entity.path;
      final parentFolder = path.basename(path.dirname(filePath));
      final fileName = path.basename(filePath);

      // Find matching convention
      final convention = conventions.where((c) => c.folderName == parentFolder).firstOrNull;

      if (convention == null || !convention.enforced) continue;

      // Check file suffix
      if (!fileName.endsWith(convention.fileSuffix)) {
        _issues.add(StructureIssue(
          filePath: _relativePath(filePath),
          message: 'File in "${convention.folderName}/" folder should end with '
              '"${convention.fileSuffix}", found "$fileName"',
          severity: IssueSeverity.warning,
        ));
      }

      // Check class suffix if specified
      if (convention.classSuffix != null) {
        try {
          final content = await entity.readAsString();
          final result = parseString(
            content: content,
            featureSet: FeatureSet.latestLanguageVersion(),
          );

          final visitor = _WidgetClassVisitor();
          result.unit.visitChildren(visitor);

          for (final className in visitor.publicWidgetClasses) {
            if (!className.endsWith(convention.classSuffix!)) {
              _issues.add(StructureIssue(
                filePath: _relativePath(filePath),
                lineNumber: visitor.classLineNumbers[className],
                message: 'Widget class "$className" in "${convention.folderName}/" folder '
                    'should end with "${convention.classSuffix}"',
              ));
            }
          }
        } catch (e) {
          // Skip files that can't be parsed
        }
      }
    }
  }

  /// Rule 3: Test Mirror Structure
  /// Tests in test/ui/ should mirror lib/src/ui/ structure
  Future<void> _checkTestMirrorStructure(Directory libDir, Directory testDir) async {
    if (!await testDir.exists()) {
      _issues.add(StructureIssue(
        filePath: 'test/ui',
        message: 'Test directory test/ui/ does not exist. '
            'Tests should mirror lib/src/ui/ structure.',
        severity: IssueSeverity.warning,
      ));
      return;
    }

    // Get all lib/src/ui directories (features)
    await for (final entity in libDir.list()) {
      if (entity is! Directory) continue;

      final featureName = path.basename(entity.path);
      final testFeatureDir = Directory(path.join(testDir.path, featureName));

      if (!await testFeatureDir.exists()) {
        _issues.add(StructureIssue(
          filePath: 'test/ui/$featureName',
          message: 'Missing test directory for feature "$featureName". '
              'Expected test/ui/$featureName/ to mirror lib/src/ui/$featureName/',
          severity: IssueSeverity.warning,
        ));
      }
    }
  }

  /// Rule 4: No Widget Functions
  /// No public functions returning Widget (except builders)
  Future<void> _checkNoWidgetFunctions(Directory dir) async {
    await for (final entity in dir.list(recursive: true)) {
      if (entity is! File) continue;
      if (!entity.path.endsWith('.dart')) continue;
      if (_isExcluded(entity.path)) continue;

      try {
        final content = await entity.readAsString();
        final result = parseString(
          content: content,
          featureSet: FeatureSet.latestLanguageVersion(),
        );

        final visitor = _WidgetFunctionVisitor();
        result.unit.visitChildren(visitor);

        for (final issue in visitor.issues) {
          _issues.add(StructureIssue(
            filePath: _relativePath(entity.path),
            lineNumber: issue.lineNumber,
            message: issue.message,
          ));
        }
      } catch (e) {
        // Skip files that can't be parsed
      }
    }
  }

  bool _isExcluded(String filePath) {
    for (final pattern in excludePatterns) {
      if (filePath.endsWith(pattern)) return true;
    }
    return false;
  }

  String _relativePath(String absolutePath) {
    final cwd = Directory.current.path;
    if (absolutePath.startsWith(cwd)) {
      return absolutePath.substring(cwd.length + 1);
    }
    return absolutePath;
  }

  void _printResults() {
    if (_issues.isEmpty) {
      print('${ConsoleColors.green}${ConsoleColors.bold}'
          'No issues found!'
          '${ConsoleColors.reset}');
      return;
    }

    final errors = _issues.where((i) => i.severity == IssueSeverity.error).toList();
    final warnings = _issues.where((i) => i.severity == IssueSeverity.warning).toList();

    for (final issue in _issues) {
      print(issue);
      print('');
    }

    print('${ConsoleColors.bold}Summary:${ConsoleColors.reset}');
    if (errors.isNotEmpty) {
      print('  ${ConsoleColors.red}${errors.length} error(s)${ConsoleColors.reset}');
    }
    if (warnings.isNotEmpty) {
      print('  ${ConsoleColors.yellow}${warnings.length} warning(s)${ConsoleColors.reset}');
    }
  }
}

/// AST visitor to find widget classes
class _WidgetClassVisitor extends RecursiveAstVisitor<void> {
  final List<String> publicWidgetClasses = [];
  final Map<String, int> classLineNumbers = {};

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final className = node.name.lexeme;

    // Skip private classes
    if (className.startsWith('_')) {
      super.visitClassDeclaration(node);
      return;
    }

    // Check if it extends a widget base class
    final extendsClause = node.extendsClause;
    if (extendsClause != null) {
      final superclassName = extendsClause.superclass.name2.lexeme;
      if (StructureChecker.widgetBaseClasses.contains(superclassName)) {
        publicWidgetClasses.add(className);
        classLineNumbers[className] = node.name.offset;
      }
    }

    super.visitClassDeclaration(node);
  }
}

/// Holds info about a widget function issue
class _WidgetFunctionIssue {
  final int lineNumber;
  final String message;

  const _WidgetFunctionIssue({
    required this.lineNumber,
    required this.message,
  });
}

/// AST visitor to find functions returning Widget
///
/// RULE: NO function or method should return Widget except:
/// - The standard `Widget build(BuildContext context)` override
///
/// This applies to BOTH public AND private functions/methods.
class _WidgetFunctionVisitor extends RecursiveAstVisitor<void> {
  final List<_WidgetFunctionIssue> issues = [];

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    final name = node.name.lexeme;

    // Check if it returns Widget
    final returnType = node.returnType?.toSource();
    if (returnType == 'Widget' || returnType == 'Widget?') {
      final visibility = name.startsWith('_') ? 'Private' : 'Public';
      issues.add(_WidgetFunctionIssue(
        lineNumber: node.offset,
        message: '$visibility function "$name" returns Widget. '
            'Functions returning Widget are forbidden. '
            'Convert to a StatelessWidget or StatefulWidget class instead.',
      ));
    }

    super.visitFunctionDeclaration(node);
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    final name = node.name.lexeme;

    // ONLY exception: the standard build() override method
    if (name == 'build') {
      super.visitMethodDeclaration(node);
      return;
    }

    // Check if it returns Widget
    final returnType = node.returnType?.toSource();
    if (returnType == 'Widget' || returnType == 'Widget?') {
      final visibility = name.startsWith('_') ? 'Private' : 'Public';
      issues.add(_WidgetFunctionIssue(
        lineNumber: node.offset,
        message: '$visibility method "$name" returns Widget. '
            'Methods returning Widget are forbidden. '
            'Extract to a separate widget class (e.g., _${_toPascalCase(name)} extends StatelessWidget).',
      ));
    }

    super.visitMethodDeclaration(node);
  }

  /// Converts a method name like "_buildCompactLayout" to "CompactLayout"
  String _toPascalCase(String name) {
    // Remove leading underscore and "build" prefix
    var result = name;
    if (result.startsWith('_')) {
      result = result.substring(1);
    }
    if (result.startsWith('build')) {
      result = result.substring(5);
    }
    // Capitalize first letter
    if (result.isNotEmpty) {
      result = result[0].toUpperCase() + result.substring(1);
    }
    return result;
  }
}
