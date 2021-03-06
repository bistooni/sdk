// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/src/error/codes.dart';
import 'package:analyzer/src/test_utilities/package_mixin.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../dart/resolution/driver_resolution.dart';

main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(MustBeImmutableTest);
  });
}

@reflectiveTest
class MustBeImmutableTest extends DriverResolutionTest with PackageMixin {
  void setUp() {
    super.setUp();
    addMetaPackage();
  }

  test_directAnnotation() async {
    await assertErrorCodesInCode(r'''
import 'package:meta/meta.dart';
@immutable
class A {
  int x;
}
''', [HintCode.MUST_BE_IMMUTABLE]);
  }

  test_directMixinAnnotation() async {
    await assertErrorCodesInCode(r'''
import 'package:meta/meta.dart';
@immutable
mixin A {
  int x;
}
''', [HintCode.MUST_BE_IMMUTABLE]);
  }

  test_extendsClassWithAnnotation() async {
    await assertErrorCodesInCode(r'''
import 'package:meta/meta.dart';
@immutable
class A {}
class B extends A {
  int x;
}
''', [HintCode.MUST_BE_IMMUTABLE]);
  }

  test_finalField() async {
    addMetaPackage();
    await assertNoErrorsInCode(r'''
import 'package:meta/meta.dart';
@immutable
class A {
  final x = 7;
}
''');
  }

  test_fromMixinWithAnnotation() async {
    await assertErrorCodesInCode(r'''
import 'package:meta/meta.dart';
@immutable
class A {}
class B {
  int x;
}
class C extends A with B {}
''', [HintCode.MUST_BE_IMMUTABLE]);
  }

  test_mixinApplication() async {
    await assertErrorCodesInCode(r'''
import 'package:meta/meta.dart';
@immutable
class A {}
class B {
  int x;
}
class C = A with B;
''', [HintCode.MUST_BE_IMMUTABLE]);
  }

  test_mixinApplicationBase() async {
    await assertErrorCodesInCode(r'''
import 'package:meta/meta.dart';
class A {
  int x;
}
class B {}
@immutable
class C = A with B;
''', [HintCode.MUST_BE_IMMUTABLE]);
  }

  test_staticField() async {
    await assertNoErrorsInCode(r'''
import 'package:meta/meta.dart';
@immutable
class A {
  static int x;
}
''');
  }
}
