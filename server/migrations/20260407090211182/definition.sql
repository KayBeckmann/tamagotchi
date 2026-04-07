BEGIN;

--
-- Class AppUser as table app_users
--
CREATE TABLE "app_users" (
    "id" bigserial PRIMARY KEY,
    "username" text NOT NULL,
    "email" text NOT NULL,
    "passwordHash" text NOT NULL,
    "xp" bigint NOT NULL,
    "level" bigint NOT NULL,
    "eloRating" bigint NOT NULL,
    "walletBalanceSat" bigint NOT NULL,
    "totalWins" bigint NOT NULL,
    "totalLosses" bigint NOT NULL,
    "isActive" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "lastLoginAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "app_user_email_idx" ON "app_users" USING btree ("email");
CREATE UNIQUE INDEX "app_user_username_idx" ON "app_users" USING btree ("username");

--
-- Class AuthToken as table auth_tokens
--
CREATE TABLE "auth_tokens" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "tokenHash" text NOT NULL,
    "expiresAt" timestamp without time zone NOT NULL,
    "deviceInfo" text,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "auth_token_user_idx" ON "auth_tokens" USING btree ("userId");
CREATE UNIQUE INDEX "auth_token_hash_idx" ON "auth_tokens" USING btree ("tokenHash");

--
-- Class BattleRecord as table battle_records
--
CREATE TABLE "battle_records" (
    "id" bigserial PRIMARY KEY,
    "attackerUserId" bigint NOT NULL,
    "defenderUserId" bigint NOT NULL,
    "attackerCreatureId" bigint NOT NULL,
    "defenderCreatureId" bigint NOT NULL,
    "winnerUserId" bigint,
    "battleType" text NOT NULL,
    "tournamentId" bigint,
    "rounds" bigint NOT NULL,
    "attackerXpGained" bigint NOT NULL,
    "defenderXpGained" bigint NOT NULL,
    "satoshisAwarded" bigint NOT NULL,
    "battleLog" text,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "battle_attacker_idx" ON "battle_records" USING btree ("attackerUserId");
CREATE INDEX "battle_defender_idx" ON "battle_records" USING btree ("defenderUserId");

--
-- Class CreatureType as table creature_types
--
CREATE TABLE "creature_types" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "description" text NOT NULL,
    "category" text NOT NULL,
    "element" text NOT NULL,
    "baseAttack" bigint NOT NULL,
    "baseDefense" bigint NOT NULL,
    "baseSpeed" bigint NOT NULL,
    "baseHp" bigint NOT NULL,
    "spritePath" text NOT NULL,
    "isAvailable" boolean NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "creature_type_name_idx" ON "creature_types" USING btree ("name");

--
-- Class Creature as table creatures
--
CREATE TABLE "creatures" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "creatureTypeId" bigint NOT NULL,
    "name" text NOT NULL,
    "hunger" bigint NOT NULL,
    "happiness" bigint NOT NULL,
    "energy" bigint NOT NULL,
    "health" bigint NOT NULL,
    "cleanliness" bigint NOT NULL,
    "weight" double precision NOT NULL,
    "attack" bigint NOT NULL,
    "defense" bigint NOT NULL,
    "speed" bigint NOT NULL,
    "maxHp" bigint NOT NULL,
    "evolutionStage" text NOT NULL,
    "isActive" boolean NOT NULL,
    "isAlive" boolean NOT NULL,
    "isStunned" boolean NOT NULL,
    "stunUntil" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL,
    "lastStatUpdate" timestamp without time zone NOT NULL,
    "lastFedAt" timestamp without time zone,
    "lastPlayedAt" timestamp without time zone,
    "lastTrainedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "creature_user_idx" ON "creatures" USING btree ("userId");
CREATE INDEX "creature_active_idx" ON "creatures" USING btree ("userId", "isActive");

--
-- Class TournamentParticipant as table tournament_participants
--
CREATE TABLE "tournament_participants" (
    "id" bigserial PRIMARY KEY,
    "tournamentId" bigint NOT NULL,
    "userId" bigint NOT NULL,
    "creatureId" bigint NOT NULL,
    "seed" bigint NOT NULL,
    "isEliminated" boolean NOT NULL,
    "placement" bigint,
    "satoshisWon" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "tp_tournament_idx" ON "tournament_participants" USING btree ("tournamentId");
CREATE INDEX "tp_user_idx" ON "tournament_participants" USING btree ("userId");
CREATE UNIQUE INDEX "tp_unique_idx" ON "tournament_participants" USING btree ("tournamentId", "userId");

--
-- Class Tournament as table tournaments
--
CREATE TABLE "tournaments" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "format" text NOT NULL,
    "maxParticipants" bigint NOT NULL,
    "currentParticipants" bigint NOT NULL,
    "entryFeeSat" bigint NOT NULL,
    "prizePoolSat" bigint NOT NULL,
    "feePercent" double precision NOT NULL,
    "status" text NOT NULL,
    "winnerUserId" bigint,
    "roundTimeMinutes" bigint NOT NULL,
    "currentRound" bigint NOT NULL,
    "registrationEndsAt" timestamp without time zone NOT NULL,
    "startsAt" timestamp without time zone NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "tournament_status_idx" ON "tournaments" USING btree ("status");

--
-- Class Transaction as table transactions
--
CREATE TABLE "transactions" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "type" text NOT NULL,
    "amountSat" bigint NOT NULL,
    "description" text NOT NULL,
    "referenceId" bigint,
    "paymentHash" text,
    "status" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "transaction_user_idx" ON "transactions" USING btree ("userId");
CREATE INDEX "transaction_status_idx" ON "transactions" USING btree ("status");

--
-- Class CloudStorageEntry as table serverpod_cloud_storage
--
CREATE TABLE "serverpod_cloud_storage" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "addedTime" timestamp without time zone NOT NULL,
    "expiration" timestamp without time zone,
    "byteData" bytea NOT NULL,
    "verified" boolean NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_path_idx" ON "serverpod_cloud_storage" USING btree ("storageId", "path");
CREATE INDEX "serverpod_cloud_storage_expiration" ON "serverpod_cloud_storage" USING btree ("expiration");

--
-- Class CloudStorageDirectUploadEntry as table serverpod_cloud_storage_direct_upload
--
CREATE TABLE "serverpod_cloud_storage_direct_upload" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "expiration" timestamp without time zone NOT NULL,
    "authKey" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_direct_upload_storage_path" ON "serverpod_cloud_storage_direct_upload" USING btree ("storageId", "path");

--
-- Class FutureCallEntry as table serverpod_future_call
--
CREATE TABLE "serverpod_future_call" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "serializedObject" text,
    "serverId" text NOT NULL,
    "identifier" text
);

-- Indexes
CREATE INDEX "serverpod_future_call_time_idx" ON "serverpod_future_call" USING btree ("time");
CREATE INDEX "serverpod_future_call_serverId_idx" ON "serverpod_future_call" USING btree ("serverId");
CREATE INDEX "serverpod_future_call_identifier_idx" ON "serverpod_future_call" USING btree ("identifier");

--
-- Class ServerHealthConnectionInfo as table serverpod_health_connection_info
--
CREATE TABLE "serverpod_health_connection_info" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "active" bigint NOT NULL,
    "closing" bigint NOT NULL,
    "idle" bigint NOT NULL,
    "granularity" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_connection_info_timestamp_idx" ON "serverpod_health_connection_info" USING btree ("timestamp", "serverId", "granularity");

--
-- Class ServerHealthMetric as table serverpod_health_metric
--
CREATE TABLE "serverpod_health_metric" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "isHealthy" boolean NOT NULL,
    "value" double precision NOT NULL,
    "granularity" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_metric_timestamp_idx" ON "serverpod_health_metric" USING btree ("timestamp", "serverId", "name", "granularity");

--
-- Class LogEntry as table serverpod_log
--
CREATE TABLE "serverpod_log" (
    "id" bigserial PRIMARY KEY,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    "reference" text,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "logLevel" bigint NOT NULL,
    "message" text NOT NULL,
    "error" text,
    "stackTrace" text,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_log_sessionLogId_idx" ON "serverpod_log" USING btree ("sessionLogId");

--
-- Class MessageLogEntry as table serverpod_message_log
--
CREATE TABLE "serverpod_message_log" (
    "id" bigserial PRIMARY KEY,
    "sessionLogId" bigint NOT NULL,
    "serverId" text NOT NULL,
    "messageId" bigint NOT NULL,
    "endpoint" text NOT NULL,
    "messageName" text NOT NULL,
    "duration" double precision NOT NULL,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" bigint NOT NULL
);

--
-- Class MethodInfo as table serverpod_method
--
CREATE TABLE "serverpod_method" (
    "id" bigserial PRIMARY KEY,
    "endpoint" text NOT NULL,
    "method" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_method_endpoint_method_idx" ON "serverpod_method" USING btree ("endpoint", "method");

--
-- Class DatabaseMigrationVersion as table serverpod_migrations
--
CREATE TABLE "serverpod_migrations" (
    "id" bigserial PRIMARY KEY,
    "module" text NOT NULL,
    "version" text NOT NULL,
    "timestamp" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_migrations_ids" ON "serverpod_migrations" USING btree ("module");

--
-- Class QueryLogEntry as table serverpod_query_log
--
CREATE TABLE "serverpod_query_log" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    "query" text NOT NULL,
    "duration" double precision NOT NULL,
    "numRows" bigint,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_query_log_sessionLogId_idx" ON "serverpod_query_log" USING btree ("sessionLogId");

--
-- Class ReadWriteTestEntry as table serverpod_readwrite_test
--
CREATE TABLE "serverpod_readwrite_test" (
    "id" bigserial PRIMARY KEY,
    "number" bigint NOT NULL
);

--
-- Class RuntimeSettings as table serverpod_runtime_settings
--
CREATE TABLE "serverpod_runtime_settings" (
    "id" bigserial PRIMARY KEY,
    "logSettings" json NOT NULL,
    "logSettingsOverrides" json NOT NULL,
    "logServiceCalls" boolean NOT NULL,
    "logMalformedCalls" boolean NOT NULL
);

--
-- Class SessionLogEntry as table serverpod_session_log
--
CREATE TABLE "serverpod_session_log" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "module" text,
    "endpoint" text,
    "method" text,
    "duration" double precision,
    "numQueries" bigint,
    "slow" boolean,
    "error" text,
    "stackTrace" text,
    "authenticatedUserId" bigint,
    "isOpen" boolean,
    "touched" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_session_log_serverid_idx" ON "serverpod_session_log" USING btree ("serverId");
CREATE INDEX "serverpod_session_log_touched_idx" ON "serverpod_session_log" USING btree ("touched");
CREATE INDEX "serverpod_session_log_isopen_idx" ON "serverpod_session_log" USING btree ("isOpen");

--
-- Foreign relations for "auth_tokens" table
--
ALTER TABLE ONLY "auth_tokens"
    ADD CONSTRAINT "auth_tokens_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "app_users"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "battle_records" table
--
ALTER TABLE ONLY "battle_records"
    ADD CONSTRAINT "battle_records_fk_0"
    FOREIGN KEY("attackerUserId")
    REFERENCES "app_users"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "battle_records"
    ADD CONSTRAINT "battle_records_fk_1"
    FOREIGN KEY("attackerCreatureId")
    REFERENCES "creatures"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "creatures" table
--
ALTER TABLE ONLY "creatures"
    ADD CONSTRAINT "creatures_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "app_users"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "creatures"
    ADD CONSTRAINT "creatures_fk_1"
    FOREIGN KEY("creatureTypeId")
    REFERENCES "creature_types"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "tournament_participants" table
--
ALTER TABLE ONLY "tournament_participants"
    ADD CONSTRAINT "tournament_participants_fk_0"
    FOREIGN KEY("tournamentId")
    REFERENCES "tournaments"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "tournament_participants"
    ADD CONSTRAINT "tournament_participants_fk_1"
    FOREIGN KEY("userId")
    REFERENCES "app_users"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "tournament_participants"
    ADD CONSTRAINT "tournament_participants_fk_2"
    FOREIGN KEY("creatureId")
    REFERENCES "creatures"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "transactions" table
--
ALTER TABLE ONLY "transactions"
    ADD CONSTRAINT "transactions_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "app_users"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_log" table
--
ALTER TABLE ONLY "serverpod_log"
    ADD CONSTRAINT "serverpod_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_message_log" table
--
ALTER TABLE ONLY "serverpod_message_log"
    ADD CONSTRAINT "serverpod_message_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_query_log" table
--
ALTER TABLE ONLY "serverpod_query_log"
    ADD CONSTRAINT "serverpod_query_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR tamagotchi_server
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('tamagotchi_server', '20260407090211182', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260407090211182', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
