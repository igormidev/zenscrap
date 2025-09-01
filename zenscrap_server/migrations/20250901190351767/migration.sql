BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "scrappable" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "scrappable" (
    "id" bigserial PRIMARY KEY,
    "accountId" bigint,
    "apiUsageOwnerNanoId" text,
    "createdAt" timestamp without time zone NOT NULL,
    "generalInfosUpdatedAt" timestamp without time zone NOT NULL,
    "extractRulesUpdatedAt" timestamp without time zone NOT NULL,
    "name" text NOT NULL,
    "description" text NOT NULL,
    "testEndpointAvailableUntil" timestamp without time zone,
    "scrappingRules" text,
    "willHideFromMarketplace" boolean NOT NULL,
    "targetRequestId" bigint NOT NULL,
    "referenceTestDataId" bigint NOT NULL,
    "category" bigint NOT NULL,
    "isDeleted" boolean NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "scrappable_target_request_unique_idx" ON "scrappable" USING btree ("targetRequestId");
CREATE UNIQUE INDEX "scrappable_reference_test_data_unique_idx" ON "scrappable" USING btree ("referenceTestDataId");

--
-- ACTION DROP TABLE
--
DROP TABLE "scrappable_analytics" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "scrappable_analytics" (
    "id" bigserial PRIMARY KEY,
    "requestStatus" bigint NOT NULL,
    "requestedAt" timestamp without time zone NOT NULL,
    "attachedNanoId" text NOT NULL,
    "attachedApiKey" text NOT NULL,
    "scrappableId" bigint NOT NULL
);

-- Indexes
CREATE INDEX "scrappable_analytics_attached_nanoid_idx" ON "scrappable_analytics" USING btree ("attachedNanoId");
CREATE INDEX "scrappable_analytics_attached_apikey_idx" ON "scrappable_analytics" USING btree ("attachedApiKey");

--
-- ACTION DROP TABLE
--
DROP TABLE "scrappable_test_result" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "scrappable_test_result" (
    "id" bigserial PRIMARY KEY,
    "testExtractRule" text NOT NULL,
    "extractJsonResult" text NOT NULL,
    "scrappableId" bigint NOT NULL,
    "referenceTestDataId" bigint
);

-- Indexes
CREATE INDEX "scrappable_id_idx" ON "scrappable_test_result" USING btree ("scrappableId");
CREATE UNIQUE INDEX "reference_test_data_unique_idx" ON "scrappable_test_result" USING btree ("referenceTestDataId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "scrappable"
    ADD CONSTRAINT "scrappable_fk_0"
    FOREIGN KEY("accountId")
    REFERENCES "account_info"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "scrappable"
    ADD CONSTRAINT "scrappable_fk_1"
    FOREIGN KEY("targetRequestId")
    REFERENCES "scrappable_target_request"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "scrappable"
    ADD CONSTRAINT "scrappable_fk_2"
    FOREIGN KEY("referenceTestDataId")
    REFERENCES "scrappable_test_data"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "scrappable_analytics"
    ADD CONSTRAINT "scrappable_analytics_fk_0"
    FOREIGN KEY("scrappableId")
    REFERENCES "scrappable"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "scrappable_test_result"
    ADD CONSTRAINT "scrappable_test_result_fk_0"
    FOREIGN KEY("referenceTestDataId")
    REFERENCES "scrappable_test_data"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR zenscrap
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('zenscrap', '20250901190351767', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250901190351767', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20240520102713718', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240520102713718', "timestamp" = now();


COMMIT;
