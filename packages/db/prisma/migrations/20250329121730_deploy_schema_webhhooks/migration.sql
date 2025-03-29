-- CreateTable
CREATE TABLE "SchemaVersion" (
    "id" TEXT NOT NULL,
    "categoryId" TEXT NOT NULL,
    "version" TEXT NOT NULL,
    "sqlDefinition" TEXT NOT NULL,
    "migrationScript" TEXT,
    "releaseNotes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "SchemaVersion_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "IndexingCategorySelection" (
    "id" TEXT NOT NULL,
    "preferenceId" TEXT NOT NULL,
    "categoryId" TEXT NOT NULL,
    "parameters" JSONB,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "IndexingCategorySelection_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DeployedSchema" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "categoryId" TEXT NOT NULL,
    "targetDatabase" TEXT NOT NULL,
    "schemaVersion" TEXT NOT NULL,
    "tableName" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "lastDeployed" TIMESTAMP(3),
    "migrationHistory" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "DeployedSchema_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "IndexingJob" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "categoryId" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'pending',
    "parameters" JSONB,
    "targetTable" TEXT NOT NULL,
    "syncStrategy" TEXT NOT NULL DEFAULT 'incremental',
    "syncFrequency" TEXT NOT NULL DEFAULT 'realtime',
    "customFrequency" TEXT,
    "lastSyncedAt" TIMESTAMP(3),
    "nextScheduledSync" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "webhookConfigId" TEXT,

    CONSTRAINT "IndexingJob_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DataStatistics" (
    "id" TEXT NOT NULL,
    "jobId" TEXT NOT NULL,
    "totalRecords" INTEGER NOT NULL DEFAULT 0,
    "lastDayRecords" INTEGER NOT NULL DEFAULT 0,
    "lastHourRecords" INTEGER NOT NULL DEFAULT 0,
    "averageLatency" INTEGER,
    "storageUsed" INTEGER,
    "lastUpdated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "DataStatistics_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WebhookConfig" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "heliusWebhookId" TEXT,
    "endpoint" TEXT,
    "filters" JSONB,
    "status" TEXT NOT NULL DEFAULT 'pending',
    "lastReceivedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "WebhookConfig_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SyncLog" (
    "id" TEXT NOT NULL,
    "jobId" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "recordsProcessed" INTEGER,
    "details" JSONB,
    "startTime" TIMESTAMP(3) NOT NULL,
    "endTime" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "SyncLog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ApiKey" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "key" TEXT NOT NULL,
    "lastUsed" TIMESTAMP(3),
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ApiKey_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "SchemaVersion_categoryId_version_key" ON "SchemaVersion"("categoryId", "version");

-- CreateIndex
CREATE UNIQUE INDEX "IndexingCategorySelection_preferenceId_categoryId_key" ON "IndexingCategorySelection"("preferenceId", "categoryId");

-- CreateIndex
CREATE UNIQUE INDEX "DeployedSchema_userId_categoryId_targetDatabase_key" ON "DeployedSchema"("userId", "categoryId", "targetDatabase");

-- CreateIndex
CREATE UNIQUE INDEX "DataStatistics_jobId_key" ON "DataStatistics"("jobId");

-- CreateIndex
CREATE UNIQUE INDEX "ApiKey_key_key" ON "ApiKey"("key");

-- CreateIndex
CREATE INDEX "ApiKey_key_idx" ON "ApiKey"("key");

-- AddForeignKey
ALTER TABLE "SchemaVersion" ADD CONSTRAINT "SchemaVersion_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "IndexingCategory"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "IndexingCategorySelection" ADD CONSTRAINT "IndexingCategorySelection_preferenceId_fkey" FOREIGN KEY ("preferenceId") REFERENCES "IndexingPreference"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "IndexingCategorySelection" ADD CONSTRAINT "IndexingCategorySelection_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "IndexingCategory"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DeployedSchema" ADD CONSTRAINT "DeployedSchema_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DeployedSchema" ADD CONSTRAINT "DeployedSchema_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "IndexingCategory"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "IndexingJob" ADD CONSTRAINT "IndexingJob_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "IndexingJob" ADD CONSTRAINT "IndexingJob_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "IndexingCategory"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "IndexingJob" ADD CONSTRAINT "IndexingJob_webhookConfigId_fkey" FOREIGN KEY ("webhookConfigId") REFERENCES "WebhookConfig"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DataStatistics" ADD CONSTRAINT "DataStatistics_jobId_fkey" FOREIGN KEY ("jobId") REFERENCES "IndexingJob"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WebhookConfig" ADD CONSTRAINT "WebhookConfig_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SyncLog" ADD CONSTRAINT "SyncLog_jobId_fkey" FOREIGN KEY ("jobId") REFERENCES "IndexingJob"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ApiKey" ADD CONSTRAINT "ApiKey_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
