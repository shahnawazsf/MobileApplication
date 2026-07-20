# Logistics feature — Flutter files

Generated screens for the SDX logistics app, matching the light-theme
mockups in `Logistics App.dc.html` (turn 3) and reusing your existing
`core/theme/app_colors.dart` tokens.

## Where to put these

Copy the whole `lib/features/logistics/` folder into your app's `lib/`.
It only depends on `core/theme/app_colors.dart`, which you already have.

```
lib/features/logistics/
  domain/
    shipment.dart                 # models + demo data (Shipment, ShipmentStatus, JourneyStep)
  presentation/
    logistics_shell.dart          # bottom-tab shell with scan FAB
    widgets/
      logistics_widgets.dart      # SoftCard, StatusChip, RouteProgress,
                                  # LightAuroraBackground, LogisticsNavBar
    screens/
      logistics_home_screen.dart  # 3a — KPI grid + active containers
      shipment_list_screen.dart   # 3b — list + search + filters
      shipment_detail_screen.dart # 3c — customs/journey timeline + SADAD duty
      scan_screen.dart            # 3e — container / Bayan QR scanner
      notifications_screen.dart   # 3f — alerts feed grouped by day
```

## Wiring it up

Add a route that returns `const LogisticsShell()` — e.g. in `core/router/app_router.dart`:

```dart
GoRoute(
  path: '/logistics',
  builder: (context, state) => const LogisticsShell(),
),
```

## Notes

- **Theme**: uses your `AppColors` (brand blue `#2563EB` → indigo `#4F46E5`
  gradient, cyan accent, status colors). The light background uses
  `LightAuroraBackground`; for the dark variant swap in the existing
  `AnimatedGradientBackground` from `core/widgets/`.
- **Fonts**: Poppins comes from your app theme (`AppTextStyles` via
  `google_fonts`) — no change needed. For Arabic screens add `Cairo` the
  same way and set `Directionality(textDirection: TextDirection.rtl, …)`.
- **Data**: `demoShipments` is placeholder data. Replace with a Riverpod
  provider / repository backed by your API. `Shipment`, `ShipmentStatus`
  and `JourneyStep` are ready to serialize.
- **Scanner**: `scan_screen.dart` renders an animated placeholder frame.
  For a real scan, wire `mobile_scanner` (or similar) into `_ScannerFrame`
  and forward decoded values.
- **Detail navigation**: `LogisticsHomeScreen.onOpenShipment` currently
  passes `null` — pass the tapped `Shipment` through when you connect real data.
```
