BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "reward_item" ADD COLUMN "icon" text;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "task" ADD COLUMN "icon" text;
--
-- Data: the starting rewards of homes created before this migration get the
-- icon their template now carries.
--
UPDATE "reward_item" SET "icon" = '🛁' WHERE "icon" IS NULL AND "title" = 'Ducha larga sin que nadie llame';
UPDATE "reward_item" SET "icon" = '🎬' WHERE "icon" IS NULL AND "title" = 'Elegir la peli de la noche';
UPDATE "reward_item" SET "icon" = '🛋️' WHERE "icon" IS NULL AND "title" = 'El sofá y el mando toda la tarde';
UPDATE "reward_item" SET "icon" = '🍕' WHERE "icon" IS NULL AND "title" = 'Elijo yo la cena';
UPDATE "reward_item" SET "icon" = '🧽' WHERE "icon" IS NULL AND "title" = 'Te libras de fregar hoy';
UPDATE "reward_item" SET "icon" = '🥐' WHERE "icon" IS NULL AND "title" = 'Traigo el desayuno el domingo';
UPDATE "reward_item" SET "icon" = '🍻' WHERE "icon" IS NULL AND "title" = 'Unas cervezas y pago yo';
UPDATE "reward_item" SET "icon" = '🛒' WHERE "icon" IS NULL AND "title" = 'Te hago la compra esta semana';
UPDATE "reward_item" SET "icon" = '🔁' WHERE "icon" IS NULL AND "title" = 'Te cambio el turno de limpieza';
UPDATE "reward_item" SET "icon" = '🍽️' WHERE "icon" IS NULL AND "title" = 'Cena pagada fuera';
UPDATE "reward_item" SET "icon" = '📺' WHERE "icon" IS NULL AND "title" = 'Elijo yo la serie esta noche';
UPDATE "reward_item" SET "icon" = '☕' WHERE "icon" IS NULL AND "title" = 'Desayuno en la cama';
UPDATE "reward_item" SET "icon" = '💆' WHERE "icon" IS NULL AND "title" = 'Un masaje';
UPDATE "reward_item" SET "icon" = '🎉' WHERE "icon" IS NULL AND "title" = 'El plan del sábado lo elijo yo';
UPDATE "reward_item" SET "icon" = '🧽' WHERE "icon" IS NULL AND "title" = 'Te libras de una tarea';
UPDATE "reward_item" SET "icon" = '💪' WHERE "icon" IS NULL AND "title" = 'Hago tus tareas un día entero';
UPDATE "reward_item" SET "icon" = '🍽️' WHERE "icon" IS NULL AND "title" = 'Cena fuera, pago yo';
UPDATE "reward_item" SET "icon" = '🧳' WHERE "icon" IS NULL AND "title" = 'Escapada de fin de semana';

--
-- MIGRATION VERSION FOR hackathon_serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('hackathon_serverpod', '20261012193328922-item-icons', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261012193328922-item-icons', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260910193913364-string-rate-limit-keys', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260910193913364-string-rate-limit-keys', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260824182354731', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182354731', "timestamp" = now();


COMMIT;
