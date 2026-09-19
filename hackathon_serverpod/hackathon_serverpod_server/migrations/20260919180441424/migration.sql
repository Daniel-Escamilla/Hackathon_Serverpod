BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "purchase" (
    "id" bigserial PRIMARY KEY,
    "groupId" bigint NOT NULL,
    "itemId" bigint NOT NULL,
    "buyerId" bigint NOT NULL,
    "providerId" bigint NOT NULL,
    "status" text NOT NULL DEFAULT 'pending'::text
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "reward_item" (
    "id" bigserial PRIMARY KEY,
    "groupId" bigint NOT NULL,
    "title" text NOT NULL,
    "description" text NOT NULL,
    "price" bigint NOT NULL,
    "status" text NOT NULL DEFAULT 'proposed'::text,
    "createdById" bigint NOT NULL,
    "stock" bigint
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "reward_vote" (
    "id" bigserial PRIMARY KEY,
    "itemId" bigint NOT NULL,
    "memberId" bigint NOT NULL,
    "approve" boolean NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "reward_vote__itemId__memberId__unique_idx" ON "reward_vote" USING btree ("itemId", "memberId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "purchase"
    ADD CONSTRAINT "purchase_fk_0"
    FOREIGN KEY("groupId")
    REFERENCES "group"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "purchase"
    ADD CONSTRAINT "purchase_fk_1"
    FOREIGN KEY("itemId")
    REFERENCES "reward_item"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "purchase"
    ADD CONSTRAINT "purchase_fk_2"
    FOREIGN KEY("buyerId")
    REFERENCES "group_member"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "purchase"
    ADD CONSTRAINT "purchase_fk_3"
    FOREIGN KEY("providerId")
    REFERENCES "group_member"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "reward_item"
    ADD CONSTRAINT "reward_item_fk_0"
    FOREIGN KEY("groupId")
    REFERENCES "group"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "reward_item"
    ADD CONSTRAINT "reward_item_fk_1"
    FOREIGN KEY("createdById")
    REFERENCES "group_member"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "reward_vote"
    ADD CONSTRAINT "reward_vote_fk_0"
    FOREIGN KEY("itemId")
    REFERENCES "reward_item"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "reward_vote"
    ADD CONSTRAINT "reward_vote_fk_1"
    FOREIGN KEY("memberId")
    REFERENCES "group_member"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR hackathon_serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('hackathon_serverpod', '20260919180441424', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260919180441424', "timestamp" = now();

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
