# Medicine Reminder

A Flutter-based app to help users manage and track their daily medications efficiently, with notifications and historical tracking. Built using Hive for local storage and Flutter Local Notifications for reminders.


---

Features

Add & Manage Medications

Store medications with scheduled times and dosage information.

Set repeat days for recurring medications.


Daily Intake Tracking

Mark medications as taken.

Automatic detection of missed doses.

Grace period support for late intake.


Notifications

Daily reminders for medications at scheduled times.

Cancel or delete reminders for specific days or medications.


History & Progress

Track medication fulfillment for past, present, and future dates.

Day status: completed, partial, missed, or future.


Automatic Cleanup

Old medication intakes are cleaned up automatically to optimize storage.




---

Technologies Used

Flutter – UI framework

Hive – Local key-value database

Provider – State management

Flutter Local Notifications – Scheduling reminders

Intl – Date formatting



---

How It Works

1. Medication Scheduling – Users add medications with a scheduled time.


2. Notifications – App schedules daily reminders using local notifications.


3. Intake Logging – Users mark medications as taken; missed doses are auto-detected.


4. History Tracking – App maintains a daily fulfillment status for each day.


5. Cleanup & Deletion – Old intake logs or deleted medications automatically remove related data and cancel notifications.




---

Setup

1. Clone the repository


2. Run flutter pub get


3. Launch the app on an emulator or device


4. Grant notification permissions on Android/iOS


5. Add medications to receive reminders


---

Notes

Notifications require exact/alarm permissions on Android 13+.

Local storage (Hive) ensures offline functionality.

UI updates automatically when medications or intakes are changed.

---

Tested
//notifications
//persistant med routine by changing device dates and timezones
//

to do last
> add way to empty hive data , without clear data of app

V2
1.Delete feature to schedule meds 
2.upadte details 
3.
