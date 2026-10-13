# Android phone test checklist — reliable tracking

Use a real Android phone (ideally also a Xiaomi/Oppo/Vivo/Realme one) and the
parent app on another device or simulator. Note the time for each step; the
admin panel (Alerts) shows "tracking lost" and the backend logs help.

Debug build: `flutter run --release` (or a release APK) is closest to
reality; debug builds are slower to start the service.

## A. Normal trip
1. Log in as the driver, do the daily check, **Start Trip**. Allow location
   ("While using" is enough) and notifications.
2. Expect: a persistent **"SmartVan — Trip in progress"** notification.
3. First time only: the system **battery optimization** dialog → Allow. On
   Xiaomi/Oppo/Vivo/Realme/Huawei/Honor a sheet "Keep tracking alive on …" →
   Open settings → enable Autostart / "Allow background activity" → back.
   Start another trip later: neither is asked again.
4. Parent app: van moves; "Updated N sec ago" ticks; "Live".

## B. Screen off / app in background
1. Lock the phone for 2 minutes while driving/walking. Unlock.
2. Parent map kept moving; the trail has no straight-line gap.

## C. App swiped away (the main case)
1. With the trip running, open recent apps → **swipe the driver app away**.
2. The notification must stay. Keep moving for 3+ minutes.
3. Parent map keeps moving ("Live"/"Weak signal" at worst, never "Driver
   offline" while the phone has data). Admin: no "tracking lost" alert.
4. Reopen the driver app: it resumes the trip screen; the map shows the trail
   made while it was closed; the socket pill says Live.
5. End the trip: the notification disappears; parent "No active trip".

## D. No internet, then back
1. During a trip switch on **airplane mode** (GPS still works) for 3+ minutes
   while moving; parent shows "Weak signal" then "Driver offline — last seen
   …" after 4 min (admin gets "tracking lost").
2. Switch airplane mode off. Within ~10 s the parent trail fills the gap
   (backfill) and "Live" returns; admin gets "tracking restored".
3. Repeat with the app swiped away during the offline minutes.

## E. Phone restarts / force stop (known limits — report what you see)
- Force stop from App info: the service dies (Android rule). Reopen the
  driver app → the trip resumes tracking.
- Reboot mid-trip: tracking does not auto-start until the app is opened.

## F. Weak GPS
Go indoors/basement while walking: after ~20 s the trip screen shows the
orange "GPS signal is weak…" banner; it clears outdoors. Standing still
outdoors must not show it.

## G. Battery
Run a 30-minute trip with the screen off; note the battery drop (expect a few
percent) and that the service was not killed (notification present).

## What to send back
Phone model + Android version, which steps failed, the time of failure, and
`adb logcat -s flutter` output around it if possible.
