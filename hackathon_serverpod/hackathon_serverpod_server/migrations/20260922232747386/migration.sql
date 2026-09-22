BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "child_login_code" (
    "id" bigserial PRIMARY KEY,
    "memberId" bigint NOT NULL,
    "codeHash" text NOT NULL,
    "expiresAt" timestamp without time zone NOT NULL,
    "usedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "child_login_code_member_id_idx" ON "child_login_code" USING btree ("memberId");
CREATE UNIQUE INDEX "child_login_code_code_hash_idx" ON "child_login_code" USING btree ("codeHash");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "child_login_code"
    ADD CONSTRAINT "child_login_code_fk_0"
    FOREIGN KEY("memberId")
    REFERENCES "group_member"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR hackathon_serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('hackathon_serverpod', '20260922232747386', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260922232747386', "timestamp" = now();

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
