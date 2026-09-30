BEGIN;

--
-- ACTION ALTER TABLE
--
CREATE INDEX "coin_transaction_group_id_idx" ON "coin_transaction" USING btree ("groupId");
CREATE INDEX "coin_transaction_member_id_idx" ON "coin_transaction" USING btree ("memberId");
--
-- ACTION ALTER TABLE
--
CREATE INDEX "group_member_group_id_idx" ON "group_member" USING btree ("groupId");
--
-- ACTION ALTER TABLE
--
CREATE INDEX "purchase_group_id_idx" ON "purchase" USING btree ("groupId");
CREATE INDEX "purchase_item_id_idx" ON "purchase" USING btree ("itemId");
CREATE INDEX "purchase_buyer_id_idx" ON "purchase" USING btree ("buyerId");
CREATE INDEX "purchase_provider_id_idx" ON "purchase" USING btree ("providerId");
--
-- ACTION ALTER TABLE
--
CREATE INDEX "reward_item_group_id_idx" ON "reward_item" USING btree ("groupId");
CREATE INDEX "reward_item_created_by_id_idx" ON "reward_item" USING btree ("createdById");

--
-- MIGRATION VERSION FOR hackathon_serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('hackathon_serverpod', '20260919195555720', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260919195555720', "timestamp" = now();

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
