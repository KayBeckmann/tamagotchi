BEGIN;

--
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "auth_tokens"
    ADD CONSTRAINT "auth_tokens_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "app_users"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
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
-- ACTION CREATE FOREIGN KEY
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
-- ACTION CREATE FOREIGN KEY
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
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "transactions"
    ADD CONSTRAINT "transactions_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "app_users"("id")
    ON DELETE NO ACTION
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
