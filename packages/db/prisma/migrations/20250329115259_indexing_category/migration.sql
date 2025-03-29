/*
  Warnings:

  - Made the column `database` on table `DatabaseConfig` required. This step will fail if there are existing NULL values in that column.
  - Made the column `username` on table `DatabaseConfig` required. This step will fail if there are existing NULL values in that column.
  - Made the column `password` on table `DatabaseConfig` required. This step will fail if there are existing NULL values in that column.

*/
-- DropForeignKey
ALTER TABLE "DatabaseConfig" DROP CONSTRAINT "DatabaseConfig_userId_fkey";

-- DropForeignKey
ALTER TABLE "IndexingPreference" DROP CONSTRAINT "IndexingPreference_userId_fkey";

-- AlterTable
ALTER TABLE "DatabaseConfig" ADD COLUMN     "connectionStatus" TEXT NOT NULL DEFAULT 'pending',
ADD COLUMN     "lastConnectionCheck" TIMESTAMP(3),
ADD COLUMN     "sslCertificate" TEXT,
ADD COLUMN     "sslEnabled" BOOLEAN NOT NULL DEFAULT false,
ALTER COLUMN "database" SET NOT NULL,
ALTER COLUMN "username" SET NOT NULL,
ALTER COLUMN "password" SET NOT NULL;

-- AlterTable
ALTER TABLE "IndexingPreference" ADD COLUMN     "dataRetentionDays" INTEGER NOT NULL DEFAULT 30,
ADD COLUMN     "maxSyncFrequency" TEXT NOT NULL DEFAULT 'realtime';

-- CreateTable
CREATE TABLE "IndexingCategory" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "dataStructure" JSONB NOT NULL,
    "sqlDefinition" TEXT NOT NULL,
    "webhookFilters" JSONB NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "version" TEXT NOT NULL DEFAULT '1.0.0',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "IndexingCategory_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "IndexingCategory_name_key" ON "IndexingCategory"("name");

-- AddForeignKey
ALTER TABLE "DatabaseConfig" ADD CONSTRAINT "DatabaseConfig_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "IndexingPreference" ADD CONSTRAINT "IndexingPreference_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
