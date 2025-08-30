BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "scrappable" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "scrappable" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "accountId" bigint,
    "apiUsageOwnerNanoId" text,
    "createdAt" timestamp without time zone NOT NULL,
    "name" text NOT NULL,
    "description" text NOT NULL,
    "isPrivate" boolean NOT NULL,
    "testEndpointAvailableUntil" timestamp without time zone,
    "scrappingRules" text,
    "willHideFromMarketplace" boolean NOT NULL,
    "targetRequestId" bigint NOT NULL,
    "referenceTestDataId" bigint NOT NULL,
    "category" bigint NOT NULL,
    "isDeleted" boolean NOT NULL DEFAULT false
);

-- Indexes
CREATE UNIQUE INDEX "scrappable_target_request_unique_idx" ON "scrappable" USING btree ("targetRequestId");
CREATE UNIQUE INDEX "scrappable_reference_test_data_unique_idx" ON "scrappable" USING btree ("referenceTestDataId");

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
-- MIGRATION VERSION FOR zenscrap
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('zenscrap', '20250830011014232', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250830011014232', "timestamp" = now();

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
