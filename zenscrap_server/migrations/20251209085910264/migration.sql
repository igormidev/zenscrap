BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "anonymous_ip_spending" (
    "id" bigserial PRIMARY KEY,
    "ipAddress" text NOT NULL,
    "totalSpentUsd" double precision NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "lastUpdatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "anonymous_ip_spending_ip_idx" ON "anonymous_ip_spending" USING btree ("ipAddress");
CREATE INDEX "anonymous_ip_spending_created_at_idx" ON "anonymous_ip_spending" USING btree ("createdAt");


--
-- MIGRATION VERSION FOR zenscrap
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('zenscrap', '20251209085910264', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251209085910264', "timestamp" = now();

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
