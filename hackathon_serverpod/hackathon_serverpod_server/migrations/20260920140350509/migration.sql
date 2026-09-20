BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "task" (
    "id" bigserial PRIMARY KEY,
    "groupId" bigint NOT NULL,
    "title" text NOT NULL,
    "description" text NOT NULL,
    "reward" bigint NOT NULL,
    "kind" text NOT NULL DEFAULT 'oneOff'::text,
    "recurrence" text,
    "status" text NOT NULL DEFAULT 'proposed'::text,
    "proposedById" bigint NOT NULL,
    "doneById" bigint,
    "voteClosesAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "task_group_id_idx" ON "task" USING btree ("groupId");
CREATE INDEX "task_proposed_by_id_idx" ON "task" USING btree ("proposedById");
CREATE INDEX "task_done_by_id_idx" ON "task" USING btree ("doneById");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "task_vote" (
    "id" bigserial PRIMARY KEY,
    "taskId" bigint NOT NULL,
    "memberId" bigint NOT NULL,
    "phase" text NOT NULL,
    "approve" boolean NOT NULL,
    "counterReward" bigint
);

-- Indexes
CREATE UNIQUE INDEX "task_vote__taskId__phase__memberId__unique_idx" ON "task_vote" USING btree ("taskId", "phase", "memberId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "task"
    ADD CONSTRAINT "task_fk_0"
    FOREIGN KEY("groupId")
    REFERENCES "group"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "task"
    ADD CONSTRAINT "task_fk_1"
    FOREIGN KEY("proposedById")
    REFERENCES "group_member"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "task"
    ADD CONSTRAINT "task_fk_2"
    FOREIGN KEY("doneById")
    REFERENCES "group_member"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "task_vote"
    ADD CONSTRAINT "task_vote_fk_0"
    FOREIGN KEY("taskId")
    REFERENCES "task"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "task_vote"
    ADD CONSTRAINT "task_vote_fk_1"
    FOREIGN KEY("memberId")
    REFERENCES "group_member"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR hackathon_serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('hackathon_serverpod', '20260920140350509', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260920140350509', "timestamp" = now();

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
