import 'package:flutter/material.dart';

/// Centralized border radius system — single source of truth.
///
/// All border radii MUST be referenced through this class.
class AppRadius {
  AppRadius._();

  // ─── Raw Values ───────────────────────────────────────────────────────────
  static const double xxs  = 2.0;
  static const double xs   = 4.0;
  static const double sm   = 6.0;
  static const double md   = 8.0;
  static const double def  = 10.0;
  static const double lg   = 14.0;
  static const double xl   = 18.0;
  static const double xxl  = 22.0;
  static const double pill = 30.0;
  
  static const double title = 16.0;
  static const double card  = 20.0;
  static const double hero  = 28.0;

  // ─── Convenience Radius ───────────────────────────────────────────────────
  static const Radius radiusXxs  = Radius.circular(xxs);
  static const Radius radiusXs   = Radius.circular(xs);
  static const Radius radiusSm   = Radius.circular(sm);
  static const Radius radiusMd   = Radius.circular(md);
  static const Radius radiusDef  = Radius.circular(def);
  static const Radius radiusLg   = Radius.circular(lg);
  static const Radius radiusXl   = Radius.circular(xl);
  static const Radius radiusXxl  = Radius.circular(xxl);
  static const Radius radiusPill = Radius.circular(pill);
  static const Radius radiusCard = Radius.circular(card);
  static const Radius radiusHero = Radius.circular(hero);

  // ─── Convenience BorderRadius ─────────────────────────────────────────────
  static final BorderRadius borderXxs  = BorderRadius.circular(xxs);
  static final BorderRadius borderXs   = BorderRadius.circular(xs);
  static final BorderRadius borderSm   = BorderRadius.circular(sm);
  static final BorderRadius borderMd   = BorderRadius.circular(md);
  static final BorderRadius borderDef  = BorderRadius.circular(def);
  static final BorderRadius borderLg   = BorderRadius.circular(lg);
  static final BorderRadius borderXl   = BorderRadius.circular(xl);
  static final BorderRadius borderXxl  = BorderRadius.circular(xxl);
  static final BorderRadius borderPill = BorderRadius.circular(pill);
  static final BorderRadius borderTitle = BorderRadius.circular(title);
  static final BorderRadius borderCard = BorderRadius.circular(card);
  static final BorderRadius borderHero = BorderRadius.circular(hero);

  // ─── Ribbon Badge Radius ──────────────────────────────────────────────────
  static const BorderRadius ribbonLeft = BorderRadius.only(
    topLeft: Radius.circular(6),
    bottomLeft: Radius.circular(6),
    topRight: Radius.circular(3),
    bottomRight: Radius.circular(3),
  );

  static const BorderRadius ribbonTopRight = BorderRadius.only(
    topRight: Radius.circular(10),
    bottomLeft: Radius.circular(6),
  );

  static const BorderRadius ribbonBadge = BorderRadius.only(
    topRight: Radius.circular(14),
    bottomLeft: Radius.circular(8),
  );

  static const BorderRadius borderXlOnlyTop = BorderRadius.vertical(
    top: Radius.circular(xl),
  );
}
