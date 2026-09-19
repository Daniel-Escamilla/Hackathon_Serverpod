BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "group" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "type" text NOT NULL,
    "inviteCode" text NOT NULL,
    "finePercent" bigint NOT NULL DEFAULT 20,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "group__inviteCode__unique_idx" ON "group" USING btree ("inviteCode");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "group_member" (
    "id" bigserial PRIMARY KEY,
    "groupId" bigint NOT NULL,
    "authUserId" uuid NOT NULL,
    "displayName" text NOT NULL,
    "role" text NOT NULL,
    "status" text NOT NULL DEFAULT 'active'::text,
    "balance" bigint NOT NULL DEFAULT 0,
    "joinedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "leftAt" timestamp without time zone
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "group_member"
    ADD CONSTRAINT "group_member_fk_0"
    FOREIGN KEY("groupId")
    REFERENCES "group"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR hackathon_serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('hackathon_serverpod', '20260919175616297', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260919175616297', "timestamp" = now();

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
