-- Explicit objects only. Keep the shared PostGIS extension and migration ledger.
DROP TABLE blueway.moderation_actions;
DROP TABLE blueway.alert_history;
DROP TABLE blueway.notifications;
DROP TABLE blueway.report_photos;
DROP TABLE blueway.report_positioning;
DROP TABLE blueway.reports;
DROP TABLE blueway.device_positions;
DROP TABLE blueway.devices;
DROP TABLE blueway.boats;
DROP TABLE blueway.users;
DROP FUNCTION blueway.guard_audit();
DROP FUNCTION blueway.guard_device_owner();
DROP FUNCTION blueway.guard_report();
DROP FUNCTION blueway.check_photo_children();
DROP FUNCTION blueway.lock_photo_parent();
DROP SCHEMA blueway;
